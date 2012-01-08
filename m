Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2AHQZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 11:25:27 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33922 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab2AHQZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 11:25:25 -0500
MIME-Version: 1.0
X-Originating-IP: [79.181.26.205]
In-Reply-To: <20120108161212.GD21765@n2100.arm.linux.org.uk>
References: <1326029549-2794-1-git-send-email-gilad@benyossef.com>
	<1326029549-2794-2-git-send-email-gilad@benyossef.com>
	<20120108161212.GD21765@n2100.arm.linux.org.uk>
Date: Sun, 8 Jan 2012 18:25:24 +0200
Message-ID: <CAOtvUMddvPVQTaUQAmGOgx9Wz18ewVWG5nRouYaDuFWe13pX4g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/9] arm: avoid using on_each_cpu hard coded ret value
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 6:12 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

<SNIP>

>> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
>> index 5bb91bf..6e9acb7 100644
>> --- a/arch/arm/kernel/perf_event.c
>> +++ b/arch/arm/kernel/perf_event.c
>> @@ -616,7 +616,7 @@ static int __init
>>  cpu_pmu_reset(void)
>>  {
>>       if (cpu_pmu && cpu_pmu->reset)
>> -             return on_each_cpu(cpu_pmu->reset, NULL, 1);
>> +             on_each_cpu(cpu_pmu->reset, NULL, 1);
>
> There's not much to review here...

Oh, I've introduced fatal bugs with less... :-)

Thanks for the review.
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
