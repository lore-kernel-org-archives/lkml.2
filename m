Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab2I0MoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:44:23 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48966 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2I0MoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:44:22 -0400
Message-ID: <50644A1B.3070108@gmail.com>
Date: Thu, 27 Sep 2012 20:44:11 +0800
From: Ni zhan Chen <nizhan.chen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: wency@cn.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH 4/4] memory-hotplug: auto offline page_cgroup when onlining
 memory block failed
References: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com> <1348724705-23779-5-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1348724705-23779-5-git-send-email-wency@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 01:45 PM, wency@cn.fujitsu.com wrote:
> From: Wen Congyang <wency@cn.fujitsu.com>
>
> When a memory block is onlined, we will try allocate memory on that node
> to store page_cgroup. If onlining the memory block failed, we don't
> offline the page cgroup, and we have no chance to offline this page cgroup
> unless the memory block is onlined successfully again. It will cause
> that we can't hot-remove the memory device on that node, because some
> memory is used to store page cgroup. If onlining the memory block
> is failed, there is no need to stort page cgroup for this memory. So
> auto offline page_cgroup when onlining memory block failed.

looks reasonable to me. thanks.

>
> CC: David Rientjes <rientjes@google.com>
> CC: Jiang Liu <liuj97@gmail.com>
> CC: Len Brown <len.brown@intel.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: Paul Mackerras <paulus@samba.org>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
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

