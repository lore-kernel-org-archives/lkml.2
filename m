Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab2JHFUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 01:20:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:24607 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab2JHFUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 01:20:44 -0400
X-IronPort-AV: E=Sophos;i="4.80,551,1344182400"; 
   d="scan'208";a="5957679"
Message-ID: <507263F8.9040200@cn.fujitsu.com>
Date: Mon, 08 Oct 2012 13:26:16 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] memory-hotplug: hot-remove physical memory
References: <506E43E0.70507@jp.fujitsu.com> <CAHGf_=qCZvL7xcOkea80Y995sZWkOMQLLVnuvLUto4W+qpUbWA@mail.gmail.com>
In-Reply-To: <CAHGf_=qCZvL7xcOkea80Y995sZWkOMQLLVnuvLUto4W+qpUbWA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/08 13:20:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/08 13:20:36,
	Serialize complete at 2012/10/08 13:20:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/06/2012 03:06 AM, KOSAKI Motohiro Wrote:
>> Known problems:
>> 1. memory can't be offlined when CONFIG_MEMCG is selected.
>>    For example: there is a memory device on node 1. The address range
>>    is [1G, 1.5G). You will find 4 new directories memory8, memory9, memory10,
>>    and memory11 under the directory /sys/devices/system/memory/.
>>    If CONFIG_MEMCG is selected, we will allocate memory to store page cgroup
>>    when we online pages. When we online memory8, the memory stored page cgroup
>>    is not provided by this memory device. But when we online memory9, the memory
>>    stored page cgroup may be provided by memory8. So we can't offline memory8
>>    now. We should offline the memory in the reversed order.
>>    When the memory device is hotremoved, we will auto offline memory provided
>>    by this memory device. But we don't know which memory is onlined first, so
>>    offlining memory may fail. In such case, you should offline the memory by
>>    hand before hotremoving the memory device.
> 
> Just iterate twice. 1st iterate: offline every non primary memory
> block. 2nd iterate:
> offline primary (i.e. first added) memory block. It may work.
> 

OK, I will try it.

Thanks
Wen Congyang
