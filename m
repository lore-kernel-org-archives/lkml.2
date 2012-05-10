Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761318Ab2EJSgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:36:20 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36728 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760669Ab2EJSgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:36:18 -0400
Message-ID: <4FAC0A9E.3020909@sgi.com>
Date: Thu, 10 May 2012 13:36:14 -0500
From: Mark Tinguely <tinguely@sgi.com>
User-Agent: Mozilla/5.0 (X11; FreeBSD amd64; rv:9.0) Gecko/20120122 Thunderbird/9.0
MIME-Version: 1.0
To: Ben Myers <bpm@sgi.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: linux-next: build failure after merge of the xfs tree
References: <20120510130134.0efffc5ba1f3a80c614e8f29@canb.auug.org.au> <20120510183245.GL3963@sgi.com>
In-Reply-To: <20120510183245.GL3963@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/12 13:32, Ben Myers wrote:

> Signed-off-by: Ben Myers<bpm@sgi.com>
>
> Index: xfs/fs/xfs/xfs_alloc.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_alloc.c
> +++ xfs/fs/xfs/xfs_alloc.c
> @@ -47,8 +47,6 @@ STATIC int xfs_alloc_ag_vextent_near(xfs
>   STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
>   STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
>   		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
> -STATIC void xfs_extent_busy_trim(struct xfs_alloc_arg *,
> -		xfs_agblock_t, xfs_extlen_t, xfs_agblock_t *, xfs_extlen_t *);
>
>   /*
>    * Lookup the record equal to [bno, len] in the btree given by cur.
> Index: xfs/fs/xfs/xfs_extent_busy.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_extent_busy.c
> +++ xfs/fs/xfs/xfs_extent_busy.c
> @@ -345,7 +345,7 @@ restart:
>    * args->minlen no suitable extent could be found, and the higher level
>    * code needs to force out the log and retry the allocation.
>    */
> -STATIC void
> +void
>   xfs_extent_busy_trim(
>   	struct xfs_alloc_arg	*args,
>   	xfs_agblock_t		bno,
> Index: xfs/fs/xfs/xfs_extent_busy.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_extent_busy.h
> +++ xfs/fs/xfs/xfs_extent_busy.h
> @@ -54,6 +54,10 @@ void
>   xfs_extent_busy_reuse(struct xfs_mount *mp, xfs_agnumber_t agno,
>   	xfs_agblock_t fbno, xfs_extlen_t flen, bool userdata);
>
> +void
> +xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t bno,
> +	xfs_extlen_t len, xfs_agblock_t *rbno, xfs_extlen_t *rlen);
> +
>   int
>   xfs_extent_busy_ag_cmp(void *priv, struct list_head *a, struct list_head *b);
>
>

Hmmm, I saw that before. I have been hand patching that to test.

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

