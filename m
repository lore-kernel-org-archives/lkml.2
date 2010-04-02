Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab0DBRFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:05:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:59032 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab0DBRFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:05:18 -0400
Date: Fri, 2 Apr 2010 10:05:15 -0700
From: Greg KH <gregkh@suse.de>
To: Avi Kivity <avi@redhat.com>
Cc: Tom Lyon <pugs@lyon-about.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for
	non-privileged processes
Message-ID: <20100402170515.GA32579@suse.de>
References: <201003311708.38961.pugs@lyon-about.com> <201004010906.47321.pugs@lyon-about.com> <4BB4C591.8000102@redhat.com> <201004011224.45336.pugs@lyon-about.com> <4BB59217.90102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB59217.90102@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 09:43:35AM +0300, Avi Kivity wrote:
> On 04/01/2010 10:24 PM, Tom Lyon wrote:
>>
>>> But there are multiple msi-x interrupts, how do you know which one
>>> triggered?
>>>      
>> You don't. This would suck for KVM, I guess, but we'd need major rework of the
>> generic UIO stuff to have a separate event channel for each MSI-X.
>>    
>
> Doesn't it suck for non-kvm in the same way?  Multiple vectors are there 
> for a reason.  For example, if you have a multiqueue NIC, you'd have to 
> process all queues instead of just the one that triggered.
>
>> For my purposes, collapsing all the MSI-Xs into one MSI-look-alike is fine,
>> because I'd be using MSI anyways if I could. The weird Intel 82599 VF only
>> supports MSI-X.
>>
>> So one big question is - do we expand the whole UIO framework for KVM
>> requirements, or do we split off either KVM or non-VM into a separate driver?
>> Hans or Greg - care to opine?
>>    
>
> Currently kvm does device assignment with its own code, I'd like to unify 
> it with uio, not split it off.
>
> Separate notifications for msi-x interrupts are just as useful for uio as 
> they are for kvm.

I agree, there should not be a difference here for KVM vs. the "normal"
version.

thanks,

greg k-h
