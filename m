Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab1JYNgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:36:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933399Ab1JYNga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:36:30 -0400
Date: Tue, 25 Oct 2011 09:36:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: jaxboe@fusionio.com, Jens Axboe <axboe@kernel.dk>
Cc: tj@kernel.org, linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] blk-throttle: Free up policy node associated with
 deleted rule
Message-ID: <20111025133625.GA23292@redhat.com>
References: <1319144906-5066-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319144906-5066-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 05:08:25PM -0400, Vivek Goyal wrote:
> If a rule is being deleted, free up associated policy node. Otherwise
> that memory is leaked.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Hi Jens,

Do you see any issues with the two patches. Can you please consider these
for merging.

Thanks
Vivek

> ---
>  block/blk-cgroup.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index b596e54..4ddf11f 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -1085,6 +1085,7 @@ static int blkiocg_file_write(struct cgroup *cgrp, struct cftype *cft,
>  
>  	if (blkio_delete_rule_command(newpn)) {
>  		blkio_policy_delete_node(pn);
> +		kfree(pn);
>  		spin_unlock_irq(&blkcg->lock);
>  		goto update_io_group;
>  	}
> -- 
> 1.7.4.4
