Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab0HPShg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 14:37:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab0HPShe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 14:37:34 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Subject: Re: [PATCH 1/5] cfq-iosched: Do not idle if slice_idle=0
References: <1281566667-7821-1-git-send-email-vgoyal@redhat.com>
	<1281566667-7821-2-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 16 Aug 2010 14:37:32 -0400
In-Reply-To: <1281566667-7821-2-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Wed, 11 Aug 2010 18:44:23 -0400")
Message-ID: <x49hbiufloz.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> o do not idle either on cfq queue or service tree if slice_idle=0. User does
>   not want any queue or service tree idling. Currently even if slice_idle=0,
>   we were waiting for request to finish before expiring the queue and that
>   can lead to lower queue depths.

Hm, I submitted a similar patch that was supposed to make .35.  Oh well,

Acked-by: Jeff Moyer <jmoyer@redhat.com>

>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/cfq-iosched.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index eb4086f..8830569 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1839,6 +1839,9 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  	BUG_ON(!service_tree);
>  	BUG_ON(!service_tree->count);
>  
> +	if (!cfqd->cfq_slice_idle)
> +		return false;
> +
>  	/* We never do for idle class queues. */
>  	if (prio == IDLE_WORKLOAD)
>  		return false;
> @@ -1879,7 +1882,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
>  	/*
>  	 * idle is disabled, either manually or by past process history
>  	 */
> -	if (!cfqd->cfq_slice_idle || !cfq_should_idle(cfqd, cfqq))
> +	if (!cfq_should_idle(cfqd, cfqq))
>  		return;
>  
>  	/*
