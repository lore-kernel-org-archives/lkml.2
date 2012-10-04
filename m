Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946365Ab2JDVhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:37:34 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58025 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946251Ab2JDVha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:37:30 -0400
MIME-Version: 1.0
In-Reply-To: <506C0D45.3050909@jp.fujitsu.com>
References: <506C0AE8.40702@jp.fujitsu.com> <506C0D45.3050909@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 4 Oct 2012 17:31:26 -0400
X-Google-Sender-Auth: n6Ks7ZNoyn3evubteO6iWtkYZwM
Message-ID: <CAHGf_=pdVLEkGDvbMC7vjd0F8Y_YFdKX85YcLwR+gCQ8Tf2Mcw@mail.gmail.com>
Subject: Re: [PATCH 2/4] acpi,memory-hotplug : rename remove_memory() to offline_memory()
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org, wency@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 6:02 AM, Yasuaki Ishimatsu
<isimatu.yasuaki@jp.fujitsu.com> wrote:
> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>
> add_memory() hot adds a physical memory. But remove_memory does not
> hot remove a phsical memory. It only offlines memory. The name
> confuse us.
>
> So the patch renames remove_memory() to offline_memory(). We will
> use rename_memory() for hot removing memory.
>
> CC: David Rientjes <rientjes@google.com>
> CC: Jiang Liu <liuj97@gmail.com>
> CC: Len Brown <len.brown@intel.com>
> CC: Christoph Lameter <cl@linux.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  drivers/acpi/acpi_memhotplug.c |    2 +-
>  include/linux/memory_hotplug.h |    2 +-
>  mm/memory_hotplug.c            |    6 +++---
>  3 files changed, 5 insertions(+), 5 deletions(-)

Probably, the better way is to just remove remove_memory() and use
offline_pages().

btw, current remove_memory() pfn calculation is just buggy.


> int remove_memory(u64 start, u64 size)
> {
>	unsigned long start_pfn, end_pfn;
>
>	start_pfn = PFN_DOWN(start);
>	end_pfn = start_pfn + PFN_DOWN(size);

It should be:

	start_pfn = PFN_DOWN(start);
	end_pfn = PFN_UP(start + size)

or

	start_pfn = PFN_UP(start);
	end_pfn = PFN_DOWN(start + size)
