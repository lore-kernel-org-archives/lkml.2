Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945961Ab2JaSQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:16:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61859 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935727Ab2JaSQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:16:38 -0400
Date: Wed, 31 Oct 2012 11:16:35 -0700 (PDT)
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
Subject: Re: [PART3 Patch 00/14] introduce N_MEMORY
In-Reply-To: <1351670652-9932-1-git-send-email-wency@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1210311112010.8809@chino.kir.corp.google.com>
References: <1351670652-9932-1-git-send-email-wency@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Wen Congyang wrote:

> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> This patch is part3 of the following patchset:
>     https://lkml.org/lkml/2012/10/29/319
> 
> Part1 is here:
>     https://lkml.org/lkml/2012/10/31/30
> 
> Part2 is here:
>     http://marc.info/?l=linux-kernel&m=135166705909544&w=2
> 
> You can apply this patchset without the other parts.
> 
> we need a node which only contains movable memory. This feature is very
> important for node hotplug. So we will add a new nodemask
> for all memory. N_MEMORY contains movable memory but N_HIGH_MEMORY
> doesn't contain it.
> 
> We don't remove N_HIGH_MEMORY because it can be used to search which
> nodes contains memory that the kernel can use.
> 

This doesn't describe why we need the new node state, unfortunately.  It 
makes sense to boot with node(s) containing only ZONE_MOVABLE, but it 
doesn't show why we need a nodemask to specify such nodes and such 
information should be available from the kernel log or /proc/zoneinfo.

Node hotplug should fail if all memory cannot be offlined, so why do we 
need another nodemask?  Only offline the node if all memory is offlined.
