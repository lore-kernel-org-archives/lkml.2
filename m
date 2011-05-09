Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1EIU51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 16:57:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53343 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab1EIU5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 16:57:25 -0400
Message-ID: <4DC85519.8020303@kernel.org>
Date: Mon, 09 May 2011 13:56:57 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Yinghai Lu <yinghai.lu@oracle.com>, Kalle Valo <kvalo@adurom.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci, dmar: flush IOTLB before exit domain
References: <4DC34B21.9040203@oracle.com> <1304952530.30435.16.camel@i7.infradead.org>
In-Reply-To: <1304952530.30435.16.camel@i7.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4DC85524.0020,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2011 07:48 AM, David Woodhouse wrote:
> On Thu, 2011-05-05 at 18:13 -0700, Yinghai Lu wrote:
>> @@ -3252,6 +3252,9 @@ static int device_notifier(struct notifi
>>                 return 0;
>>  
>>         if (action == BUS_NOTIFY_UNBOUND_DRIVER && !iommu_pass_through) {
>> +               /* before we remove dev with domain, flush IOTLB */
>> +               flush_unmaps();
>> +
>>                 domain_remove_one_dev_info(domain, pdev);
>>  
>>                 if (!(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) && 
> 
> That calls flush_unmaps() without the async_umap_flush_lock held,
> doesn't it? A few days ago I asked someone else to test this candidate
> patch for a similar issue:
> 
> http://david.woodhou.se/flush-unmaps-on-unbind.patch
> 

Your patch works.

Thanks

Yinghai
