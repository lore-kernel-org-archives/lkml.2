Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab2LUKHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 05:07:47 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57239 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab2LUKHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 05:07:39 -0500
Message-ID: <50D43502.1070402@ti.com>
Date: Fri, 21 Dec 2012 15:38:02 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <nico@linaro.org>, <marc.zyngier@arm.com>, <will.deacon@arm.com>,
        <john.stultz@linaro.org>, <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/5] clockevents: decouple broadcast mechanism from
 drivers
References: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Tuesday 18 December 2012 05:36 PM, Mark Rutland wrote:
> In some SMP systems, cpu-local timers may stop delivering interrupts
> when in low power states, or not all CPUs may have local timers. To
> support these systems we have a mechanism for broadcasting timer ticks
> to other CPUs. This mechanism relies on the struct
> clock_event_device::broadcast function pointer, which is a
> driver-specific mechanism for broadcasting ticks to other CPUs.
>
> As the broadcast mechanism is architecture-specific, placing the
> broadcast function on struct clock_event_device ties each driver to a
> single architecture. Additionally the driver or architecture backend
> must handle the routing of broadcast ticks to the correct
> clock_event_device, leading to duplication of the list of active
> clock_event_devices.
>
> These patches introduce a generic mechanism for handling the receipt of
> timer broadcasts, and an optional architecture-specific broadcast
> function which allows drivers to be decoupled from a particular
> architecture will retaining support for timer tick broadcasts. These
> mechanisms are wired up for the arm port, and have been boot-tested on a
> pandaboard.
>
Apart from the relevant comments given against couple of patches and
Stephen's printk string comment, the series looks pretty good to me.

I have tested the series with CPUIdle where the broadcast is actually
used actively.

So feel free to add,
Reviewed-tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

