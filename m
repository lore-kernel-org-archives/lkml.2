Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0HYTPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 15:15:39 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:51409 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0HYTPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 15:15:37 -0400
Date: Wed, 25 Aug 2010 21:15:32 +0200
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, mmarek@suse.cz, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, brueckner@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com
Subject: Re: [PATCH] Fix initramfs size calculation
Message-ID: <20100825191530.GF4227@linux.vnet.ibm.com>
Mail-Followup-To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
	vda.linux@googlemail.com, mmarek@suse.cz, hpa@linux.intel.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
References: <1282751832.3676.17.camel@holzheu-laptop> <20100825180601.GA2116@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100825180601.GA2116@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

I have work together with Michael on this patch... see my comments below

On Wed, Aug 25, 2010 at 08:06:01PM +0200, Sam Ravnborg wrote:
> On Wed, Aug 25, 2010 at 05:57:12PM +0200, Michael Holzheu wrote:
> 
> Another way to fix this could be to align . to an even
> address like this:
> > #define INIT_RAM_FS                                                     \
> >         . = ALIGN(PAGE_SIZE);                                           \
> >         VMLINUX_SYMBOL(__initramfs_start) = .;                          \
> >         *(.init.ramfs)                                                  \
>           . = ALIGN(32);                                                  \
> >         VMLINUX_SYMBOL(__initramfs_end) = .;
> > 
> 
> 32 was selected as this is what we will introduce as the default
> alignment in linker scripts anyway.
>
> This I guess is a problem we have had some time and a minimal fix is
> easier to have backported by the stable team.

The first thought was similar but using ALIGN(2).  However, the current
implementation of populate_rootfs() passes the calculated size to the
decompress functions.  If __initramfs_end is aligned, the resulting size
might be greater than the real size of the initramfs.
So I guess this might also cause problems.

> > The patch also restructures the "usr/initramfs_data.xxx.S" files to use a
> > common macro that includes the (compressed) initramfs file and calculates
> > the __initramfs_size.
> I like this anyway. Could you do this as a separate patch?

I think that Michael or me could do this.


Kind regards,
Hendrik
