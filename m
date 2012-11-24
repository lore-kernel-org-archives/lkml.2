Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab2KXBUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 20:20:10 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:55509 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab2KXBUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 20:20:08 -0500
Message-ID: <50B020A4.9060801@huawei.com>
Date: Sat, 24 Nov 2012 09:19:32 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: <hpa@zytor.com>, <akpm@linux-foundation.org>, <rob@landley.net>,
        <isimatu.yasuaki@jp.fujitsu.com>, <laijs@cn.fujitsu.com>,
        <wency@cn.fujitsu.com>, <linfeng@cn.fujitsu.com>, <yinghai@kernel.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <minchan.kim@gmail.com>,
        <mgorman@suse.de>, <rientjes@google.com>, <rusty@rustcorp.com.au>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] x86: get pg_data_t's memory from other node
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <1353667445-7593-2-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1353667445-7593-2-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-23 18:44, Tang Chen wrote:
> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> If system can create movable node which all memory of the
> node is allocated as ZONE_MOVABLE, setup_node_data() cannot
> allocate memory for the node's pg_data_t.
> So when memblock_alloc_nid() fails, setup_node_data() retries
> memblock_alloc().
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  arch/x86/mm/numa.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index 2d125be..734bbd2 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -224,9 +224,14 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
>  	} else {
>  		nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
>  		if (!nd_pa) {
> -			pr_err("Cannot find %zu bytes in node %d\n",
> -			       nd_size, nid);
> -			return;
> +			pr_warn("Cannot find %zu bytes in node %d\n",
> +				nd_size, nid);
Hi Tang，
	Should this be an "pr_info" because the allocation failure is expected?
Regards!
Gerry

