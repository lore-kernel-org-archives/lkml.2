Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab1BHVYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 16:24:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54951 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab1BHVYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 16:24:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/5] Re: Remove CONFIG_PM altogether, enable power management all the time
Date: Tue, 8 Feb 2011 22:18:27 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com> <201102072215.59921.rjw@sisk.pl> <20110208122159.GA8284@elte.hu>
In-Reply-To: <20110208122159.GA8284@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102082218.28015.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 08, 2011, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > I'd appreciate it if people could review/test it and drop their comments.
> > 
> > Thanks,
> > Rafael
> > 
> > ---
> >  arch/x86/xen/Kconfig               |    2 +-
> >  drivers/acpi/Kconfig               |    1 -
> >  drivers/acpi/bus.c                 |    4 +---
> >  drivers/acpi/internal.h            |    6 ++++++
> >  drivers/acpi/sleep.c               |   13 +++++++++++--
> >  drivers/base/power/Makefile        |    3 +--
> >  drivers/net/e1000e/netdev.c        |    8 ++++----
> >  drivers/net/pch_gbe/pch_gbe_main.c |    2 +-
> >  drivers/pci/pci-driver.c           |    4 ++--
> >  drivers/scsi/Makefile              |    2 +-
> >  drivers/scsi/scsi_priv.h           |    2 +-
> >  drivers/scsi/scsi_sysfs.c          |    2 +-
> >  drivers/usb/core/hcd-pci.c         |    4 ++--
> >  include/acpi/acpi_bus.h            |    2 +-
> >  include/linux/pm.h                 |    2 +-
> >  kernel/power/Kconfig               |   29 +++--------------------------
> >  16 files changed, 37 insertions(+), 49 deletions(-)
> 
> Ok, there's some real bang for bucks in this patch, nice! It's a beginning.
> 
> Reviewed-by: Ingo Molnar <mingo@elte.hu>

In the meantime I've split it into a series of patches that should make it a
bit easier to diagnose problems, if there are any.  I'll post those patches
in replies to this message:

[1/5] - Deal with dependencies on CONFIG_PM in ACPI
[2/5] - Redefine CONFIG_PM as (CONFIG_PM_SLEEP || CONFIG_PM_RUNTIME)
[3/5] - Reorder options in kernel/power/Kconfig
[4/5] - Replace CONFIG_PM_OPS with CONFIG_PM
[5/5] - Clean up dependencies in kernel/power/Kconfig

> Also, i've Cc:-ed Linus, to check whether the idea to make power management a 
> permanent, core portion of Linux has any obvious downsides we missed.
>
> Rafael, could you do a defconfig-ish x86 build with and without CONFIG_PM, and post 
> the 'size vmlinux' comparison - so that we can see the size difference? We make some 
> things CONFIG_EXPERT configurable just to enable folks who *really* want to cut down 
> on kernel size to configure it out.

Sure, I will.

Thanks,
Rafael
