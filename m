Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab2GJMf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 08:35:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48568 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab2GJMfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 08:35:25 -0400
MIME-Version: 1.0
In-Reply-To: <1341919622.3462.124.camel@twins>
References: <1341826026-6504-1-git-send-email-vincent.guittot@linaro.org>
	<1341919622.3462.124.camel@twins>
Date: Tue, 10 Jul 2012 14:35:25 +0200
Message-ID: <CAKfTPtC0BcidJ2ga9c2fdWjrEsfXH48QtSnjv0YOCv7-k3K-Ug@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] ARM: topology: set the capacity of each cores for big.LITTLE
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yong.zhang0@gmail.com, namhyung@kernel.org, jean.pihet@newoldbits.com,
        mingo@kernel.org, Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 July 2012 13:27, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2012-07-09 at 11:27 +0200, Vincent Guittot wrote:
>> This patchset creates an arch_scale_freq_power function for ARM, which is used
>> to set the relative capacity of each core of a big.LITTLE system. It also removes
>> the broken power estimation of x86.
>>
>> Modification since v3:
>>  - Add comments
>>  - Add optimization for SMP system
>>  - Ensure that capacity of a CPU will be at most 1
>>
>> Modification since v2:
>>  - set_power_scale function becomes static
>>  - Rework loop in update_siblings_masks
>>  - Remove useless code in parse_dt_topology
>>
>> Modification since v1:
>>  - Add and update explanation about the use of the table and the range of the value
>>  - Remove the use of NR_CPUS and use nr_cpu_ids instead
>>  - Remove broken power estimation of x86
>>
>> Peter Zijlstra (1):
>>   sched, x86: Remove broken power estimation
>
> Note that this patch already made its way into tip as commit
> bcae21d6e793a7047d38abc9ac0946c53733c1dd so it might be best to base
> whatever tree this is supposed to fo into on something that includes
> that.
>

yes

>> Vincent Guittot (4):
>>   ARM: topology: Add arch_scale_freq_power function
>>   ARM: topology: factorize the update of sibling masks
>>   ARM: topology: Update cpu_power according to DT information
>>   sched: cpu_power: enable ARCH_POWER
>
> How would you like to proceed with these patches, I'm fine with them
> going through the ARM tree..

May be the last one which enable ARCH_POWER should also go into tip ?

>
> In which case:
>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> Ingo, Russell, any other preferences?

I'm going to push the patches related to ARM into Russell's patch system

Vincent
