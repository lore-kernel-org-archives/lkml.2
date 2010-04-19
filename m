Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0DSKuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 06:50:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab0DSKut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 06:50:49 -0400
Message-ID: <4BCC3584.1050501@redhat.com>
Date: Mon, 19 Apr 2010 13:50:44 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Glauber Costa <glommer@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>	 <1271356648-5108-2-git-send-email-glommer@redhat.com>	 <4BC8CA52.4090703@goop.org> <1271673545.1674.743.camel@laptop>
In-Reply-To: <1271673545.1674.743.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 01:39 PM, Peter Zijlstra wrote:
> On Fri, 2010-04-16 at 13:36 -0700, Jeremy Fitzhardinge wrote:
>    
>>> +     do {
>>> +             last = last_value;
>>>
>>>        
>> Does this need a barrier() to prevent the compiler from re-reading
>> last_value for the subsequent lines?  Otherwise "(ret<  last)" and
>> "return last" could execute with different values for "last".
>>
>>      
> ACCESS_ONCE() is your friend.
>    

I think it's implied with atomic64_read().

-- 
error compiling committee.c: too many arguments to function

