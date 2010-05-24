Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab0EXGY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 02:24:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab0EXGY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 02:24:28 -0400
Message-ID: <4BFA1B94.9010403@redhat.com>
Date: Mon, 24 May 2010 09:24:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: MMU: allow more page become unsync at gfn mapping
 time
References: <4BF91C34.6020904@cn.fujitsu.com> <4BF932DD.5070900@redhat.com> <4BF9DE88.4060609@cn.fujitsu.com>
In-Reply-To: <4BF9DE88.4060609@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2010 05:03 AM, Xiao Guangrong wrote:
>
> Avi Kivity wrote:
>
>    
>>> +    if (need_unsync)
>>> +        kvm_unsync_pages(vcpu, gfn);
>>>        return 0;
>>>    }
>>>
>>>
>>>        
>> Looks good, I'm just uncertain about role.invalid handling.  What's the
>> reasoning here?
>>
>>      
> Avi,
>
> Thanks for your reply.
>
> We no need worry about 'role.invalid' here, since we only allow the PTE shadow
> pages(role.level == 1) become unsync, and in current code, 'role.invalid' is only
> used for root shadow pages.
>    

Right, the invlpg change is not it yet.  But I think it should be in 
this patch; I don't like subtle dependencies, and it will make the 
invplg patch simpler.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

