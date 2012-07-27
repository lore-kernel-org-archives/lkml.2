Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab2G0Kpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:45:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50298 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2G0Kpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 06:45:33 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5012712E.9000005@jp.fujitsu.com>
Date: Fri, 27 Jul 2012 19:45:02 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
        <linux-ia64@vger.kernel.org>, <cmetcalf@tilera.com>,
        <rientjes@google.com>, <liuj97@gmail.com>, <len.brown@intel.com>,
        <benh@kernel.crashing.org>, <paulus@samba.org>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC PATCH v5 19/19] memory-hotplug: remove sysfs file of node
References: <50126B83.3050201@cn.fujitsu.com> <50126F21.803@cn.fujitsu.com>
In-Reply-To: <50126F21.803@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wen,

2012/07/27 19:36, Wen Congyang wrote:
> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>
> The patch adds node_set_offline() and unregister_one_node() to remove_memory()
> for removing sysfs file of node.
>
> CC: David Rientjes <rientjes@google.com>
> CC: Jiang Liu <liuj97@gmail.com>
> CC: Len Brown <len.brown@intel.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Paul Mackerras <paulus@samba.org>
> CC: Christoph Lameter <cl@linux.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Wen Congyang <wency@cn.fujitsu.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> ---
>   mm/memory_hotplug.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 5ac035f..5681968 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1267,6 +1267,11 @@ int __ref remove_memory(int nid, u64 start, u64 size)
>   	/* remove memmap entry */
>   	firmware_map_remove(start, start + size, "System RAM");
>
> +	if (!node_present_pages(nid)) {

Applying [PATCH v5 17/19], pgdat->node_spanned_pages can become 0 when
all memory of the pgdat is removed. When pgdat->node_spanned_pages is 0,
it means the pgdat has no memory. So I think node_spanned_pages() is
better.

Thanks,
Yasuaki Ishimatsu

> +		node_set_offline(nid);
> +		unregister_one_node(nid);
> +	}
> +
>   	arch_remove_memory(start, size);
>   out:
>   	unlock_memory_hotplug();
>


