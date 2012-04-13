Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab2DMNcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 09:32:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab2DMNcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 09:32:33 -0400
Date: Fri, 13 Apr 2012 09:32:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 1/8] blkcg: kill blkio_list and replace blkio_list_lock
 with a mutex
Message-ID: <20120413133226.GB26383@redhat.com>
References: <1334273380-30233-1-git-send-email-tj@kernel.org>
 <1334273380-30233-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334273380-30233-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 04:29:33PM -0700, Tejun Heo wrote:

Hi Tejun,

> @@ -732,20 +732,21 @@ void blkio_policy_register(struct blkio_policy_type *blkiop)
>  {
>  	struct request_queue *q;
>  
> +	mutex_lock(&blkcg_pol_mutex);
> +
>  	blkcg_bypass_start();
> -	spin_lock(&blkio_list_lock);
>  
>  	BUG_ON(blkio_policy[blkiop->plid]);

A minor nit. It might be a good idea to check that blkiop->plid is not
greater than BLKIO_NR_POLICIES for both registration and unresitration
functions to avoid touching memory beyond blkio_policy[] array.

Thanks
Vivek
