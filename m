Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab0DAQUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:20:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757452Ab0DAQU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:20:29 -0400
Message-ID: <4BB4C1A6.8050904@redhat.com>
Date: Thu, 01 Apr 2010 18:54:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Tom Lyon <pugs@lyon-about.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for non-privileged
 processes
References: <201003311708.38961.pugs@lyon-about.com> <4BB462B5.1030402@redhat.com> <201004010839.07451.pugs@lyon-about.com>
In-Reply-To: <201004010839.07451.pugs@lyon-about.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 06:39 PM, Tom Lyon wrote:
>
>
>>> - support for MSI and MSI-X interrupts (the intel 82599 VFs support only
>>> MSI-X)
>>>        
>> How does a userspace program receive those interrupts?
>>      
> Same as other UIO drivers - by read()ing an event counter.
>    

IIRC the usual event counter is /dev/uioX, what's your event counter now?

kvm really wants the event counter to be an eventfd, that allows hooking 
it directly to kvm (which can inject an interrupt on an eventfd_signal), 
can you adapt your patch to do this?

-- 
error compiling committee.c: too many arguments to function

