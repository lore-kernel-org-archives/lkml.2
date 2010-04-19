Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab0DSLkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 07:40:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab0DSLkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 07:40:14 -0400
Message-ID: <4BCC4111.4030405@redhat.com>
Date: Mon, 19 Apr 2010 14:40:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>	 <1271356648-5108-2-git-send-email-glommer@redhat.com>	 <4BCA026D.3070309@redhat.com>  <4BCA02D1.2020608@redhat.com>	 <1271673836.1674.757.camel@laptop>  <4BCC34DF.6030702@redhat.com>	 <1271674575.1674.793.camel@laptop>  <4BCC3AC2.8050601@redhat.com> <1271675983.1674.853.camel@laptop>
In-Reply-To: <1271675983.1674.853.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 02:19 PM, Peter Zijlstra wrote:
>
>> Still have two cmpxchgs in the common case.  The first iteration will
>> fail, fetching last_value, the second will work.
>>
>> It will be better when we have contention, though, so it's worthwhile.
>>      
> Right, another option is to put the initial read outside of the loop,
> that way you'll have the best of all cases, a single LOCK'ed op in the
> loop, and only a single LOCK'ed op for the fast path on sensible
> architectures ;-)
>
>      last = atomic64_read(&last_value);
>      do {
>        if (ret<  last)
>          return last;
>        last = atomic64_cmpxchg(&last_value, last, ret);
>      } while (unlikely(last != ret));
>
> Or so.
>
>    

Yes, looks optimal when !NONSTOP_TSC.

-- 
error compiling committee.c: too many arguments to function

