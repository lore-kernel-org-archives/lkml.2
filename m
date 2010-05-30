Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab0E3M1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 08:27:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab0E3M1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 08:27:36 -0400
Message-ID: <4C025999.7080706@redhat.com>
Date: Sun, 30 May 2010 15:27:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, chrisw@sous-sol.org, joro@8bytes.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
References: <4c004cba.Z/2Hpd7reetFaFC5%pugs@cisco.com> <20100530121944.GH27611@redhat.com>
In-Reply-To: <20100530121944.GH27611@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2010 03:19 PM, Michael S. Tsirkin wrote:
> On Fri, May 28, 2010 at 04:07:38PM -0700, Tom Lyon wrote:
>    
>> The VFIO "driver" is used to allow privileged AND non-privileged processes to
>> implement user-level device drivers for any well-behaved PCI, PCI-X, and PCIe
>> devices.
>> 	Signed-off-by: Tom Lyon<pugs@cisco.com>
>> ---
>> This patch is the evolution of code which was first proposed as a patch to
>> uio/uio_pci_generic, then as a more generic uio patch. Now it is taken entirely
>> out of the uio framework, and things seem much cleaner. Of course, there is
>> a lot of functional overlap with uio, but the previous version just seemed
>> like a giant mode switch in the uio code that did not lead to clarity for
>> either the new or old code.
>>      
> IMO this was because this driver does two things: programming iommu and
> handling interrupts. uio does interrupt handling.
> We could have moved iommu / DMA programming to
> a separate driver, and have uio work with it.
> This would solve limitation of the current driver
> that is needs an iommu domain per device.
>    

How do we enforce security then?  We need to ensure that unprivileged 
users can only use the device with an iommu.

>> [a pony for avi...]
>> The major new functionality in this version is the ability to deal with
>> PCI config space accesses (through read&  write calls) - but includes table
>> driven code to determine whats safe to write and what is not.
>>      
> I don't really see why this is helpful: a driver written corrrectly
> will not access these addresses, and we need an iommu anyway to protect
> us against a drivers.
>    

Haven't reviewed the code (yet) but things like the BARs, MSI, and 
interrupt disable need to be protected from the guest regardless of the 
iommu.


-- 
error compiling committee.c: too many arguments to function

