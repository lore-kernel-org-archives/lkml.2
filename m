Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2KLIXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 03:23:13 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:51377 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2KLIXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 03:23:12 -0500
MIME-Version: 1.0
In-Reply-To: <5093A7C5.9080605@ti.com>
References: <1349595838-31274-1-git-send-email-vincent.guittot@linaro.org>
	<1349595838-31274-7-git-send-email-vincent.guittot@linaro.org>
	<50880795.4030609@ti.com>
	<CAKfTPtAZjLpwHYgj8JXku4sU0mPPf34MKkWp0=qiX5u-T0JVOA@mail.gmail.com>
	<5093A7C5.9080605@ti.com>
Date: Mon, 12 Nov 2012 09:23:10 +0100
Message-ID: <CAKfTPtD4HFEu1xxpowR6fKe6ceD7JMJ4pWty94=1_zWrY390gA@mail.gmail.com>
Subject: Re: [RFC 6/6] ARM: sched: clear SD_SHARE_POWERLINE
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, peterz@infradead.org, mingo@redhat.com,
        pjt@google.com, linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 November 2012 12:00, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> On Monday 29 October 2012 06:58 PM, Vincent Guittot wrote:
>>
>> On 24 October 2012 17:21, Santosh Shilimkar <santosh.shilimkar@ti.com>
>> wrote:
>>>
>>> On Sunday 07 October 2012 01:13 PM, Vincent Guittot wrote:
>>>>
>>>>
>>>> The ARM platforms take advantage of packing small tasks on few cores.
>>>> This is true even when the cores of a cluster can't be powergated
>>>> independently.
>>>>
>>>>
>>>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>>>> ---
>>>>    arch/arm/kernel/topology.c |    5 +++++
>>>>    1 file changed, 5 insertions(+)
>>>>
>>>> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
>>>> index 26c12c6..00511d0 100644
>>>> --- a/arch/arm/kernel/topology.c
>>>> +++ b/arch/arm/kernel/topology.c
>>>> @@ -226,6 +226,11 @@ static inline void update_cpu_power(unsigned int
>>>> cpuid, unsigned int mpidr) {}
>>>>     */
>>>>    struct cputopo_arm cpu_topology[NR_CPUS];
>>>>
>>>> +int arch_sd_share_power_line(void)
>>>> +{
>>>> +       return 0*SD_SHARE_POWERLINE;
>>>> +}
>>>
>>>
>>>
>>> Making this selection of policy based on sched domain will better. Just
>>> gives the flexibility to choose a separate scheme for big and little
>>> systems which will be very convenient.
>>
>>
>> I agree that it would be more flexible to be able to set it for each level
>>
> Will you be addressing that in next version then ?

Hi Santosh,

yes, I will try to address this point for the next version.

Vincent

>
> Regards
> santosh
>
