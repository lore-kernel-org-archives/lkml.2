Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1FTM5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 08:57:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43305 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab1FTM5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 08:57:36 -0400
Date: Mon, 20 Jun 2011 13:57:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: smp: Fix the CPU hotplug race with scheduler.
Message-ID: <20110620125715.GK2082@n2100.arm.linux.org.uk>
References: <20110620101438.GD2082@n2100.arm.linux.org.uk> <4DFF20B3.7010209@ti.com> <20110620104415.GF2082@n2100.arm.linux.org.uk> <4DFF255E.5030308@ti.com> <20110620111336.GG2082@n2100.arm.linux.org.uk> <4DFF2E37.8030602@ti.com> <20110620114019.GH2082@n2100.arm.linux.org.uk> <4DFF3454.30507@ti.com> <20110620121939.GI2082@n2100.arm.linux.org.uk> <4DFF3C95.1080903@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFF3C95.1080903@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 05:57:01PM +0530, Santosh Shilimkar wrote:
> On 6/20/2011 5:49 PM, Russell King - ARM Linux wrote:
>> On Mon, Jun 20, 2011 at 05:21:48PM +0530, Santosh Shilimkar wrote:
>>> On 6/20/2011 5:10 PM, Russell King - ARM Linux wrote:
>
> [...]
>
>>>
>>> Any pointers on the other question about "why we need to enable
>>> interrupts before the CPU is ready?"
>>
>> To ensure that things like the delay loop calibration and twd calibration
>> can run, though that looks like it'll run happily enough with the boot
>> CPU updating jiffies.
>>
> I guessed it and had same point as above. Calibration will still
> work.
>
>> However, I'm still not taking your patch because I believe its just
>> papering over the real issue, which is not as you describe.
>>
>> You first need to work out why the spinlock lockup detection is firing
>> after just 61us rather than the full 1s and fix that.
>>
> This is possibly because of my script which doesn't wait for 1
> second.

How could a userspace script affect the internal behaviour of
spin_lock() and the spinlock lockup detector?

> Latest mainline kernel with omap2plus_defconfig and below simple script
> to trigger the failure.
>
> -------------
> while true
> do
> echo 0 > /sys/devices/system/cpu/cpu1/online
> echo 1 > /sys/devices/system/cpu/cpu1/online
> done

Thanks, I'll give it a go here and see if I can debug it further.
