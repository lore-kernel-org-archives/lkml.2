Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab0FBLWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:22:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862Ab0FBLWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:22:01 -0400
Message-ID: <4C063ECB.8010706@redhat.com>
Date: Wed, 02 Jun 2010 14:21:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
References: <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com> <4C04E0E0.3070006@redhat.com> <20100601104651.GA9415@redhat.com> <4C050013.2020701@redhat.com> <20100602094527.GD964@8bytes.org> <4C062928.8040003@redhat.com> <20100602100404.GF964@8bytes.org>
In-Reply-To: <20100602100404.GF964@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 01:04 PM, Joerg Roedel wrote:
> On Wed, Jun 02, 2010 at 12:49:28PM +0300, Avi Kivity wrote:
>    
>> On 06/02/2010 12:45 PM, Joerg Roedel wrote:
>>      
>>> IOMMU mapped memory can not be swapped out because we can't do demand
>>> paging on io-page-faults with current devices. We have to pin _all_
>>> userspace memory that is mapped into an IOMMU domain.
>>>        
>> vhost doesn't pin memory.
>>
>> What I proposed is to describe the memory map using an object (fd), and
>> pass it around to clients that use it: kvm, vhost, vfio.  That way you
>> maintain the memory map in a central location and broadcast changes to
>> clients.  Only a vfio client would result in memory being pinned.
>>      
> Ah ok, so its only about the database which keeps the mapping
> information.
>    

Yes.

>    
>> It can still work, but the interface needs to be extended to include
>> dirty bitmap logging.
>>      
> Thats hard to do. I am not sure about VT-d but the AMD IOMMU has no
> dirty-bits in the page-table. And without demand-paging we can't really
> tell what pages a device has written to. The only choice is to mark all
> IOMMU-mapped pages dirty as long as they are mapped.
>
>    

The interface would only work for clients which support it: kvm, vhost, 
and iommu/devices with restartable dma.

Note dirty logging is not very interesting for vfio anyway, since you 
can't live migrate with assigned devices.

-- 
error compiling committee.c: too many arguments to function

