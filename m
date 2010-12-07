Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0LGPKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:10:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:33544 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab0LGPKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:10:20 -0500
Message-ID: <4CFE4E05.7070902@kernel.org>
Date: Tue, 07 Dec 2010 16:08:53 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [Use cpuops V1 04/11] x86: Use this_cpu_ops for current_cpu_data
 accesses
References: <20101206171618.302060721@linux.com> <20101206171638.595205962@linux.com> <4CFE41F8.7040400@kernel.org> <4CFE4294.30001@kernel.org> <alpine.DEB.2.00.1012070846050.25976@router.home> <4CFE4BE0.9040203@kernel.org> <alpine.DEB.2.00.1012070906290.26552@router.home>
In-Reply-To: <alpine.DEB.2.00.1012070906290.26552@router.home>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 15:08:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 04:07 PM, Christoph Lameter wrote:
> On Tue, 7 Dec 2010, Tejun Heo wrote:
> 
>>>> Ooh, was too fast.  I think mixing the use of percpu accesses to
>>>> cpu_info and the wrapper macro current_cpu_data is quite confusing.
>>>> There aren't too many current_cpu_data users in x86 anyway.  Can you
>>>> please make the conversion complete?  I'm moving the above misplaced
>>>> chunk into 03 and not applying 04 for now.
>>>
>>> We cannot make that conversion complete since we cannot obtain the address
>>> if we use a this_cpu operation. Then its better to drop this patch.
>>
>> No, I was talking about dropping current_cpu_data macro.  We can use
>> __this_cpu_ptr() for addresses.  I just find it very confusing to mix
>> current_cpu_data and using direct percpu accessors on cpu_info.
> 
> Hmmm... Ok 21 occurrences. So two patches: Conversion and then
> this_cpu_ops. Or one doing both?

Two steps is better probably.  Thank you.

-- 
tejun
