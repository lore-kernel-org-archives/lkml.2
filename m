Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1FBSNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:13:05 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:31782 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab1FBSNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:13:04 -0400
Message-ID: <4DE7D2AC.1070503@tilera.com>
Date: Thu, 2 Jun 2011 14:13:00 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH] slub: always align cpu_slab to honor cmpxchg_double requirement
References: <201106021424.p52EO91O006974@lab-17.internal.tilera.com> <alpine.DEB.2.00.1106021015220.18350@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1106021015220.18350@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/2011 1:16 PM, David Rientjes wrote:
> On Thu, 2 Jun 2011, Chris Metcalf wrote:
>> On an architecture without CMPXCHG_LOCAL but with DEBUG_VM enabled,
>> the VM_BUG_ON() in __pcpu_double_call_return_bool() will cause an early
>> panic during boot unless we always align cpu_slab properly.
>>
>> In principle we could remove the alignment-testing VM_BUG_ON() for
>> architectures that don't have CMPXCHG_LOCAL, but leaving it in means
>> that new code will tend not to break x86 even if it is introduced
>> on another platform, and it's low cost to require alignment.
>>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> Acked-by: David Rientjes <rientjes@google.com>
>
>> ---
>> This needs to be pushed for 3.0 to allow arch/tile to boot.
>> I'm happy to push it but I assume it would be better coming
>> from an mm or percpu tree.  Thanks!
>>
> Should also be marked for stable for 2.6.39.x, right?

No, in 2.6.39 the irqsafe_cpu_cmpxchg_double() was guarded under "#ifdef
CONFIG_CMPXCHG_LOCAL".  Now it's not.  I suppose we could take the comment
change in percpu.h for 2.6.39, but it probably doesn't merit churning the
stable tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


