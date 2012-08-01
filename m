Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab2HABhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 21:37:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42403 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab2HABhX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 21:37:23 -0400
X-IronPort-AV: E=Sophos;i="4.77,690,1336320000"; 
   d="scan'208";a="5524027"
Message-ID: <5018897E.4040109@cn.fujitsu.com>
Date: Wed, 01 Aug 2012 09:42:22 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: gerald.schaefer@de.ibm.com
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-ia64@vger.kernel.org,
        cmetcalf@tilera.com, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [RFC PATCH v5 12/19] memory-hotplug: introduce new function arch_remove_memory()
References: <50126B83.3050201@cn.fujitsu.com>	<50126E2F.8010301@cn.fujitsu.com>	<20120730102305.GB3631@osiris.boeblingen.de.ibm.com>	<50166379.4090305@cn.fujitsu.com> <20120731144000.33fd4a0a@thinkpad>
In-Reply-To: <20120731144000.33fd4a0a@thinkpad>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/01 09:37:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/01 09:37:54
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 07/31/2012 08:40 PM, Gerald Schaefer Wrote:
> On Mon, 30 Jul 2012 18:35:37 +0800
> Wen Congyang <wency@cn.fujitsu.com> wrote:
> 
>> At 07/30/2012 06:23 PM, Heiko Carstens Wrote:
>>> On Fri, Jul 27, 2012 at 06:32:15PM +0800, Wen Congyang wrote:
>>>> We don't call __add_pages() directly in the function add_memory()
>>>> because some other architecture related things need to be done
>>>> before or after calling __add_pages(). So we should introduce
>>>> a new function arch_remove_memory() to revert the things
>>>> done in arch_add_memory().
>>>>
>>>> Note: the function for s390 is not implemented(I don't know how to
>>>> implement it for s390).
>>>
>>> There is no hardware or firmware interface which could trigger a
>>> hot memory remove on s390. So there is nothing that needs to be
>>> implemented.
>>
>> Thanks for providing this information.
>>
>> According to this, arch_remove_memory() for s390 can just return
>> -EBUSY.
> 
> Yes, but there is a prototype mismatch for arch_remove_memory() on s390
> and also other architectures (u64 vs. unsigned long).
> 
> arch/s390/mm/init.c:262: error: conflicting types for
> ‘arch_remove_memory’ include/linux/memory_hotplug.h:88: error: previous
> declaration of ‘arch_remove_memory’ was here
> 
> In memory_hotplug.h you have:
> extern int arch_remove_memory(unsigned long start, unsigned long size);
> 
> On all archs other than x86 you have:
> int arch_remove_memory(u64 start, u64 size)

Thanks for pointing it out. I will fix it.

Wen Congyang

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

