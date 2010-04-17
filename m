Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0DQSuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 14:50:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab0DQSt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 14:49:57 -0400
Message-ID: <4BCA02D1.2020608@redhat.com>
Date: Sat, 17 Apr 2010 21:49:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com> <4BCA026D.3070309@redhat.com>
In-Reply-To: <4BCA026D.3070309@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2010 09:48 PM, Avi Kivity wrote:
>
>>
>> +static u64 last_value = 0;
>
> Needs to be atomic64_t.
>
>> +
>>   cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
>>   {
>>       struct pvclock_shadow_time shadow;
>>       unsigned version;
>>       cycle_t ret, offset;
>> +    u64 last;
>>
>>
>> +    do {
>> +        last = last_value;
>
> Otherwise, this assignment can see a partial update.

On a 32-bit guest, that is.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

