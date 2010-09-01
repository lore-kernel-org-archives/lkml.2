Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab0IAH4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 03:56:19 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34671 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab0IAH4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 03:56:17 -0400
Date: Wed, 1 Sep 2010 16:52:38 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gthelen@google.com, Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
        menage@google.com, "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 2/5] memcg: more use of css ID in memcg.
Message-Id: <20100901165238.5086e67d.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100901154259.5b17bb87.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100901153951.bc82c021.kamezawa.hiroyu@jp.fujitsu.com>
	<20100901154259.5b17bb87.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Sep 2010 15:42:59 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Now, memory cgroup has an ID per cgroup and make use of it at
>  - hierarchy walk,
>  - swap recording.
> 
> This patch is for making more use of it. The final purpose is
> to replace page_cgroup->mem_cgroup's pointer to an unsigned short.
> 
> This patch caches a pointer of memcg in an array. By this, we
> don't have to call css_lookup() which requires radix-hash walk.
> This saves some amount of memory footprint at lookup memcg via id.
> 
> Changelog: 20100901
>  - added unregster_memcg_id() and did some clean up.
>  - removed ->valid.
>  - fixed mem_cgroup_num counter handling.
> 
> Changelog: 20100825
>  - applied comments.
> 
> Changelog: 20100811
>  - adjusted onto mmotm-2010-08-11
>  - fixed RCU related parts.
>  - use attach_id() callback.
> 
> Changelog: 20100804
>  - fixed description in init/Kconfig
> 
> Changelog: 20100730
>  - fixed rcu_read_unlock() placement.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
