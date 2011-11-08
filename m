Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898Ab1KHP1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:27:40 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:57036 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab1KHP1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:27:37 -0500
Message-ID: <4EB94A51.6070809@oracle.com>
Date: Tue, 08 Nov 2011 07:27:13 -0800
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [RFC PATCH] pciehp: Wait for link get trained in pci_check_link_status()
References: <4EB88238.4050409@oracle.com> <4EB8F434.6090003@jp.fujitsu.com>
In-Reply-To: <4EB8F434.6090003@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4EB94A66.00DE,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2011 01:19 AM, Kenji Kaneshige wrote:

> (2011/11/08 10:13), Yinghai Lu wrote:
>>
>> Found one PCI Express Modules has link training error after hotplug.
>> It turns out that after DLLLA is set, LT is still set for a while.
>> So pciehp will delcare that hotplug fail in 1s.
> 
> I think DLLLA bit reads 1b means LT is completed. So I don't know why LT
> is still set on your platform.


recovery training ?

> 
>>
>> HW guys say that pciehp is against PCI-e SPEC:
>>   From PCI Express Base Specification Revision 2.1, Section 6.7.3.3:
>>   Software must allow 1 second after the Data Link Layer Link Active bit reads 1b
>>   before it is permitted to determine that a hot plugged device which fails to
>>   return a Successful Completion for a Valid Configuration Request is a broken
>>   device (see section 6.6).
>>
>> Try to wait for long enough by adding LT checking in 1s.
> 
> The pciehp driver already have this 1 second wait in board_added().
> So I still don't understand what in pciehp is against PCIe spec clearly.
> Can you explain more about this?


should be fail in 1s after DLLLA, is set.

even we should not check LT, and should try pci conf reading to new added device.

> 
> What about the patch below? I think it's much simpler and has less impact.


Should work. will try it today.

Thanks

Yinghai Lu
