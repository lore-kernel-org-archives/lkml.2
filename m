Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab2BQMTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 07:19:44 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:50797 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2BQMTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 07:19:42 -0500
Message-ID: <4F3E45D2.5050100@linux.vnet.ibm.com>
Date: Fri, 17 Feb 2012 17:49:30 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Eric Dumazet <eric.dumazet@gmail.com>, akpm@linux-foundation.org,
        kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        venki@google.com, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] lib/cpumask.c: Optimize __any_online_cpu() calculation
References: <20120215123208.15623.73499.stgit@srivatsabhat.in.ibm.com> <1329310627.2437.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <4F3BBED4.2090101@linux.vnet.ibm.com> <87pqdfbthw.fsf@rustcorp.com.au>
In-Reply-To: <87pqdfbthw.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12021712-8256-0000-0000-0000014BAF89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 04:21 AM, Rusty Russell wrote:

> On Wed, 15 Feb 2012 19:49:00 +0530, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> On 02/15/2012 06:27 PM, Eric Dumazet wrote:
>>
>>> Le mercredi 15 février 2012 à 18:05 +0530, Srivatsa S. Bhat a écrit :
>>>> __any_online_cpu() uses a for loop at the moment.
>>>> Instead, use cpumask_* operations to speed it up.
>>>>
>>>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>>>> ---
>>>> Actually, the patch posted at https://lkml.org/lkml/2012/2/15/101 removed
>>>> the last user of any_online_cpu() (and hence __any_online_cpu()).
>>>> However, since this is an exported symbol, I refrained from removing this
>>>> function altogether.
>>>
>>> Just remove the export/function and eventually leave the helper ?
>>>
>>> #define any_online_cpu(mask) cpumask_any_and(mask, cpu_online_mask)
>>>
>>
>>
>> That sounds good. Here is v2 of the patch.
>> (Since this v2 touches include/linux/cpumask.h, I rebased it on top of the
>> patch posted at: https://lkml.org/lkml/2012/2/15/2. Even without that
>> patch it should apply with minor line number changes..)
> 
> No.  Just git rid of the only caller of any_online_cpu():
> 
> arch/ia64/kernel/smpboot.c:693:			new_cpei_cpu = any_online_cpu(cpu_online_map);
> 


My ia64 patch already got rid of that caller! So this patch should be fine as
is. And it looks like Andrew Morton has taken this patch into -mm. So nothing
more needs to be done about this :-)

Regards,
Srivatsa S. Bhat

