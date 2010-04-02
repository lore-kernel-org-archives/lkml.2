Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165Ab0DBGn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 02:43:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758693Ab0DBGnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 02:43:49 -0400
Message-ID: <4BB59217.90102@redhat.com>
Date: Fri, 02 Apr 2010 09:43:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Tom Lyon <pugs@lyon-about.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Hans J. Koch" <hjk@linutronix.de>, gregkh@suse.de
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for non-privileged
 processes
References: <201003311708.38961.pugs@lyon-about.com> <201004010906.47321.pugs@lyon-about.com> <4BB4C591.8000102@redhat.com> <201004011224.45336.pugs@lyon-about.com>
In-Reply-To: <201004011224.45336.pugs@lyon-about.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 10:24 PM, Tom Lyon wrote:
>
>> But there are multiple msi-x interrupts, how do you know which one
>> triggered?
>>      
> You don't. This would suck for KVM, I guess, but we'd need major rework of the
> generic UIO stuff to have a separate event channel for each MSI-X.
>    

Doesn't it suck for non-kvm in the same way?  Multiple vectors are there 
for a reason.  For example, if you have a multiqueue NIC, you'd have to 
process all queues instead of just the one that triggered.

> For my purposes, collapsing all the MSI-Xs into one MSI-look-alike is fine,
> because I'd be using MSI anyways if I could. The weird Intel 82599 VF only
> supports MSI-X.
>
> So one big question is - do we expand the whole UIO framework for KVM
> requirements, or do we split off either KVM or non-VM into a separate driver?
> Hans or Greg - care to opine?
>    

Currently kvm does device assignment with its own code, I'd like to 
unify it with uio, not split it off.

Separate notifications for msi-x interrupts are just as useful for uio 
as they are for kvm.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

