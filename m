Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051Ab1EMJsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:48:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56853 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552Ab1EMJsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:48:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 13 May 2011 18:41:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC][PATCH v7 08/14] writeback: add memcg fields to
 writeback_control
Message-Id: <20110513184120.0f9444bc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1305276473-14780-9-git-send-email-gthelen@google.com>
References: <1305276473-14780-1-git-send-email-gthelen@google.com>
	<1305276473-14780-9-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011 01:47:47 -0700
Greg Thelen <gthelen@google.com> wrote:

> Add writeback_control fields to differentiate between bdi-wide and
> per-cgroup writeback.  Cgroup writeback is also able to differentiate
> between writing inodes isolated to a particular cgroup and inodes shared
> by multiple cgroups.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Personally, I want to see new flags with their usage in a patch...


> ---
>  include/linux/writeback.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index d10d133..4f5c0d2 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -47,6 +47,8 @@ struct writeback_control {
>  	unsigned for_reclaim:1;		/* Invoked from the page allocator */
>  	unsigned range_cyclic:1;	/* range_start is cyclic */
>  	unsigned more_io:1;		/* more io to be dispatched */
> +	unsigned for_cgroup:1;		/* enable cgroup writeback */
> +	unsigned shared_inodes:1;	/* write inodes spanning cgroups */
>  };


If shared_inode is really rare case...we don't need to have this shared_inodes
flag and do writeback shared_inode always.....No ?

Thanks,
-Kame

