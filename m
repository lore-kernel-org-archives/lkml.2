Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab1AYV1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 16:27:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab1AYV1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:27:03 -0500
Date: Tue, 25 Jan 2011 16:26:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: Fix update_vdisktime logic
Message-ID: <20110125212656.GF10664@redhat.com>
References: <4D3E4317.80406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3E4317.80406@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 11:27:19AM +0800, Gui Jianfeng wrote:
> The update_vdisktime logic is broken since commit b54ce60eb7f61f8e314b8b241b0469eda3bb1d42,
> st->min_vdisktime never makes a progress. Fix it.
> 
> Thanks Vivek for pointing it out.
> 
> Signed-off-by: Gui Jianfeng <guijianfen@cn.fujitsu.com>

Thanks Gui. Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

> ---
>  block/cfq-iosched.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index f083bda..8c28f56 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -558,15 +558,13 @@ static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
>  
>  static void update_min_vdisktime(struct cfq_rb_root *st)
>  {
> -	u64 vdisktime = st->min_vdisktime;
>  	struct cfq_group *cfqg;
>  
>  	if (st->left) {
>  		cfqg = rb_entry_cfqg(st->left);
> -		vdisktime = min_vdisktime(vdisktime, cfqg->vdisktime);
> +		st->min_vdisktime = max_vdisktime(st->min_vdisktime,
> +						  cfqg->vdisktime);
>  	}
> -
> -	st->min_vdisktime = max_vdisktime(st->min_vdisktime, vdisktime);
>  }
>  
>  /*
> -- 
> 1.7.1
