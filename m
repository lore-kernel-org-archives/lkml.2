Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab1JTM0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 08:26:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:38433 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1JTM0g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 08:26:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Xfz1rTmfYO40ItIYLW+d+o7HSsj6rQxTsqAJg56cwsEry75Gn4pcx6PEDkJvQxFVx
	er5AYBzDEtZEHex2wc56Q==
MIME-Version: 1.0
In-Reply-To: <m2wrc0xpbg.fsf@firstfloor.org>
References: <1319060737.2604.38.camel@schen9-DESK>
	<m2wrc0xpbg.fsf@firstfloor.org>
Date: Thu, 20 Oct 2011 05:26:32 -0700
Message-ID: <CABeCy1a20npBt=4ee38zLH+6Fi7nfASd0dL3od6pOccV=LJDkA@mail.gmail.com>
Subject: Re: [Patch] Idle balancer: cache align nohz structure to improve idle
 load balancing scalability
From: Venki Pallipadi <venki@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 9:24 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Tim Chen <tim.c.chen@linux.intel.com> writes:
>>   */
>>  static struct {
>> -     atomic_t load_balancer;
>> -     atomic_t first_pick_cpu;
>> -     atomic_t second_pick_cpu;
>> -     cpumask_var_t idle_cpus_mask;
>> +     atomic_t load_balancer ____cacheline_aligned;
>> +     atomic_t first_pick_cpu ____cacheline_aligned;
>> +     atomic_t second_pick_cpu ____cacheline_aligned;
>> +     cpumask_var_t idle_cpus_mask ____cacheline_aligned;
>
> On large configs idle_cpu_masks may be allocated.  May need
> more changes to tell the allocator to cache align/pad too?
>

An alternate approach is to split this struct per node/socket and do
the nohz idle balancing logic at that level. That should be more
scalable in terms of nohz balancing (ensure one CPU wont be doing nohz
balancing for huge number of idle CPUs). I had looked at that approach
couple of years earlier and couldn't measure that much of a gain. May
be it is time to revisit that with increased core count.

Thanks,
Venki
