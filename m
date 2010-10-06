Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab0JFDgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 23:36:50 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13183 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647Ab0JFDgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 23:36:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6127"; a="56864612"
Message-ID: <4CABEECF.9080009@codeaurora.org>
Date: Tue, 05 Oct 2010 20:36:47 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Colin Cross <ccross@android.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH 3/3] [ARM] Implement a timer based __delay() loop
References: <1285644827-6846-1-git-send-email-sboyd@codeaurora.org>	 <1285644827-6846-4-git-send-email-sboyd@codeaurora.org> <1286300338.18791.26.camel@c-dwalke-linux.qualcomm.com>
In-Reply-To: <1286300338.18791.26.camel@c-dwalke-linux.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/05/2010 10:38 AM, Daniel Walker wrote:
>>  
>> +#ifdef ARCH_HAS_READ_CURRENT_TIMER
>> +/*
>> + * Assuming read_current_timer() is monotonically increasing
>> + * across calls.
> You should add more comments here. You assuming that it's monotonic over
> a 2000us (2ms) period .. I'm not sure this is a good assumption this
> timer may not be monotonically increasing all the time, what happens
> then?

Ok I'll add that it shouldn't wrap more than once within 2000us (or
should I say 5ms since mdelay uses udelay?). Is that what you're saying
by it not being monotonically increasing? If a timer isn't increasing
the tick count it's broken and this call will loop forever. If the timer
wraps, we'll be safe due to unsigned maths as long as it wraps only once.

>> +void read_current_timer_delay_loop(unsigned long loops)
>> +{
>> +	unsigned long bclock, now;
>> +
>> +	read_current_timer(&bclock);
>> +	do {
>> +		read_current_timer(&now);
>> +	} while ((now - bclock) < loops);
> Have you looked at time_before()/time_after() ?

Nope. Wouldn't that require an addition though to make it work? I'd
rather just leave it like it is.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

