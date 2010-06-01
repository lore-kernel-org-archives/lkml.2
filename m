Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab0FAILL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:11:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab0FAILI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:11:08 -0400
Message-ID: <4C04C085.1030107@redhat.com>
Date: Tue, 01 Jun 2010 11:10:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, chrisw@sous-sol.org, joro@8bytes.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
References: <4c004cba.Z/2Hpd7reetFaFC5%pugs@cisco.com> <20100530121944.GH27611@redhat.com> <4C025999.7080706@redhat.com> <20100530124949.GI27611@redhat.com> <4C0261C1.9090204@redhat.com> <20100530130332.GM27611@redhat.com> <4C026497.8070901@redhat.com> <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com>
In-Reply-To: <20100531171007.GA6516@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 08:10 PM, Michael S. Tsirkin wrote:
> On Mon, May 31, 2010 at 02:50:29PM +0300, Avi Kivity wrote:
>    
>> On 05/30/2010 05:53 PM, Michael S. Tsirkin wrote:
>>      
>>> So what I suggested is failing any kind of access until iommu
>>> is assigned.
>>>
>>>        
>> So, the kernel driver must be aware of the iommu.  In which case it may
>> as well program it.
>>      
> It's a kernel driver anyway. Point is that
> the *device* driver is better off not programming iommu,
> this way we do not need to reprogram it for each device.
>    

The device driver is in userspace.  It can't program the iommu.  What 
the patch proposes is that userspace tells vfio about the needed 
mappings, and vfio programs the iommu.

-- 
error compiling committee.c: too many arguments to function

