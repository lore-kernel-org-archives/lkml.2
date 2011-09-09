Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637Ab1IIS1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:27:44 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:57504 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759547Ab1IIS1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:27:43 -0400
From: Kevin Hilman <khilman@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <b-cousson@ti.com>, <paul@pwsan.com>, <johnstul@us.ibm.com>,
        <vishwanath.bs@ti.com>, Kishon Vijay Abraham <kishon@ti.com>
Subject: Re: [PATCH 1/2] arm: omap: usb: enable I/O wakeups of ehci and ohci hwmods of omap4
Organization: Texas Instruments, Inc.
References: <1315579967-24945-1-git-send-email-keshava_mgowda@ti.com>
	<1315579967-24945-2-git-send-email-keshava_mgowda@ti.com>
Date: Fri, 09 Sep 2011 11:27:37 -0700
In-Reply-To: <1315579967-24945-2-git-send-email-keshava_mgowda@ti.com>
	(Keshava Munegowda's message of "Fri, 9 Sep 2011 20:22:46 +0530")
Message-ID: <87mxedwoyu.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keshava Munegowda <keshava_mgowda@ti.com> writes:

> From: Kishon Vijay Abraham <kishon@ti.com>
>
> For ehci and ohci hwmods, the omap4 I/O wakeup capablity is enabled.
> for ehci in phy mode,
> 	- the DAT0 and DIR I/O pad is set as wakeup capable
> for ohci in serial mode
> 	- usbb*_mm_rxdp is set as I/O wakeup for 6 pin serial mode
> 	- usbb*_mm_rxrcv is set as I/O wakeup for 4 pin serial mode
> 	- usbb*_mm_txen is set as I/O wakeup for 3 pin serial mode
> 	- usbb*_mm_txdat is set as I/O wakeup for 2 pin serial mode
>
> Signed-off-by: Kishon Vijay Abraham <kishon@ti.com>
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>

What if the end user doesn't want this device to be a wakeup source?

Currently, the IO pad wakeup for these pins is enabled unconditionally.
While having it enabled as a wakeup source by default is fine, it should
not generate wakeups if the user has disable them by doing:

    $ echo disabled > /sys/devices/.../power/wakeup

IOW, whether wakeups are enabled or not should depend on the driver
checking device_may_wakeup()

Kevin
