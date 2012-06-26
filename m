Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab2FZNBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 09:01:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756430Ab2FZNBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 09:01:38 -0400
Date: Tue, 26 Jun 2012 09:01:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Josh Hunt <johunt@akamai.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq: reenable printing of sync/async queue info to
 blktrace cfqq log messages
Message-ID: <20120626130134.GB22557@redhat.com>
References: <1340684923-13167-1-git-send-email-johunt@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340684923-13167-1-git-send-email-johunt@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 09:28:43PM -0700, Josh Hunt wrote:
> Commit afc24d49c1e5dbeef745c1c1246f5ae6ebd97c71 made the printing of the
> sync/async queue info only available when you have CONFIG_CFQ_GROUP_IOSCHED
> enabled. This re-enables it for the case when you do not have that config
> option set.
> 
> Signed-off-by: Josh Hunt <johunt@akamai.com>

Looks good to me. sync/async classification is independent of group
scheduling and printing the queue type in traces helps.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

> ---
>  block/cfq-iosched.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 3c38536..8307b67 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -383,7 +383,9 @@ CFQ_CFQQ_FNS(wait_busy);
>  
>  #else
>  #define cfq_log_cfqq(cfqd, cfqq, fmt, args...)	\
> -	blk_add_trace_msg((cfqd)->queue, "cfq%d " fmt, (cfqq)->pid, ##args)
> +	blk_add_trace_msg((cfqd)->queue, "cfq%d%c " fmt, (cfqq)->pid, \
> +				cfq_cfqq_sync((cfqq)) ? 'S' : 'A', \
> +				##args)
>  #define cfq_log_cfqg(cfqd, cfqg, fmt, args...)		do {} while (0)
>  #endif
>  #define cfq_log(cfqd, fmt, args...)	\
> -- 
> 1.7.0.4
