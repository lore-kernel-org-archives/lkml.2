Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab1HRBUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 21:20:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44516 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab1HRBUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 21:20:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 18 Aug 2011 10:13:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dave Chinner <david@fromorbit.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v9 09/13] memcg: create support routines for writeback
Message-Id: <20110818101304.fa662053.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1313597705-6093-10-git-send-email-gthelen@google.com>
References: <1313597705-6093-1-git-send-email-gthelen@google.com>
	<1313597705-6093-10-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011 09:15:01 -0700
Greg Thelen <gthelen@google.com> wrote:

> Introduce memcg routines to assist in per-memcg writeback:
> 
> - mem_cgroups_over_bground_dirty_thresh() determines if any cgroups need
>   writeback because they are over their dirty memory threshold.
> 
> - should_writeback_mem_cgroup_inode() will be called by writeback to
>   determine if a particular inode should be written back.  The answer
>   depends on the writeback context (foreground, background,
>   try_to_free_pages, etc.).
> 
> - mem_cgroup_writeback_done() is used periodically during writeback to
>   update memcg writeback data.
> 
> These routines make use of a new over_bground_dirty_thresh bitmap that
> indicates which mem_cgroup are over their respective dirty background
> threshold.  As this bitmap is indexed by css_id, the largest possible
> css_id value is needed to create the bitmap.  So move the definition of
> CSS_ID_MAX from cgroup.c to cgroup.h.  This allows users of css_id() to
> know the largest possible css_id value.  This knowledge can be used to
> build such per-cgroup bitmaps.
> 
> Make determine_dirtyable_memory() non-static because it is needed by
> mem_cgroup_writeback_done().
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>




