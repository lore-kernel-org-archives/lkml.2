Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab0CYBJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 21:09:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab0CYBJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 21:09:01 -0400
Date: Wed, 24 Mar 2010 21:08:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, nauman@google.com
Subject: Re: [PATCH] cfq-iosched: Do not merge queues of BE and IDLE classes
Message-ID: <20100325010838.GC13225@redhat.com>
References: <20100324205127.7477.97997.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324205127.7477.97997.stgit@austin.mtv.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 01:52:03PM -0700, Divyesh Shah wrote:
> even if they are found to be co-operating.
> 
> The prio_trees do not have any IDLE cfqqs on them. cfq_close_cooperator()
> is called from cfq_select_queue() and cfq_completed_request(). The latter
> ensures that the close cooperator code does not get invoked if the current
> cfqq is of class IDLE but the former doesn't seem to have any such checks.
> So an IDLE cfqq may get merged with a BE cfqq from the same group which
> should be avoided.
> 
> Signed-off-by: Divyesh Shah<dpshah@google.com>
> ---

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> 
>  block/cfq-iosched.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index dee9d93..e6910dc 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1721,6 +1721,8 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
>  {
>  	struct cfq_queue *cfqq;
>  
> +	if (cfq_class_idle(cur_cfqq))
> +		return NULL;
>  	if (!cfq_cfqq_sync(cur_cfqq))
>  		return NULL;
>  	if (CFQQ_SEEKY(cur_cfqq))
