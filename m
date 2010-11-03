Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0KCOPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 10:15:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:8595 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987Ab0KCOPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 10:15:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,289,1286175600"; 
   d="scan'208";a="569969964"
Date: Wed, 3 Nov 2010 22:15:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Pavel Emelianov <xemul@openvz.org>,
        Minchan Kim <minchan.kim@gmail.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Subject: Re: [PATCH] cgroup: prefer [kv]zalloc over [kv]malloc+memset in
 memory controller code.
Message-ID: <20101103141529.GA7713@localhost>
References: <alpine.LNX.2.00.1011012038490.12889@swampdragon.chaosbits.net>
 <20101101200122.GH840@cmpxchg.org>
 <alpine.LNX.2.00.1011012056250.12889@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011012056250.12889@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 08:59:13PM +0100, Jesper Juhl wrote:

> @@ -4169,13 +4169,11 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
>  	 */
>  	if (!node_state(node, N_NORMAL_MEMORY))
>  		tmp = -1;
> -	pn = kmalloc_node(sizeof(*pn), GFP_KERNEL, tmp);
> +	pn = kmalloc_node(sizeof(*pn), GFP_KERNEL|__GFP_ZERO, tmp);

Use the simpler kzalloc_node()? It's introduced here:

        commit 979b0fea2d9ae5d57237a368d571cbc84655fba6
        Author: Jeff Layton <jlayton@redhat.com>
        Date:   Thu Jun 5 22:47:00 2008 -0700

            vm: add kzalloc_node() inline


Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks,
Fengguang
