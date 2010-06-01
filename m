Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab0FAKAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 06:00:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768Ab0FAKAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:00:02 -0400
Date: Tue, 1 Jun 2010 12:55:32 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, chrisw@sous-sol.org, joro@8bytes.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100601095532.GA9178@redhat.com>
References: <20100530121944.GH27611@redhat.com> <4C025999.7080706@redhat.com> <20100530124949.GI27611@redhat.com> <4C0261C1.9090204@redhat.com> <20100530130332.GM27611@redhat.com> <4C026497.8070901@redhat.com> <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C04C085.1030107@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 11:10:45AM +0300, Avi Kivity wrote:
> On 05/31/2010 08:10 PM, Michael S. Tsirkin wrote:
>> On Mon, May 31, 2010 at 02:50:29PM +0300, Avi Kivity wrote:
>>    
>>> On 05/30/2010 05:53 PM, Michael S. Tsirkin wrote:
>>>      
>>>> So what I suggested is failing any kind of access until iommu
>>>> is assigned.
>>>>
>>>>        
>>> So, the kernel driver must be aware of the iommu.  In which case it may
>>> as well program it.
>>>      
>> It's a kernel driver anyway. Point is that
>> the *device* driver is better off not programming iommu,
>> this way we do not need to reprogram it for each device.
>>    
>
> The device driver is in userspace.

I mean the kernel driver that grants userspace the access.

>  It can't program the iommu.
> What  
> the patch proposes is that userspace tells vfio about the needed  
> mappings, and vfio programs the iommu.

There seems to be some misunderstanding.  The userspace interface
proposed forces a separate domain per device and forces userspace to
repeat iommu programming for each device.  We are better off sharing a
domain between devices and programming the iommu once.

The natural way to do this is to have an iommu driver for programming
iommu.

This likely means we will have to pass the domain to 'vfio' or uio or
whatever the driver that gives userspace the access to device is called,
but this is only for security, there's no need to support programming
iommu there.

And using this design means the uio framework changes
required would be minor, so we won't have to duplicate code.

> -- 
> error compiling committee.c: too many arguments to function
