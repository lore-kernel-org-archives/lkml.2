Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593Ab2JaS3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:29:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34686 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab2JaS3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:29:20 -0400
Date: Wed, 31 Oct 2012 11:29:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wen Congyang <wency@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [PART2 Patch] node: cleanup node_state_attr
In-Reply-To: <1351666528-8226-2-git-send-email-wency@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1210311128570.8809@chino.kir.corp.google.com>
References: <1351666528-8226-1-git-send-email-wency@cn.fujitsu.com> <1351666528-8226-2-git-send-email-wency@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Wen Congyang wrote:

> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index af1a177..5d7731e 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -614,23 +614,23 @@ static ssize_t show_node_state(struct device *dev,
>  	{ __ATTR(name, 0444, show_node_state, NULL), state }
>  
>  static struct node_attr node_state_attr[] = {
> -	_NODE_ATTR(possible, N_POSSIBLE),
> -	_NODE_ATTR(online, N_ONLINE),
> -	_NODE_ATTR(has_normal_memory, N_NORMAL_MEMORY),
> -	_NODE_ATTR(has_cpu, N_CPU),
> +	[N_POSSIBLE] = _NODE_ATTR(possible, N_POSSIBLE),
> +	[N_ONLINE] = _NODE_ATTR(online, N_ONLINE),
> +	[N_NORMAL_MEMORY] = _NODE_ATTR(has_normal_memory, N_NORMAL_MEMORY),
>  #ifdef CONFIG_HIGHMEM
> -	_NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
> +	[N_HIGH_MEMORY] = _NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
>  #endif
> +	[N_CPU] = _NODE_ATTR(has_cpu, N_CPU),
>  };
>  

Why change the index for N_CPU?

>  static struct attribute *node_state_attrs[] = {
> -	&node_state_attr[0].attr.attr,
> -	&node_state_attr[1].attr.attr,
> -	&node_state_attr[2].attr.attr,
> -	&node_state_attr[3].attr.attr,
> +	&node_state_attr[N_POSSIBLE].attr.attr,
> +	&node_state_attr[N_ONLINE].attr.attr,
> +	&node_state_attr[N_NORMAL_MEMORY].attr.attr,
>  #ifdef CONFIG_HIGHMEM
> -	&node_state_attr[4].attr.attr,
> +	&node_state_attr[N_HIGH_MEMORY].attr.attr,
>  #endif
> +	&node_state_attr[N_CPU].attr.attr,
>  	NULL
>  };
>  
