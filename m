Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab2BHPZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 10:25:16 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36376 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab2BHPZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 10:25:15 -0500
Date: Wed, 8 Feb 2012 15:24:57 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
        Venki Pallipadi <venki@google.com>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] sched: generalize CONFIG_IRQ_TIME_ACCOUNTING for X86
	and ARM
Message-ID: <20120208152457.GN889@n2100.arm.linux.org.uk>
References: <1328705314-20978-1-git-send-email-dmitry.antipov@linaro.org> <20120208131833.GK889@n2100.arm.linux.org.uk> <4F32918E.9000905@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F32918E.9000905@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 07:15:26AM -0800, Dmitry Antipov wrote:
> On 02/08/2012 05:18 AM, Russell King - ARM Linux wrote:
>> Why are you placing this here?  sched_clock is available from the point
>> that it's registered, which should be before the first sched_clock()
>> call.
>
> This is just because I'm thinking about:
>
> if (read_sched_clock == jiffy_sched_clock_read)
>         setup_sched_clock(jiffy_sched_clock_read, 32, HZ);
> else if (!no_sched_irq_time)
> 	enable_sched_clock_irqtime();
>
> I suppose that "fine granularity task irq time accounting"
> makes no sense if sched_clock() granularity is poor.

Let me put it a different way - is there a reason not to do this in
setup_sched_clock() so that it becomes available as soon as sched_clock()
has been initialized by a platform?
