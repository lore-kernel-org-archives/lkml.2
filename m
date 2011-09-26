Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab1IZPqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:46:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56807 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab1IZPqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:46:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Update the policy on default wakeup settings
Date: Mon, 26 Sep 2011 17:48:29 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1109261120350.1918-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1109261120350.1918-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109261748.29952.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 26, 2011, Alan Stern wrote:
> This patch (as1485) documents a change to the kernel's default wakeup
> policy.  Devices that forward wakeup requests between buses should be
> enabled for wakeup by default.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Applied to linux-pm/linux-next.

Thanks,
Rafael

> ---
> 
> Because of the unavailability of the linux-pm mailing list, I'm posting 
> this on LKML.
> 
> 
>  Documentation/power/devices.txt |    4 +++-
>  drivers/base/power/wakeup.c     |    4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> Index: usb-3.1/Documentation/power/devices.txt
> ===================================================================
> --- usb-3.1.orig/Documentation/power/devices.txt
> +++ usb-3.1/Documentation/power/devices.txt
> @@ -152,7 +152,9 @@ try to use its wakeup mechanism.  device
>  for the most part drivers should not change its value.  The initial value of
>  should_wakeup is supposed to be false for the majority of devices; the major
>  exceptions are power buttons, keyboards, and Ethernet adapters whose WoL
> -(wake-on-LAN) feature has been set up with ethtool.
> +(wake-on-LAN) feature has been set up with ethtool.  It should also default
> +to true for devices that don't generate wakeup requests on their own but merely
> +forward wakeup requests from one bus to another (like PCI bridges).
>  
>  Whether or not a device is capable of issuing wakeup events is a hardware
>  matter, and the kernel is responsible for keeping track of it.  By contrast,
> Index: usb-3.1/drivers/base/power/wakeup.c
> ===================================================================
> --- usb-3.1.orig/drivers/base/power/wakeup.c
> +++ usb-3.1/drivers/base/power/wakeup.c
> @@ -276,7 +276,9 @@ EXPORT_SYMBOL_GPL(device_set_wakeup_capa
>   *
>   * By default, most devices should leave wakeup disabled.  The exceptions are
>   * devices that everyone expects to be wakeup sources: keyboards, power buttons,
> - * possibly network interfaces, etc.
> + * possibly network interfaces, etc.  Also, devices that don't generate their
> + * own wakeup requests but merely forward requests from one bus to another
> + * (like PCI bridges) should have wakeup enabled by default.
>   */
>  int device_init_wakeup(struct device *dev, bool enable)
>  {
> 
> 
> 

