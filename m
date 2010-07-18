Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab0GRPb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 11:31:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756442Ab0GRPbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 11:31:25 -0400
Message-ID: <4C431E46.3010001@redhat.com>
Date: Sun, 18 Jul 2010 18:31:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 5/6] kvm, x86: use ro page and don't copy shared page
References: <4C3FC033.3000605@cn.fujitsu.com> <20100716071936.GE17894@redhat.com> <20100716232612.GB8946@amt.cnet> <20100717043124.GA24480@redhat.com> <4C431A43.5010808@redhat.com> <20100718152321.GA20355@redhat.com>
In-Reply-To: <20100718152321.GA20355@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2010 06:23 PM, Gleb Natapov wrote:
> On Sun, Jul 18, 2010 at 06:14:11PM +0300, Avi Kivity wrote:
>    
>> On 07/17/2010 07:31 AM, Gleb Natapov wrote:
>>      
>>>>> Currently pages allocated for guest memory are required to be RW, so after your series
>>>>> behaviour will remain exactly the same as before.
>>>>>            
>>>> Except KSM pages.
>>>>
>>>>          
>>> KSM page will be COWed by __get_user_pages_fast(addr, 1, 1, page) in
>>> get_user_page_and_protection() just like it COWed now, no?
>>>        
>> Well, we don't want to COW it on write faults.
>>      

I meant read faults here.

>> The optimal behaviour is:
>>
>> - write faults: COW and instantiate a writeable spte
>>      
> So do we or don't we want to COW on write faults?
>    

We do (no choice).

-- 
error compiling committee.c: too many arguments to function

