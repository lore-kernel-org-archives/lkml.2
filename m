Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab0FBMZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:25:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab0FBMZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:25:27 -0400
Message-ID: <4C064DA7.6060504@redhat.com>
Date: Wed, 02 Jun 2010 15:25:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
References: <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com> <20100602094201.GC964@8bytes.org> <20100602095312.GA25335@redhat.com> <20100602101940.GG964@8bytes.org> <20100602102144.GD29023@redhat.com> <20100602103516.GI964@8bytes.org> <20100602103828.GF29023@redhat.com> <20100602111224.GA11033@8bytes.org> <20100602112100.GA29697@redhat.com> <20100602121927.GA11162@8bytes.org>
In-Reply-To: <20100602121927.GA11162@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 03:19 PM, Joerg Roedel wrote:
>
>> Yes.  so you do:
>> iommu = open
>> ioctl(dev1, BIND, iommu)
>> ioctl(dev2, BIND, iommu)
>> ioctl(dev3, BIND, iommu)
>> ioctl(dev4, BIND, iommu)
>>
>> No need to add a SHARE ioctl.
>>      
> In my proposal this looks like:
>
>
> dev1 = open();
> ioctl(dev2, SHARE, dev1);
> ioctl(dev3, SHARE, dev1);
> ioctl(dev4, SHARE, dev1);
>
> So we actually save an ioctl.
>    

The problem with this is that it is assymetric, dev1 is treated 
differently from dev[234].  It's an unintuitive API.

-- 
error compiling committee.c: too many arguments to function

