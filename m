Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab2FMNUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:20:55 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41886 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab2FMNUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:20:54 -0400
MIME-Version: 1.0
In-Reply-To: <1339591819.8980.28.camel@twins>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
	<1339502524-10265-5-git-send-email-vincent.guittot@linaro.org>
	<1339591819.8980.28.camel@twins>
Date: Wed, 13 Jun 2012 15:20:53 +0200
Message-ID: <CAKfTPtCERCDdCSLyPAYAhxAB4wkDMVfMbfecv+vOMbgUXvYwYg@mail.gmail.com>
Subject: Re: [RFC 4/4] sched: cpu_power: enable ARCH_POWER
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 June 2012 14:50, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-06-12 at 14:02 +0200, Vincent Guittot wrote:
>> Heteregeneous ARM platform uses arch_scale_freq_power function
>> to reflect the relative capacity of each core
>
> I think I've pointed out before that this breaks x86.. you need a patch
> killing at that stuff before this.

In v3.4, x86 hasn't got any specific declaration for
arch_scale_freq_power so it would now use the weak
arch_scale_freq_power which calls default_scale_freq_power. Isn't it
enough ?

>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/features.h |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/features.h b/kernel/sched/features.h
>> index de00a48..d98ae90 100644
>> --- a/kernel/sched/features.h
>> +++ b/kernel/sched/features.h
>> @@ -42,7 +42,7 @@ SCHED_FEAT(CACHE_HOT_BUDDY, true)
>>  /*
>>   * Use arch dependent cpu power functions
>>   */
>> -SCHED_FEAT(ARCH_POWER, false)
>> +SCHED_FEAT(ARCH_POWER, true)
>>
>>  SCHED_FEAT(HRTICK, false)
>>  SCHED_FEAT(DOUBLE_TICK, false)
>
