Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab2IEBq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 21:46:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55962 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab2IEBqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 21:46:23 -0400
X-IronPort-AV: E=Sophos;i="4.80,371,1344182400"; 
   d="scan'208";a="5784267"
Message-ID: <5046ADB2.9020703@cn.fujitsu.com>
Date: Wed, 05 Sep 2012 09:41:06 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC v8 PATCH 08/20] memory-hotplug: remove /sys/firmware/memmap/X
 sysfs
References: <1346148027-24468-1-git-send-email-wency@cn.fujitsu.com>	<1346148027-24468-9-git-send-email-wency@cn.fujitsu.com>	<20120831140623.8d13bd2c.akpm@linux-foundation.org>	<5044454E.7070909@cn.fujitsu.com> <20120904161634.f1f9f693.akpm@linux-foundation.org>
In-Reply-To: <20120904161634.f1f9f693.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 09:35:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 09:35:34,
	Serialize complete at 2012/09/05 09:35:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 09/05/2012 07:16 AM, Andrew Morton Wrote:
> On Mon, 03 Sep 2012 13:51:10 +0800
> Wen Congyang <wency@cn.fujitsu.com> wrote:
> 
>>>> +static void release_firmware_map_entry(struct kobject *kobj)
>>>> +{
>>>> +	struct firmware_map_entry *entry = to_memmap_entry(kobj);
>>>> +	struct page *page;
>>>> +
>>>> +	page = virt_to_page(entry);
>>>> +	if (PageSlab(page) || PageCompound(page))
>>>
>>> That PageCompound() test looks rather odd.  Why is this done?
>>
>> Liu Jiang and Christoph Lameter discussed how to find slab page
>> in this mail:
>> https://lkml.org/lkml/2012/7/6/333.
> 
> Well, please add a code comment to release_firmware_map_entry() which
> fully explains these things.
> 
> I see that Christoph and I agree: "It would be cleaner if memory
> hotplug had an indicator which allocation mechanism was used and would
> use the corresponding free action".  You didn't respond to this
> suggestion when he made it, nor when I made it.  What are your thoughts
> on this?

Hmm, I think it is better to use an indicator which allocation mechanism was
used. I will do it in the next version.

Thanks
Wen Congyang
