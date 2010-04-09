Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab0DIQhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 12:37:09 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:55165 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab0DIQhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 12:37:06 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANbzvktAaMHG/2dsb2JhbACbO3GiQJkjhQkEgyQ
X-IronPort-AV: E=Sophos;i="4.52,178,1270425600"; 
   d="scan'208";a="180819598"
From: Tom Lyon <pugs@lyon-about.com>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access =?iso-8859-1?q?for=09non-privileged?= processes
Date: Fri, 9 Apr 2010 09:34:16 -0700
User-Agent: KMail/1.9.9
Cc: Greg KH <gregkh@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@linutronix.de>
References: <201003311708.38961.pugs@lyon-about.com> <20100402170515.GA32579@suse.de> <4BBEFA3B.8070609@redhat.com>
In-Reply-To: <4BBEFA3B.8070609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004090934.16891.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 April 2010 02:58:19 am Avi Kivity wrote:
> On 04/02/2010 08:05 PM, Greg KH wrote:
> >
> >> Currently kvm does device assignment with its own code, I'd like to unify
> >> it with uio, not split it off.
> >>
> >> Separate notifications for msi-x interrupts are just as useful for uio as
> >> they are for kvm.
> >>      
> > I agree, there should not be a difference here for KVM vs. the "normal"
> > version.
> >    
> 
> Just so you know what you got into, here are the kvm requirements:
> 
> - msi interrupts delivered via eventfd (these allow us to inject 
> interrupts from uio to a guest without going through userspace)
Check.
> - nonlinear iommu mapping (i.e. map discontiguous ranges of the device 
> address space into ranges of the virtual address space)
Check.
> - dynamic iommu mapping (support guest memory hotplug)
Check.
> - unprivileged operation once an admin has assigned a device (my 
> preferred implementation is to have all operations go through an fd, 
> which can be passed via SCM_RIGHTS from a privileged application that 
> opens the file)
Check.
> - access to all config space, but BARs must be translated so userspace 
> cannot attack the host
Please elaborate. All of PCI config? All of PCIe config? Seems like a huge mess.
> - some mechanism which allows us to affine device interrupts with their 
> target vcpus (eventually, this is vague)
Do-able.
> - anything mst might add
mst?
> - a pony
Rainbow or glitter?

The 'check' items are already done, not fully tested; probably available next week.
Can we leave the others for future patches? Please? And I definitely need help with 
the PCI config stuff.
