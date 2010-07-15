Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0GOHIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 03:08:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab0GOHIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 03:08:06 -0400
Message-ID: <4C3EB3C7.90108@redhat.com>
Date: Thu, 15 Jul 2010 10:07:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Glauber Costa <glommer@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix ordering constraints on crX read/writes
References: <4C3E363B.7060804@goop.org> <4C3E5637.4010300@redhat.com>
In-Reply-To: <4C3E5637.4010300@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 03:28 AM, Zachary Amsden wrote:
>>   static inline void native_write_cr2(unsigned long val)
>>   {
>> -    asm volatile("mov %0,%%cr2": : "r" (val), "m" (__force_order));
>> +    asm volatile("mov %1,%%cr2": "+m" (__force_order) : "r" (val) : 
>> "memory");
>>   }
>
>
> You don't need the memory clobber there.  Technically, this should 
> never be used, however.

kvm writes cr2 in order to present the correct value to the guest.  It 
doesn't use native_write_cr2(), however.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

