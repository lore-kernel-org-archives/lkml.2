Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab0DSOaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:30:09 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:48524 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab0DSOaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:30:06 -0400
X-Spam-Flag: NO
X-Spam-Score: -24.389
Message-ID: <4BCC68E8.8080005@tremplin-utc.net>
Date: Mon, 19 Apr 2010 16:30:00 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100331 Mandriva/3.0.4-1mdv2010.1 (2010.1) Thunderbird/3.0.4
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with ondemand
 during disk IO
References: <20100418115949.7b743898@infradead.org>	<20100418120346.1b478410@infradead.org>	<4BCC147B.10708@tremplin-utc.net> <20100419064325.49cb3108@infradead.org>
In-Reply-To: <20100419064325.49cb3108@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/04/10 15:43, Arjan van de Ven wrote:
> On Mon, 19 Apr 2010 10:29:47 +0200
> Éric Piel <eric.piel@tremplin-utc.net> wrote:
>>>
>>> The problem and fix are both verified with the "perf timechar" tool.
>> Hi,
>> I don't doubt that keeping the cpu full frequency during IO can
>> improve some specific workloads, however in your log message you
>> don't explain how much we are loosing.
> 
> first of all, it's so bad that people will just turn the whole power
> management off... at which point fixing the really bad bug is actually
> quite a win 
Fair enough, and I have to fully agree, it's better to have a power
management which consumes a bit more than the unreachable optimal, than
having everyone switch it off completely.


>> How much more energy is consumed when doing a "updatedb" or "find /" ?
> 
> on the machines I used this on (Core i7's) it's actually hardly
> measurable. All CPUs I have access to turn the voltage entirely off
> during idle, so while the frequency is higher, if you're mostly IO
> bound, it's only for very short durations... while still being mostly
> "off".
Yes, but keep in mind the Linux ondemand governor should not be tweaked
only for the latest Intel CPUs. I've just done a very little and
_extremely rough_ measurement on my laptop with a Core Duo 2, and while
it seems that, indeed, at idle the frequency didn't matter for the
consumption (about 12.5W with any governor), when running updatedb (so
IO bound), the performance governor seems to consume more than ondemand
and powersave (14.8-15.8W instead of 14.0-14.6W). I'm very careful with
the results of this "experiment" because it's only using the ACPI report
for the power usage and done with many other programs in the background.
Nevertheless, it manages to convince me that this change is not going to
be as harmless for the power consumption as you suggest.

Don't take me wrong. Here, I'm not saying that this patch is bad per se.
In particular, I do understand the specific workloads it tries to
handle, and I don't have a better solution for it in mind. However, this
is quite a change in the ondemand governor logic, and the log message do
not mention anything about energy consumption. This triggers a big
warning "only half of the problem was looked at to get a solution"!

So if this patch ever goes in, it should at least have a better
changelog which describes what are the potential consequences on the
power consumption.

Cheers,
Eric
