Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab1I1IuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:50:08 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44810 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1I1IuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:50:06 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2]block: add missed trace_block_plug
References: <1317179490.22361.12.camel@sli10-conroe>
Date: Wed, 28 Sep 2011 17:49:58 +0900
In-Reply-To: <1317179490.22361.12.camel@sli10-conroe> (Shaohua Li's message of
	"Wed, 28 Sep 2011 11:11:30 +0800")
Message-ID: <87ty7xcaq1.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li <shaohua.li@intel.com> writes:

> After flush plug list, the list has no request, so we need
> add a trace_block_plug.
>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: Namhyung Kim <namhyung@gmail.com>


>
> ---
>  block/blk-core.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> Index: linux/block/blk-core.c
> ===================================================================
> --- linux.orig/block/blk-core.c	2011-09-28 11:05:22.000000000 +0800
> +++ linux/block/blk-core.c	2011-09-28 11:05:42.000000000 +0800
> @@ -1307,8 +1307,10 @@ get_rq:
>  				if (__rq->q != q)
>  					plug->should_sort = 1;
>  			}
> -			if (request_count >= BLK_MAX_REQUEST_COUNT)
> +			if (request_count >= BLK_MAX_REQUEST_COUNT) {
>  				blk_flush_plug_list(plug, false);
> +				trace_block_plug(q);
> +			}
>  		}
>  		list_add_tail(&req->queuelist, &plug->list);
>  		drive_stat_acct(req, 1);
