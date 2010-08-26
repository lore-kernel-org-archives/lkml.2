Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab0HZIzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 04:55:55 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:36065 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab0HZIzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 04:55:53 -0400
Subject: Re: [PATCH] Fix initramfs size calculation
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, mmarek@suse.cz, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
In-Reply-To: <20100825195639.GA2263@merkur.ravnborg.org>
References: <1282751832.3676.17.camel@holzheu-laptop>
	 <20100825180601.GA2116@merkur.ravnborg.org>
	 <20100825191530.GF4227@linux.vnet.ibm.com>
	 <20100825195639.GA2263@merkur.ravnborg.org>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Thu, 26 Aug 2010 10:55:47 +0200
Message-ID: <1282812947.1879.17.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

On Wed, 2010-08-25 at 21:56 +0200, Sam Ravnborg wrote:
> On Wed, Aug 25, 2010 at 09:15:32PM +0200, Hendrik Brueckner wrote:
> > Sam,
> > 
> > I have work together with Michael on this patch... see my comments below
> > 
> > On Wed, Aug 25, 2010 at 08:06:01PM +0200, Sam Ravnborg wrote:
> > > On Wed, Aug 25, 2010 at 05:57:12PM +0200, Michael Holzheu wrote:
> > > 
> > > Another way to fix this could be to align . to an even
> > > address like this:
> > > > #define INIT_RAM_FS                                                     \
> > > >         . = ALIGN(PAGE_SIZE);                                           \
> > > >         VMLINUX_SYMBOL(__initramfs_start) = .;                          \
> > > >         *(.init.ramfs)                                                  \
> > >           . = ALIGN(32);                                                  \
> > > >         VMLINUX_SYMBOL(__initramfs_end) = .;
> > > > 
> > > 
> > > 32 was selected as this is what we will introduce as the default
> > > alignment in linker scripts anyway.
> > >
> > > This I guess is a problem we have had some time and a minimal fix is
> > > easier to have backported by the stable team.
> > 
> > The first thought was similar but using ALIGN(2).  However, the current
> > implementation of populate_rootfs() passes the calculated size to the
> > decompress functions.  If __initramfs_end is aligned, the resulting size
> > might be greater than the real size of the initramfs.
> > So I guess this might also cause problems.
> Another variant could be to explicit add alignment in the .S files
> so the section is always aligned to a even byte boundary (or maybe 32 byte boundary).

Then still the unpack_to_rootfs() function will not get the correct size
of the compressed file, because "__initramfs_end - __initramfs_start"
can be bigger than the real file size depending on the used the
alignment. I would assume that not all decompression functions will
work, if a bigger value is passed to decompress_method().

Michael




