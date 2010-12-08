Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab0LHRWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:22:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:51298 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095Ab0LHRVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:21:52 -0500
Message-ID: <4CFFBE67.8070809@kernel.org>
Date: Wed, 08 Dec 2010 18:20:39 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] x86: Replace uses of current_cpu_data with this_cpu ops
References: <20101206171618.302060721@linux.com>	 <20101206171638.595205962@linux.com> <4CFE41F8.7040400@kernel.org>	 <4CFE4294.30001@kernel.org>	 <alpine.DEB.2.00.1012070846050.25976@router.home>	 <4CFE4BE0.9040203@kernel.org>	 <alpine.DEB.2.00.1012070906290.26552@router.home>	 <4CFE4E05.7070902@kernel.org>	 <alpine.DEB.2.00.1012071020040.26552@router.home>	 <4CFF8520.4020704@kernel.org> <1291815501.2883.34.camel@edumazet-laptop>	 <alpine.DEB.2.00.1012080929590.23407@router.home> <1291828646.2883.65.camel@edumazet-laptop>
In-Reply-To: <1291828646.2883.65.camel@edumazet-laptop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 17:20:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/08/2010 06:17 PM, Eric Dumazet wrote:
> Le mercredi 08 décembre 2010 à 09:33 -0600, Christoph Lameter a écrit :
>> On Wed, 8 Dec 2010, Eric Dumazet wrote:
>>
>>>> In the long run, it might be a good idea to remove cpu_data() macro
>>>> too and use per_cpu macro directly.
>>>>
>>>
>>> or introduce this_cpu_has() to remove the adress computation
>>>
>>> -	if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_ARAT)) {
>>>
>>> +	if (this_cpu_has(X86_FEATURE_ARAT)) {
>>>
>>
>> The fundamental problem is that bitops require memory addresses which does
>> not work with per cpu ops.
>>
> 
> Sure, set() or clear() needs the address, but the read doesnt ?
> 
> This can be implemented as
> 
>   (__this_cpu_read(cpu_info.word[X]) & MASK)
> 
> Anyway, even if mapped to cpu_has(__this_cpu_ptr(&cpu_info), XXX), 
> it would be cleaner to use this_cpu_has() helper.

Agreed.  I'd also like to see cpu_data() gone too.  It isn't used too
many times and mixed with direct percpu ops only makes things more
confusing without much benefit.  Does somebody care to send patches
for these cleanups?

Thanks.

-- 
tejun
