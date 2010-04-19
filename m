Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0DSOhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:37:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab0DSOhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:37:52 -0400
Message-ID: <4BCC6ABA.9030006@redhat.com>
Date: Mon, 19 Apr 2010 17:37:46 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com> <4BCA026D.3070309@redhat.com> <4BCA02D1.2020608@redhat.com> <1271673836.1674.757.camel@laptop> <4BCC34DF.6030702@redhat.com> <1271674575.1674.793.camel@laptop> <4BCC3AC2.8050601@redhat.com> <1271675983.1674.853.camel@laptop> <20100419143219.GF14158@mothafucka.localdomain>
In-Reply-To: <20100419143219.GF14158@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 05:32 PM, Glauber Costa wrote:
>
>> Right, another option is to put the initial read outside of the loop,
>> that way you'll have the best of all cases, a single LOCK'ed op in the
>> loop, and only a single LOCK'ed op for the fast path on sensible
>> architectures ;-)
>>
>>      last = atomic64_read(&last_value);
>>      
> isn't a barrier enough here?
>
>    

No.  On i386, the statement

    last = last_value;

will be split by the compiler into two 32-bit loads.  If a write 
(atomic, using cmpxchg) on another cpu happens between those two loads, 
then the variable last will have a corrupted value.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

