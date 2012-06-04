Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761086Ab2FDW21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 18:28:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761051Ab2FDW20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 18:28:26 -0400
Message-ID: <4FCD3679.60706@redhat.com>
Date: Mon, 04 Jun 2012 18:28:09 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: dwmw2@infradead.org, iommu@lists.linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, chrisw@redhat.com,
        suresh.b.siddha@intel.com
Subject: Re: [PATCH 1/2] iommu: dmar: replace printks with appropriate pr_*()
References: <1338845342-12464-1-git-send-email-ddutile@redhat.com>	 <1338845342-12464-2-git-send-email-ddutile@redhat.com> <1338848137.18442.2.camel@joe2Laptop>
In-Reply-To: <1338848137.18442.2.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 06:15 PM, Joe Perches wrote:
> On Mon, 2012-06-04 at 17:29 -0400, Donald Dutile wrote:
>> Replace printk(KERN_*  with pr_*() functions.
>
> Please add
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> before any include and remove the embedded PREFIX
> from each printk
>
>> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
>
> []
>
>>   			break;
>>   		}
>>   		pdev = pci_get_slot(bus, PCI_DEVFN(path->dev, path->fn));
>>   		if (!pdev) {
>> -			printk(KERN_WARNING PREFIX
>> -			"Device scope device [%04x:%02x:%02x.%02x] not found\n",
>> +			pr_warn(PREFIX "Device scope device"
>> +				"[%04x:%02x:%02x.%02x] not found\n",
>>   				segment, bus->number, path->dev, path->fn);
>
> Please don't split any format string.  You removed
> a space between the scope device and an open bracket.
> It's OK for format strings to exceed 80 chars.
>
>
Joe,
Thanks for the feeback.  I'll incorporate the changes once
others have a chance to review & feedback as well.

- Don

