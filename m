Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab0DSLLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 07:11:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab0DSLK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 07:10:58 -0400
Message-ID: <4BCC3A3E.9070909@redhat.com>
Date: Mon, 19 Apr 2010 14:10:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Glauber Costa <glommer@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>	 <1271356648-5108-2-git-send-email-glommer@redhat.com>	 <4BC8CA52.4090703@goop.org> <1271673545.1674.743.camel@laptop>	 <4BCC3584.1050501@redhat.com> <1271675100.1674.818.camel@laptop>
In-Reply-To: <1271675100.1674.818.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 02:05 PM, Peter Zijlstra wrote:
>>
>>> ACCESS_ONCE() is your friend.
>>>
>>>        
>> I think it's implied with atomic64_read().
>>      
> Yes it would be. I was merely trying to point out that
>
>    last = ACCESS_ONCE(last_value);
>
> Is a narrower way of writing:
>
>    last = last_value;
>    barrier();
>
> In that it need not clobber all memory locations and makes it instantly
> clear what we want the barrier for.
>    

Oh yes, just trying to avoid a patch with both atomic64_read() and 
ACCESS_ONCE().



-- 
error compiling committee.c: too many arguments to function

