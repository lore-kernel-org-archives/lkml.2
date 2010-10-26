Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846Ab0JZLNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 07:13:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756503Ab0JZLNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 07:13:42 -0400
Date: Tue, 26 Oct 2010 13:06:44 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/14] drivers/vhost/vhost.c: delete double assignment
Message-ID: <20101026110644.GA7922@redhat.com>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
 <1288088743-3725-4-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288088743-3725-4-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 12:25:32PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Delete successive assignments to the same location.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression i;
> @@
> 
> *i = ...;
>  i = ...;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Thanks, applied.

> ---
>  drivers/vhost/vhost.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 94701ff..ed27727 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -157,7 +157,6 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>  	vq->avail_idx = 0;
>  	vq->last_used_idx = 0;
>  	vq->used_flags = 0;
> -	vq->used_flags = 0;
>  	vq->log_used = false;
>  	vq->log_addr = -1ull;
>  	vq->vhost_hlen = 0;
