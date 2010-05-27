Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab0E0UNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:13:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045Ab0E0UNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:13:15 -0400
Message-ID: <4BFED258.40501@redhat.com>
Date: Thu, 27 May 2010 10:13:12 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add Documentation/kvm/msr.txt
References: <1274897088-8587-1-git-send-email-glommer@redhat.com> <4BFE2A2F.50209@redhat.com> <20100527160248.GF3445@mothafucka.localdomain>
In-Reply-To: <20100527160248.GF3445@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 06:02 AM, Glauber Costa wrote:
> On Thu, May 27, 2010 at 11:15:43AM +0300, Avi Kivity wrote:
>    
>> On 05/26/2010 09:04 PM, Glauber Costa wrote:
>>      
>>> This patch adds a file that documents the usage of KVM-specific
>>> MSRs.
>>>
>>>        
>> Looks good.  A few comments:
>>
>>      
>>> +
>>> +Custom MSR list
>>> +--------
>>> +
>>> +The current supported Custom MSR list is:
>>> +
>>> +MSR_KVM_WALL_CLOCK:  0x11
>>> +
>>> +	data: physical address of a memory area.
>>>        
>> Which must be in guest RAM (i.e., don't point it somewhere random
>> and expect the hypervisor to allocate it for you).
>>
>> Must be aligned to 4 bytes (we don't enforce it though).
>>      
> I don't see the reason for it.
>
> If this is a requirement, our own implementation
> is failing to meet it.
>    

It's so the atomic write actually is atomic.  Stating a 4 -byte 
alignment requirement prevents the wall clock from crossing a page boundary.

Zach

