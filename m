Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab1F2UB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:01:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753492Ab1F2UBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:01:23 -0400
Date: Wed, 29 Jun 2011 13:00:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH] [Cleanup] memcg: export memory cgroup's swappiness v2
Message-Id: <20110629130043.4dc47249.akpm@linux-foundation.org>
In-Reply-To: <20110629190325.28aa2dc6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110629190325.28aa2dc6.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011 19:03:25 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Each memory cgroup has 'swappiness' value and it can be accessed by
> get_swappiness(memcg). The major user is try_to_free_mem_cgroup_pages()
> and swappiness is passed by argument. It's propagated by scan_control.
> 
> get_swappiness is static function but some planned updates will need to
> get swappiness from files other than memcontrol.c
> This patch exports get_swappiness() as mem_cgroup_swappiness().
> By this, we can remove the argument of swapiness from try_to_free...
> and drop swappiness from scan_control. only memcg uses it.
> 

> +extern unsigned int mem_cgroup_swappiness(struct mem_cgroup *mem);
> +unsigned int mem_cgroup_swappiness(struct mem_cgroup *memcg)
> +static int vmscan_swappiness(struct scan_control *sc)

The patch seems a bit confused about the signedness of swappiness.
