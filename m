Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab1BAW0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:26:39 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:22013 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998Ab1BAW0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:26:37 -0500
Date: Tue, 1 Feb 2011 14:26:37 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: Early crash (was: Re: module: show version information for
 built-in modules in sysfs)
Message-ID: <20110201222637.GA17521@dtor-ws.eng.vmware.com>
References: <AANLkTin4gOnEMruLDM=TkNYsNf5S370WqbcDVJzT7_Z4@mail.gmail.com>
 <20110201210944.GA12348@dtor-ws.eng.vmware.com>
 <AANLkTimv=KqtuR36dMNa+=OMi0mgd8JK4qsb_SpmKmhs@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimv=KqtuR36dMNa+=OMi0mgd8JK4qsb_SpmKmhs@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 02:03:23PM -0800, Geert Uytterhoeven wrote:
> On Tue, Feb 1, 2011 at 22:09, Dmitry Torokhov <dtor@vmware.com> wrote:
> > On Tue, Feb 01, 2011 at 12:33:29PM -0800, Geert Uytterhoeven wrote:
> >> On Mon, Jan 24, 2011 at 11:59, Linux Kernel Mailing List
> >> <linux-kernel@vger.kernel.org> wrote:
> >> > Gitweb:     http://git.kernel.org/linus/e94965ed5beb23c6fabf7ed31f625e66d7ff28de
> >>
> >> >    module: show version information for built-in modules in sysfs
> >> >
> >> >    Currently only drivers that are built as modules have their versions
> >> >    shown in /sys/module/<module_name>/version, but this information might
> >> >    also be useful for built-in drivers as well. This especially important
> >> >    for drivers that do not define any parameters - such drivers, if
> >> >    built-in, are completely invisible from userspace.
> >> >
> >> >    This patch changes MODULE_VERSION() macro so that in case when we are
> >> >    compiling built-in module, version information is stored in a separate
> >> >    section. Kernel then uses this data to create 'version' sysfs attribute
> >> >    in the same fashion it creates attributes for module parameters.
> >>
> >> This commit causes the crash below on m68k (ARAnyM).
> >> Reverting this commit and its dependency
> >> 3b90a5b292321b2acac3921f77046ae195aef53f
> >> ("module: fix linker error for MODULE_VERSION when !MODULE and CONFIG_SYSFS=n")
> >> makes it boot again.
> >>
> >
> > Hi Geert,
> >
> > Does the follwing help by any chance?
> >
> > From d6fd4a6e0fc2d3f0a74962d4a6f663a46d230ecd Mon Sep 17 00:00:00 2001
> > diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
> > index ef33213..47e15eb 100644
> > --- a/arch/m68knommu/kernel/vmlinux.lds.S
> > +++ b/arch/m68knommu/kernel/vmlinux.lds.S
> 
> The crash happened on m68k with MMU, not m68knommu.
> 

Hmm, OK then. Could you please see if the crash happens if you return
early in kernel/params.c::version_sysfs_builtin() ? Also, do you see
anything in __modev section of your build?

Thanks,
Dmitry

