Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab0DIJ6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 05:58:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab0DIJ6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 05:58:33 -0400
Message-ID: <4BBEFA3B.8070609@redhat.com>
Date: Fri, 09 Apr 2010 12:58:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Tom Lyon <pugs@lyon-about.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for	non-privileged
 processes
References: <201003311708.38961.pugs@lyon-about.com> <201004010906.47321.pugs@lyon-about.com> <4BB4C591.8000102@redhat.com> <201004011224.45336.pugs@lyon-about.com> <4BB59217.90102@redhat.com> <20100402170515.GA32579@suse.de>
In-Reply-To: <20100402170515.GA32579@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2010 08:05 PM, Greg KH wrote:
>
>> Currently kvm does device assignment with its own code, I'd like to unify
>> it with uio, not split it off.
>>
>> Separate notifications for msi-x interrupts are just as useful for uio as
>> they are for kvm.
>>      
> I agree, there should not be a difference here for KVM vs. the "normal"
> version.
>    

Just so you know what you got into, here are the kvm requirements:

- msi interrupts delivered via eventfd (these allow us to inject 
interrupts from uio to a guest without going through userspace)
- nonlinear iommu mapping (i.e. map discontiguous ranges of the device 
address space into ranges of the virtual address space)
- dynamic iommu mapping (support guest memory hotplug)
- unprivileged operation once an admin has assigned a device (my 
preferred implementation is to have all operations go through an fd, 
which can be passed via SCM_RIGHTS from a privileged application that 
opens the file)
- access to all config space, but BARs must be translated so userspace 
cannot attack the host
- some mechanism which allows us to affine device interrupts with their 
target vcpus (eventually, this is vague)
- anything mst might add
- a pony

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

