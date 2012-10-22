Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab2JVPbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:31:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab2JVPbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:31:34 -0400
Date: Mon, 22 Oct 2012 11:31:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blkcg: stop iteration early if root_rl is the only
 request list
Message-ID: <20121022153127.GB3401@redhat.com>
References: <50750367.2070508@ce.jp.nec.com>
 <20121010155929.GA18733@redhat.com>
 <50762182.5090806@ce.jp.nec.com>
 <20121016232040.GH16166@google.com>
 <507DF58E.8060804@ce.jp.nec.com>
 <20121017134704.GB31663@redhat.com>
 <507F6FE2.3030303@ce.jp.nec.com>
 <20121018133149.GA18147@redhat.com>
 <20121018212053.GK13370@google.com>
 <50849E39.2040609@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50849E39.2040609@ce.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 10:15:37AM +0900, Jun'ichi Nomura wrote:
> __blk_queue_next_rl() finds next request list based on blkg_list
> while skipping root_blkg in the list.
> OTOH, root_rl is special as it may exist even without root_blkg.
> 
> Though the later part of the function handles such a case correctly,
> exiting early is good for readability of the code.
> 

Thanks for the patch Junichi. This one looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-cgroup.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 54f35d1..a31e678 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -333,6 +333,9 @@ struct request_list *__blk_queue_next_rl(struct request_list *rl,
>  	 */
>  	if (rl == &q->root_rl) {
>  		ent = &q->blkg_list;
> +		/* There are no more block groups, hence no request lists */
> +		if (list_empty(ent))
> +			return NULL;
>  	} else {
>  		blkg = container_of(rl, struct blkcg_gq, rl);
>  		ent = &blkg->q_node;
