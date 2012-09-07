Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab2IGW7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 18:59:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37757 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331Ab2IGW7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 18:59:02 -0400
Date: Fri, 7 Sep 2012 15:58:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: wujianguo <wujianguo106@gmail.com>
cc: tony.luck@intel.com, akpm@linux-foundation.org, fenghua.yu@intel.com,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jiang.liu@huawei.com, guohanjun@huawei.com,
        qiuxishi@huawei.com, wujianguo@huawei.com, wency@cn.fujitsu.com
Subject: Re: [PATCH RESEND]mm/ia64: fix a node distance bug
In-Reply-To: <50484E2C.1060107@gmail.com>
Message-ID: <alpine.DEB.2.00.1209071558430.28027@chino.kir.corp.google.com>
References: <50484E2C.1060107@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Sep 2012, wujianguo wrote:

> From: Jianguo Wu <wujianguo@huawei.com>
> 
> In arch ia64, has following definition:
> extern u8 numa_slit[MAX_NUMNODES * MAX_NUMNODES];
> #define node_distance(from,to) (numa_slit[(from) * num_online_nodes() + (to)])
> 
> num_online_nodes() is a variable value, it can be changed after hot-remove/add
> a node.
> 
> I my practice, I found node distance is wrong after offline
> a node in IA64 platform. For example system has 4 nodes:
> node distances:
> node   0   1   2   3
>   0:  10  21  21  32
>   1:  21  10  32  21
>   2:  21  32  10  21
>   3:  32  21  21  10
> 
> linux-drf:/sys/devices/system/node/node0 # cat distance
> 10  21  21  32
> linux-drf:/sys/devices/system/node/node1 # cat distance
> 21  10  32  21
> 
> After offline node2:
> linux-drf:/sys/devices/system/node/node0 # cat distance
> 10 21 32
> linux-drf:/sys/devices/system/node/node1 # cat distance
> 32 21 32	--------->expected value is: 21  10  21
> 
> 
> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>

Acked-by: David Rientjes <rientjes@google.com>
