Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab0FBMux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:50:53 -0400
Received: from 8bytes.org ([88.198.83.132]:34898 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab0FBMuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:50:51 -0400
Date: Wed, 2 Jun 2010 14:50:50 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602125049.GB11162@8bytes.org>
References: <20100602094201.GC964@8bytes.org> <20100602095312.GA25335@redhat.com> <20100602101940.GG964@8bytes.org> <20100602102144.GD29023@redhat.com> <20100602103516.GI964@8bytes.org> <20100602103828.GF29023@redhat.com> <20100602111224.GA11033@8bytes.org> <20100602112100.GA29697@redhat.com> <20100602121927.GA11162@8bytes.org> <4C064DA7.6060504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C064DA7.6060504@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 03:25:11PM +0300, Avi Kivity wrote:
> On 06/02/2010 03:19 PM, Joerg Roedel wrote:
>>
>>> Yes.  so you do:
>>> iommu = open
>>> ioctl(dev1, BIND, iommu)
>>> ioctl(dev2, BIND, iommu)
>>> ioctl(dev3, BIND, iommu)
>>> ioctl(dev4, BIND, iommu)
>>>
>>> No need to add a SHARE ioctl.
>>>      
>> In my proposal this looks like:
>>
>>
>> dev1 = open();
>> ioctl(dev2, SHARE, dev1);
>> ioctl(dev3, SHARE, dev1);
>> ioctl(dev4, SHARE, dev1);
>>
>> So we actually save an ioctl.
>>    
>
> The problem with this is that it is assymetric, dev1 is treated  
> differently from dev[234].  It's an unintuitive API.

Its by far more unintuitive that a process needs to explicitly bind a
device to an iommu domain before it can do anything with it. If its
required anyway the binding can happen implicitly. We could allow to do
a nop 'ioctl(dev1, SHARE, dev1)' to remove the asymmetry.

Note that this way of handling userspace iommu mappings is also a lot
simpler for most use-cases outside of KVM. If a developer wants to write
a userspace driver all it needs to do is:

dev = open();
ioctl(dev, MAP, ...);
/* use device with mappings */
close(dev);

Which is much easier than the need to create a domain explicitly.

	Joerg

