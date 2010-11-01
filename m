Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab0KAUBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:01:32 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:51269 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab0KAUBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:01:30 -0400
Date: Mon, 1 Nov 2010 16:01:22 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Pavel Emelianov <xemul@openvz.org>,
        Minchan Kim <minchan.kim@gmail.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Subject: Re: [PATCH] cgroup: prefer [kv]zalloc over [kv]malloc+memset in
 memory controller code.
Message-ID: <20101101200122.GH840@cmpxchg.org>
References: <alpine.LNX.2.00.1011012038490.12889@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011012038490.12889@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 08:40:56PM +0100, Jesper Juhl wrote:
> Hi (please CC me on replies),
> 
> 
> Apologies to those who receive this multiple times. I screwed up the To: 
> field in my original mail :-(
> 
> 
> In mem_cgroup_alloc() we currently do either kmalloc() or vmalloc() then 
> followed by memset() to zero the memory. This can be more efficiently 
> achieved by using kzalloc() and vzalloc().
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Looks good to me, but there is also the memset after kmalloc in
alloc_mem_cgroup_per_zone_info().  Can you switch that over as well in
this patch?  You can pass __GFP_ZERO to kmalloc_node() for zeroing.

Thanks!
