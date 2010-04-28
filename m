Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0D1Lqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:46:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab0D1Lqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 07:46:31 -0400
Message-ID: <4BD81762.8050102@redhat.com>
Date: Wed, 28 Apr 2010 14:09:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/22] KVM: MMU: Add infrastructure for two-level page
 walker
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com> <1272364712-17425-12-git-send-email-joerg.roedel@amd.com> <4BD6D9C2.6020104@redhat.com> <20100428110333.GD18832@amd.com>
In-Reply-To: <20100428110333.GD18832@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2010 02:03 PM, Joerg Roedel wrote:
> On Tue, Apr 27, 2010 at 03:34:10PM +0300, Avi Kivity wrote:
>    
>> On 04/27/2010 01:38 PM, Joerg Roedel wrote:
>>      
>>> This patch introduces a mmu-callback to translate gpa
>>> addresses in the walk_addr code. This is later used to
>>> translate l2_gpa addresses into l1_gpa addresses.
>>>
>>> +static inline gfn_t gpa_to_gfn(gpa_t gpa)
>>> +{
>>> +	return (gfn_t)gpa>>   PAGE_SHIFT;
>>> +}
>>> +
>>>        
>> This overflows on 32-bit, since gpa_t is u64 and gfn_t is ulong.
>>      
> Thinking again about it, on 32 bit the physical address width is only 36
> bits. So there shouldn't be an overflow, no?
>    

It's limited by MAXPHYADDR (at least on Intel) even on 32-bits.

-- 
error compiling committee.c: too many arguments to function

