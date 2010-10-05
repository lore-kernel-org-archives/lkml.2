Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab0JEPnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 11:43:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59067 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab0JEPnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 11:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qbJ8dK1ALyQ7LrXU1ubMwnrWswzdLWA6dwMOp683bqUwXbFLOZzoB9QcuewTmVTlVw
         lKykK/YVUDLL2e1rAHl/o6CjP5ut3ylZUgT8fTszQqbX9ZnSlVXdbnm1xezZHCNFbSnD
         PDbqsVdr1XXZJC4lizmUqLEMjmKzkrz5S1NwM=
Date: Wed, 6 Oct 2010 00:42:50 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 03/10] memcg: create extensible page stat update
 routines
Message-ID: <20101005154250.GA9515@barrios-desktop>
References: <1286175485-30643-1-git-send-email-gthelen@google.com>
 <1286175485-30643-4-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286175485-30643-4-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 03, 2010 at 11:57:58PM -0700, Greg Thelen wrote:
> Replace usage of the mem_cgroup_update_file_mapped() memcg
> statistic update routine with two new routines:
> * mem_cgroup_inc_page_stat()
> * mem_cgroup_dec_page_stat()
> 
> As before, only the file_mapped statistic is managed.  However,
> these more general interfaces allow for new statistics to be
> more easily added.  New statistics are added with memcg dirty
> page accounting.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Signed-off-by: Andrea Righi <arighi@develer.com>
> ---
>  include/linux/memcontrol.h |   31 ++++++++++++++++++++++++++++---
>  mm/memcontrol.c            |   17 ++++++++---------
>  mm/rmap.c                  |    4 ++--
>  3 files changed, 38 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 159a076..7c7bec4 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -25,6 +25,11 @@ struct page_cgroup;
>  struct page;
>  struct mm_struct;
>  
> +/* Stats that can be updated by kernel. */
> +enum mem_cgroup_write_page_stat_item {
> +	MEMCG_NR_FILE_MAPPED, /* # of pages charged as file rss */
> +};
> +

mem_cgrou_"write"_page_stat_item?
Does "write" make sense to abstract page_state generally?

-- 
Kind regards,
Minchan Kim
