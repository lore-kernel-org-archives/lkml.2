Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab0DAQjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:39:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757986Ab0DAQjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:39:48 -0400
Message-ID: <4BB4C591.8000102@redhat.com>
Date: Thu, 01 Apr 2010 19:10:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Tom Lyon <pugs@lyon-about.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for non-privileged
 processes
References: <201003311708.38961.pugs@lyon-about.com> <201004010839.07451.pugs@lyon-about.com> <4BB4C1A6.8050904@redhat.com> <201004010906.47321.pugs@lyon-about.com>
In-Reply-To: <201004010906.47321.pugs@lyon-about.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 07:06 PM, Tom Lyon wrote:
> On Thursday 01 April 2010 08:54:14 am Avi Kivity wrote:
>    
>> On 04/01/2010 06:39 PM, Tom Lyon wrote:
>>      
>>>>> - support for MSI and MSI-X interrupts (the intel 82599 VFs support
>>>>> only MSI-X)
>>>>>            
>>>> How does a userspace program receive those interrupts?
>>>>          
>>> Same as other UIO drivers - by read()ing an event counter.
>>>        
>> IIRC the usual event counter is /dev/uioX, what's your event counter now?
>>      
> Exact same mechanism.
>    

But there are multiple msi-x interrupts, how do you know which one 
triggered?

>> kvm really wants the event counter to be an eventfd, that allows hooking
>> it directly to kvm (which can inject an interrupt on an eventfd_signal),
>> can you adapt your patch to do this?
>>      
> My patch does not currently go anywhere near the read/fd logic of /dev/uioX.
> I think a separate patch would be appropriate.
>    

Sure.

-- 
error compiling committee.c: too many arguments to function

