Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0GMKOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 06:14:23 -0400
Received: from ozlabs.org ([203.10.76.45]:48281 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab0GMKOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 06:14:22 -0400
Date: Tue, 13 Jul 2010 20:12:42 +1000
From: Anton Blanchard <anton@samba.org>
To: The development of GNU GRUB <grub-devel@gnu.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix for relocatable PowerPC kernels
Message-ID: <20100713101242.GA15491@kryten>
References: <20100713054523.GC10155@kryten>
 <4C3C3018.3080508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3C3018.3080508@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> Is building as ET_DYN supported upstream? We previously had reports of
> building system of some distros to be plainly borked and usualy the
> distro fixed their building system pretty fast. If upstream supports
> ET_DYN, then this patch is accepted with no further questions. But if
> it's a borked building system it may have subtle bugs and allowing it
> would probably just suppress an early symptom of other problems.

This is supported upstream on a number of architectures, for example
the PowerPC configuration option is:

config RELOCATABLE
        bool "Build a relocatable kernel"
        help
          This builds a kernel image that is capable of running anywhere
          in the RMA (real memory area) at any 16k-aligned base address.
          The kernel is linked as a position-independent executable (PIE)
          and contains dynamic relocations which are processed early
          in the bootup process.

          One use is for the kexec on panic case where the recovery kernel
          must live at a different physical address than the primary
          kernel.

Regards,
Anton

> > 2010-07-13  Anton Blanchard  <anton@samba.org>
> >
> > 	* loader/powerpc/ieee1275/linux.c (grub_cmd_linux): Do not reject
> > 	ET_DYN files.
> >
> > Index: grub/loader/powerpc/ieee1275/linux.c
> > ===================================================================
> > --- grub.orig/loader/powerpc/ieee1275/linux.c	2010-07-11 12:05:16.443242734 +1000
> > +++ grub/loader/powerpc/ieee1275/linux.c	2010-07-12 14:56:20.301991065 +1000
> > @@ -220,7 +220,7 @@ grub_cmd_linux (grub_command_t cmd __att
> >    if (! elf)
> >      goto out;
> >  
> > -  if (elf->ehdr.ehdr32.e_type != ET_EXEC)
> > +  if (elf->ehdr.ehdr32.e_type != ET_EXEC && elf->ehdr.ehdr32.e_type != ET_DYN)
> >      {
> >        grub_error (GRUB_ERR_UNKNOWN_OS,
> >  		  "this ELF file is not of the right type");
