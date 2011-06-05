Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1FECqy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 22:46:54 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:52045 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab1FECqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 22:46:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MWm50FS9fm+8jA3x1TIftF/ln5vKGeZDx+37bxElPlTOX//LEFWUyXAntFtKwmON1K
         pj/R8T1Wbht0p0p8zcEorLfXbVHXOjEB1pEWp0ZxGOtJEEbCIj0sizbQh1ewFRoJm1xU
         8uTRayvzTkziYZE9oxax+wp8iT4cCBmC0qcF0=
Date: Sun, 5 Jun 2011 11:46:41 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 09/12] memcg: create support routines for writeback
Message-ID: <20110605024641.GA5914@barrios-laptop>
References: <1307117538-14317-1-git-send-email-gthelen@google.com>
 <1307117538-14317-10-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307117538-14317-10-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 09:12:15AM -0700, Greg Thelen wrote:
> Introduce memcg routines to assist in per-memcg writeback:
> 
> - mem_cgroups_over_bground_dirty_thresh() determines if any cgroups need
>   writeback because they are over their dirty memory threshold.
> 
> - should_writeback_mem_cgroup_inode() determines if an inode is
>   contributing pages to an over-limit memcg.  A new writeback_control
>   field determines if shared inodes should be written back.
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
> Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards
Minchan Kim
