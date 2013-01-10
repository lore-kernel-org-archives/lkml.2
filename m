Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3AJQSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:18:42 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:59132 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3AJQSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:18:41 -0500
MIME-Version: 1.0
In-Reply-To: <20130110142245.GE19944@n2100.arm.linux.org.uk>
References: <1357783059-13923-1-git-send-email-ccross@android.com>
	<20130110140215.GP88797@redhat.com>
	<20130110142245.GE19944@n2100.arm.linux.org.uk>
Date: Thu, 10 Jan 2013 17:18:40 +0100
Message-ID: <CAFTL4hw_aRB8837stPgABFwHd9ifVqtV5Z5zX9MJ8rSFTSPNog@mail.gmail.com>
Subject: Re: [PATCH] hardlockup: detect hard lockups without NMIs using
 secondary cpus
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Don Zickus <dzickus@redhat.com>, Colin Cross <ccross@android.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        liu chuansheng <chuansheng.liu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/10 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Thu, Jan 10, 2013 at 09:02:15AM -0500, Don Zickus wrote:
>> On Wed, Jan 09, 2013 at 05:57:39PM -0800, Colin Cross wrote:
>> > Emulate NMIs on systems where they are not available by using timer
>> > interrupts on other cpus.  Each cpu will use its softlockup hrtimer
>> > to check that the next cpu is processing hrtimer interrupts by
>> > verifying that a counter is increasing.
>> >
>> > This patch is useful on systems where the hardlockup detector is not
>> > available due to a lack of NMIs, for example most ARM SoCs.
>>
>> I have seen other cpus, like Sparc I think, create a 'virtual NMI' by
>> reserving an IRQ line as 'special' (can not be masked).  Not sure if that
>> is something worth looking at here (or even possible).
>
> No it isn't, because that assumes that things like spin_lock_irqsave()
> won't mask that interrupt.  We don't have the facility to do that.

I believe sparc is doing something like this though. Look at
arch/sparc/include/asm/irqflags_64.h, it seems NMIs are implemented
there using an irq number that is not masked by this function.

Not all archs can do that so easily I guess.
