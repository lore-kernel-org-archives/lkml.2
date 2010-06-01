Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab0FAMo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:44:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756310Ab0FAMoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:44:25 -0400
Message-ID: <4C050013.2020701@redhat.com>
Date: Tue, 01 Jun 2010 15:41:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, chrisw@sous-sol.org, joro@8bytes.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
References: <20100530124949.GI27611@redhat.com> <4C0261C1.9090204@redhat.com> <20100530130332.GM27611@redhat.com> <4C026497.8070901@redhat.com> <20100530145309.GO27611@redhat.com> <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com> <4C04E0E0.3070006@redhat.com> <20100601104651.GA9415@redhat.com>
In-Reply-To: <20100601104651.GA9415@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 01:46 PM, Michael S. Tsirkin wrote:
>
>> Since vfio would be the only driver, there would be no duplication.  But
>> a separate object for the iommu mapping is a good thing.  Perhaps we can
>> even share it with vhost (without actually using the mmu, since vhost is
>> software only).
>>      
> Main difference is that vhost works fine with unlocked
> memory, paging it in on demand. iommu needs to unmap
> memory when it is swapped out or relocated.
>
>    

So you'd just take the memory map and not pin anything.  This way you 
can reuse the memory map.

But no, it doesn't handle the dirty bitmap, so no go.

-- 
error compiling committee.c: too many arguments to function

