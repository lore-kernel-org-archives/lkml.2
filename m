Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1IUNYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:24:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37156 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab1IUNYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:24:15 -0400
Date: Wed, 21 Sep 2011 08:24:12 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, Azael Avalos <coproscefalo@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] toshiba_acpi: Convert to use acpi_driver
Message-ID: <20110921132412.GB23254@thinkpad-t410>
Mail-Followup-To: Corentin Chary <corentin.chary@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Azael Avalos <coproscefalo@gmail.com>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1316555754-25949-1-git-send-email-seth.forshee@canonical.com>
 <1316555754-25949-2-git-send-email-seth.forshee@canonical.com>
 <CAHR064iA1877cF1rmUhX_41U_yjRGs6siswpoMPjs=WEYEm8cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHR064iA1877cF1rmUhX_41U_yjRGs6siswpoMPjs=WEYEm8cQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 09:28:30AM +0200, Corentin Chary wrote:
> On Tue, Sep 20, 2011 at 11:55 PM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> > Changes toshiba_acpi to register an acpi driver and eliminates the
> > platform device it was using.
> 
> Why to you want to remove the platform device ? If you want to create
> a sysfs interface later, you'll probably need it. Most of the platform
> driver I know only use the acpi_device to send proc/netlink events and
> the platform_device is used everywhere else. (And anyway, it's an x86
> *platform* driver, not a pure acpi driver).

I removed the platform device because it seems a bit redundant to have
both, and I don't see what benefit it really provides. I see your point
that conceptually it makes sense to have it has a platform device,
although the distinction there is pretty fine.

Anyway, I guess the cost of keeping the platform device in place is
pretty small, so I can add it back in if that's desirable.

> > Also eliminates most global
> > variables, moving them into toshiba_acpi_dev, along with some
> > other miscellaneous fixes and cleanup.
> 
> Good ! Next step would be to deprecate the /proc interface (keeping it
> for compatibility) and adding a new shinny
> /sys/platform/device/toshiba-acpi/ interface correctly documented in
> Documentation/ABI/ :).

I was avoiding chainging any userspace interfaces in this first round of
patches, but deprecating the proc interface is definitely something I'd
like to do. I don't know if there's any point to moving it to sysfs
though. Most of it already has sysfs interfaces via device classes, and
I don't know that there's any value in the rest of it.

Thanks,
Seth
