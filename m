Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab2ICBZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 21:25:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64149 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab2ICBZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 21:25:19 -0400
X-IronPort-AV: E=Sophos;i="4.80,357,1344182400"; 
   d="scan'208";a="5768760"
Message-ID: <5044084B.3050705@cn.fujitsu.com>
Date: Mon, 03 Sep 2012 09:30:51 +0800
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
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [RFC v8 PATCH 04/20] memory-hotplug: offline and remove memory
 when removing the memory device
References: <1346148027-24468-1-git-send-email-wency@cn.fujitsu.com>	<1346148027-24468-5-git-send-email-wency@cn.fujitsu.com> <20120831135514.2a2dc0d4.akpm@linux-foundation.org>
In-Reply-To: <20120831135514.2a2dc0d4.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/03 09:24:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/03 09:24:58,
	Serialize complete at 2012/09/03 09:24:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 09/01/2012 04:55 AM, Andrew Morton Wrote:
> On Tue, 28 Aug 2012 18:00:11 +0800
> wency@cn.fujitsu.com wrote:
> 
>> +int remove_memory(int nid, u64 start, u64 size)
>> +{
>> +	int ret = -EBUSY;
>> +	lock_memory_hotplug();
>> +	/*
>> +	 * The memory might become online by other task, even if you offine it.
>> +	 * So we check whether the cpu has been onlined or not.
> 
> I think you meant "memory", not "cpu".

Yes. I will fix it.

Thanks
Wen Congyang

> 
> Actually, "check whether any part of this memory range has been
> onlined" would be better.  If that is accurate ;)
> 
>> +	 */
>> +	if (!is_memblk_offline(start, size)) {
>> +		pr_warn("memory removing [mem %#010llx-%#010llx] failed, "
>> +			"because the memmory range is online\n",
>> +			start, start + size);
>> +		ret = -EAGAIN;
>> +	}
>> +
>> +	unlock_memory_hotplug();
>> +	return ret;
>> +
>> +}
>> +EXPORT_SYMBOL_GPL(remove_memory);
> 

