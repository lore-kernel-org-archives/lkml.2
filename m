Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab0GTIx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 04:53:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab0GTIx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 04:53:56 -0400
Message-ID: <4C456422.7030708@redhat.com>
Date: Tue, 20 Jul 2010 11:53:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: KVM <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/18] Make cpu_tsc_khz updates use local CPU
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-5-git-send-email-zamsden@redhat.com> <4C431374.2020804@redhat.com> <4C44B035.7080604@redhat.com>
In-Reply-To: <4C44B035.7080604@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2010 11:06 PM, Zachary Amsden wrote:
>>> +static void tsc_khz_changed(void *data)
>>>   {
>>> -    /* nothing */
>>> +    struct cpufreq_freqs *freq = data;
>>> +    unsigned long khz = 0;
>>> +
>>> +    if (data)
>>> +        khz = freq->new;
>>> +    else if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
>>> +        khz = cpufreq_quick_get(raw_smp_processor_id());
>>> +    if (!khz)
>>> +        khz = tsc_khz;
>>> +    __get_cpu_var(cpu_tsc_khz) = khz;
>>>   }
>>
>> Do we really need to cache cpufreq_quick_get()?  If it's really 
>> quick, why not just use it everywhere instead of cacheing it?  Not a 
>> comment on this patch.
>>
>
>
> If cpufreq is compiled in, but disabled, it returns zero, so we need 
> some sort of logic.

Maybe it's better to put it into cpufreq_quick_get().  Inconsistent APIs 
that appear to work are bad.

-- 
error compiling committee.c: too many arguments to function

