Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab0FAK3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 06:29:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab0FAK3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:29:00 -0400
Message-ID: <4C04E0E0.3070006@redhat.com>
Date: Tue, 01 Jun 2010 13:28:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, chrisw@sous-sol.org, joro@8bytes.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
References: <20100530121944.GH27611@redhat.com> <4C025999.7080706@redhat.com> <20100530124949.GI27611@redhat.com> <4C0261C1.9090204@redhat.com> <20100530130332.GM27611@redhat.com> <4C026497.8070901@redhat.com> <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com>
In-Reply-To: <20100601095532.GA9178@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 12:55 PM, Michael S. Tsirkin wrote:
>
>>   It can't program the iommu.
>> What
>> the patch proposes is that userspace tells vfio about the needed
>> mappings, and vfio programs the iommu.
>>      
> There seems to be some misunderstanding.  The userspace interface
> proposed forces a separate domain per device and forces userspace to
> repeat iommu programming for each device.  We are better off sharing a
> domain between devices and programming the iommu once.
>    

   iommufd = open(/dev/iommu);
   ioctl(iommufd, IOMMUFD_ASSIGN_RANGE, ...)
   ioctl(vfiofd, VFIO_SET_IOMMU, iommufd)

?

If so, I agree.

> The natural way to do this is to have an iommu driver for programming
> iommu.
>
> This likely means we will have to pass the domain to 'vfio' or uio or
> whatever the driver that gives userspace the access to device is called,
> but this is only for security, there's no need to support programming
> iommu there.
>
> And using this design means the uio framework changes
> required would be minor, so we won't have to duplicate code.
>    

Since vfio would be the only driver, there would be no duplication.  But 
a separate object for the iommu mapping is a good thing.  Perhaps we can 
even share it with vhost (without actually using the mmu, since vhost is 
software only).

-- 
error compiling committee.c: too many arguments to function

