Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab2JQP0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:26:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40312 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab2JQP0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:26:39 -0400
Message-ID: <507ECE16.7030107@gmail.com>
Date: Wed, 17 Oct 2012 23:26:14 +0800
From: Wen Congyang <wencongyang@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: wency@cn.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 3/5] memory-hotplug: auto offline page_cgroup when
 onlining memory block failed
References: <1350475735-26136-1-git-send-email-wency@cn.fujitsu.com> <1350475735-26136-4-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1350475735-26136-4-git-send-email-wency@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 2012/10/17 20:08, wency@cn.fujitsu.com Wrote:
> From: Wen Congyang<wency@cn.fujitsu.com>
> 
> When a memory block is onlined, we will try allocate memory on that node
> to store page_cgroup. If onlining the memory block failed, we don't
> offline the page cgroup, and we have no chance to offline this page cgroup
> unless the memory block is onlined successfully again. It will cause
> that we can't hot-remove the memory device on that node, because some
> memory is used to store page cgroup. If onlining the memory block
> is failed, there is no need to stort page cgroup for this memory. So
> auto offline page_cgroup when onlining memory block failed.
> 
> CC: David Rientjes<rientjes@google.com>
> CC: Jiang Liu<liuj97@gmail.com>
> CC: Len Brown<len.brown@intel.com>
> CC: Benjamin Herrenschmidt<benh@kernel.crashing.org>
> CC: Paul Mackerras<paulus@samba.org>
> CC: Christoph Lameter<cl@linux.com>
> Cc: Minchan Kim<minchan.kim@gmail.com>
> CC: Andrew Morton<akpm@linux-foundation.org>
> CC: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> CC: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Wen Congyang<wency@cn.fujitsu.com>

This patch has been acked by kosaki.
I forgot to add "Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>"


> ---
>   mm/page_cgroup.c |    3 +++
>   1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 5ddad0c..44db00e 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -251,6 +251,9 @@ static int __meminit page_cgroup_callback(struct notifier_block *self,
>   				mn->nr_pages, mn->status_change_nid);
>   		break;
>   	case MEM_CANCEL_ONLINE:
> +		offline_page_cgroup(mn->start_pfn,
> +				mn->nr_pages, mn->status_change_nid);
> +		break;
>   	case MEM_GOING_OFFLINE:
>   		break;
>   	case MEM_ONLINE:
