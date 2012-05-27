Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab2E0UDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 16:03:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52614 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2E0UDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 16:03:07 -0400
Date: Mon, 28 May 2012 05:02:43 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@iki.fi>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: Re: [ 76/94] x86, realmode: 16-bit real-mode code support for relocs
 tool
Message-ID: <20120527200243.GC30052@kroah.com>
References: <20120527010434.469185530@linuxfoundation.org>
 <1338136652.20487.95.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338136652.20487.95.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 05:37:32PM +0100, Ben Hutchings wrote:
> On Sun, 2012-05-27 at 10:05 +0900, Greg KH wrote:
> > 3.3-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: "H. Peter Anvin" <hpa@linux.intel.com>
> > 
> > commit 6520fe5564acf07ade7b18a1272db1184835c487 upstream.
> > 
> > A new option is added to the relocs tool called '--realmode'.
> > This option causes the generation of 16-bit segment relocations
> > and 32-bit linear relocations for the real-mode code. When
> > the real-mode code is moved to the low-memory during kernel
> > initialization, these relocation entries can be used to
> > relocate the code properly.
> > 
> > In the assembly code 16-bit segment relocations must be relative
> > to the 'real_mode_seg' absolute symbol. Linear relocations must be
> > relative to a symbol prefixed with 'pa_'.
> > 
> > 16-bit segment relocation is used to load cs:ip in 16-bit code.
> > Linear relocations are used in the 32-bit code for relocatable
> > data references. They are declared in the linker script of the
> > real-mode code.
> > 
> > The relocs tool is moved to arch/x86/tools/relocs.c, and added new
> > target archscripts that can be used to build scripts needed building
> > an architecture.  be compiled before building the arch/x86 tree.
> > 
> > [ hpa: accelerating this because it detects invalid absolute
> >   relocations, a serious bug in binutils 2.22.52.0.x which currently
> >   produces bad kernels. ]
> >
> > [ jsakkine: applied against 3.3.7 ]
> [...]
> 
> Are these relocs patches worth applying to 3.2.y as well?  This one
> needs backporting (see attached).  The following 5 can be cleanly
> cherry-picked after that.

I think so, as they have turned up problems in toolchains that people are
using to build the kernel incorrectly.  But it's your call to add them
or not because they are pretty big.

greg k-h
