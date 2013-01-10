Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab3AJGId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 01:08:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:29483 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab3AJGIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 01:08:31 -0500
X-IronPort-AV: E=Sophos;i="4.84,442,1355068800"; 
   d="scan'208";a="6556344"
Message-ID: <50EE5AA9.3090401@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 14:07:37 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rientjes@google.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, cl@linux.com, minchan.kim@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        wujianguo@huawei.com, wency@cn.fujitsu.com, hpa@zytor.com,
        linfeng@cn.fujitsu.com, laijs@cn.fujitsu.com, mgorman@suse.de,
        yinghai@kernel.org, glommer@parallels.com, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH v6 04/15] memory-hotplug: remove /sys/firmware/memmap/X
 sysfs
References: <1357723959-5416-1-git-send-email-tangchen@cn.fujitsu.com> <1357723959-5416-5-git-send-email-tangchen@cn.fujitsu.com> <20130109144905.8993886a.akpm@linux-foundation.org>
In-Reply-To: <20130109144905.8993886a.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 14:07:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 14:07:53,
	Serialize complete at 2013/01/10 14:07:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 01/10/2013 06:49 AM, Andrew Morton wrote:
> On Wed, 9 Jan 2013 17:32:28 +0800
> Tang Chen<tangchen@cn.fujitsu.com>  wrote:
>
>> When (hot)adding memory into system, /sys/firmware/memmap/X/{end, start, type}
>> sysfs files are created. But there is no code to remove these files. The patch
>> implements the function to remove them.
>>
>> Note: The code does not free firmware_map_entry which is allocated by bootmem.
>>        So the patch makes memory leak. But I think the memory leak size is
>>        very samll. And it does not affect the system.
>
> Well that's bad.  Can we remember the address of that memory and then
> reuse the storage if/when the memory is re-added?  That at least puts an upper
> bound on the leak.

I think we can do this. I'll post a new patch to do so.

Thanks. :)

>
>

