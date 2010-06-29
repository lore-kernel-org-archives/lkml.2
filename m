Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab0F2Hkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:40:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:56297 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab0F2Hkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:40:45 -0400
Message-ID: <4C29A33D.2060407@kernel.org>
Date: Tue, 29 Jun 2010 09:39:41 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, dwalker@codeaurora.org,
       stefanr@s5r6.in-berlin.de, florian@mickler.org, andi@firstfloor.org,
       mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 12/35] workqueue: update cwq alignement
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-13-git-send-email-tj@kernel.org> <20100628224755.GA10104@nowhere>
In-Reply-To: <20100628224755.GA10104@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 07:39:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/29/2010 12:47 AM, Frederic Weisbecker wrote:
>>  void __init init_workqueues(void)
>>  {
>> +	/*
>> +	 * cwqs are forced aligned according to WORK_STRUCT_FLAG_BITS.
>> +	 * Make sure that the alignment isn't lower than that of
>> +	 * unsigned long long.
>> +	 */
>> +	BUILD_BUG_ON(__alignof__(struct cpu_workqueue_struct) <
>> +		     __alignof__(unsigned long long));
>> +
> 
> But they are not allocated contiguously as we use the per cpu offsets.
> So why does the struct itself need to be aligned? Only the base pointer
> of its dynamic allocation needs to be aligned. Or am I missing something?

work->data doesn't store the percpu pointer but the address of cwq of
that specific cpu as returned by per_cpu_ptr(), so each element needs
to be aligned.  Besides, if the percpu ptr is aligned the elements are
aligned so they aren't different things.

> This is crashing my build in x86-32, unless I force an alignment to 8, or
> I just remove this build check.

Heh, how did that happen?  I'll investigate.  Can you please attach
your .config?

Thanks.

-- 
tejun
