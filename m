Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab1E3BkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 21:40:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47099 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab1E3BkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 21:40:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE2F577.3000105@jp.fujitsu.com>
Date: Mon, 30 May 2011 10:40:07 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: a.p.zijlstra@chello.nl
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, efault@gmx.de,
        mingo@elte.hu
Subject: Re: [PATCH] cpumask: convert cpumask_of_cpu() with cpumask_of()
References: <1303814572.20212.249.camel@twins>	 <20110426203520.F3AE.A69D9226@jp.fujitsu.com>	 <20110427193419.D17F.A69D9226@jp.fujitsu.com> <1306442327.2497.108.camel@laptop>
In-Reply-To: <1306442327.2497.108.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The trick is,
>>  - Typical linux userland applications don't use mempolicy and/or cpusets
>>    API at all.
>>  - Then, 99.99% thread's  tsk->cpus_alloed have cpu_all_mask.
>>  - cpu_all_mask case, every thread can share the same bitmap. It may help to
>>    reduce L1 cache miss in scheduler.
>>
>> What do you think? 
> 
> Nice!
> 
> If you finish the first patch (sort the TODOs) I'll take it.

Yeah, now I'm submitting a lot of cpumask cleanup patches to various arch and
subsystems. So, I expect I can finish this work in June.

> I'm unsure about the PF_THREAD_UNBOUND thing though, then again, the
> alternative is adding another struct cpumask * and have that point to
> the shared mask or the private mask.

Ahhh, I'm sorry. My explanation was bad. PF_THREAD_UNBOUND is not my point.
It's only concept proof patch, not for submitting. yes, I did cheat for getting
number easily. I think the good way is probably to add another cpumask* and
implement COW shared mask. but I'm ok other way too.


> But yeah, looks quite feasible.

Thank you to pay attention my patch!

