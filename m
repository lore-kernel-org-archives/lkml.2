Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab1ETVuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 17:50:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929Ab1ETVtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 17:49:49 -0400
Date: Fri, 20 May 2011 14:49:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, hannes@cmpxchg.org,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 2/8] memcg: easy check routine for reclaimable
Message-Id: <20110520144919.57541b8d.akpm@linux-foundation.org>
In-Reply-To: <20110520124212.facdc595.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110520123749.d54b32fa.kamezawa.hiroyu@jp.fujitsu.com>
	<20110520124212.facdc595.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 12:42:12 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> +bool mem_cgroup_test_reclaimable(struct mem_cgroup *memcg)
> +{
> +	unsigned long nr;
> +	int zid;
> +
> +	for (zid = NODE_DATA(0)->nr_zones - 1; zid >= 0; zid--)
> +		if (mem_cgroup_zone_reclaimable_pages(memcg, 0, zid))
> +			break;
> +	if (zid < 0)
> +		return false;
> +	return true;
> +}

A wee bit of documentation would be nice.  Perhaps improving the name
would suffice: mem_cgroup_has_reclaimable().

