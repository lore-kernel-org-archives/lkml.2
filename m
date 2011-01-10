Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1AJQFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:05:30 -0500
Received: from kroah.org ([198.145.64.141]:59655 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606Ab1AJQFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:05:24 -0500
Date: Mon, 10 Jan 2011 08:00:01 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 3/3] x86: usb handoff in early_quirk
Message-ID: <20110110160001.GC5275@kroah.com>
References: <4D2A1152.1040903@kernel.org>
 <4D2A13BC.3000003@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2A13BC.3000003@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 09, 2011 at 11:59:56AM -0800, Yinghai Lu wrote:
> 
> some systems keep getting
>   APIC calibration not consistent with PM-Timer: 139ms instead of 100ms
>   APIC delta adjusted to PM-Timer: 831249 (1163736)
> 
> USB legacy SMI handler is not disabled at that time.
> 
> Try to disable USB legacy support early with this patch.
> So later APIC Timer calibration don't get messed up by USB legacy support SMI handler.
> After this patch, that warning never show up for 100 reboot tests.

But is that warning a real issue?  Does it cause problems for the user
(becides annoying them of course)?

> reuse code from drivers/usb/host/pci-quirks.c
> with changes
> 1. delay and sleep  ===> io_delay
> 2. dev_warn etc to pr_warn(num, slot, func...)

Why change this function?  What's wrong with dev_warn()?  It's much more
descriptive of the device that is being referred to.

thanks,

greg k-h
