Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab1BHMWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:22:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59818 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab1BHMWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:22:31 -0500
Date: Tue, 8 Feb 2011 13:21:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove CONFIG_PM altogether, enable power management all
 the time
Message-ID: <20110208122159.GA8284@elte.hu>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <201102072046.48763.rjw@sisk.pl>
 <20110207201803.GU10564@opensource.wolfsonmicro.com>
 <201102072215.59921.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102072215.59921.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> I'd appreciate it if people could review/test it and drop their comments.
> 
> Thanks,
> Rafael
> 
> ---
>  arch/x86/xen/Kconfig               |    2 +-
>  drivers/acpi/Kconfig               |    1 -
>  drivers/acpi/bus.c                 |    4 +---
>  drivers/acpi/internal.h            |    6 ++++++
>  drivers/acpi/sleep.c               |   13 +++++++++++--
>  drivers/base/power/Makefile        |    3 +--
>  drivers/net/e1000e/netdev.c        |    8 ++++----
>  drivers/net/pch_gbe/pch_gbe_main.c |    2 +-
>  drivers/pci/pci-driver.c           |    4 ++--
>  drivers/scsi/Makefile              |    2 +-
>  drivers/scsi/scsi_priv.h           |    2 +-
>  drivers/scsi/scsi_sysfs.c          |    2 +-
>  drivers/usb/core/hcd-pci.c         |    4 ++--
>  include/acpi/acpi_bus.h            |    2 +-
>  include/linux/pm.h                 |    2 +-
>  kernel/power/Kconfig               |   29 +++--------------------------
>  16 files changed, 37 insertions(+), 49 deletions(-)

Ok, there's some real bang for bucks in this patch, nice! It's a beginning.

Reviewed-by: Ingo Molnar <mingo@elte.hu>

Also, i've Cc:-ed Linus, to check whether the idea to make power management a 
permanent, core portion of Linux has any obvious downsides we missed.

Rafael, could you do a defconfig-ish x86 build with and without CONFIG_PM, and post 
the 'size vmlinux' comparison - so that we can see the size difference? We make some 
things CONFIG_EXPERT configurable just to enable folks who *really* want to cut down 
on kernel size to configure it out.

Note that those usecases, even if they want a super-small kernel, might not care 
about PM at all while they care about size: small boot kernels in ROMs, or simple 
devices where CPU-idling implies deep low power mode, etc.

So the vmlinux size comparisons would be needed really. If it's 5k nobody will care. 
If it's 50k-100k that's borderline. In the other side of the scale we have the 1500+
#ifdef CONFIG_PM lines strewn around the kernel source, and the frequent !PM build
breakages.

	Ingo
