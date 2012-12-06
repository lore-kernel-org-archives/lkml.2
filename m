Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab2LFXca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 18:32:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2LFXc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 18:32:29 -0500
Date: Thu, 6 Dec 2012 15:32:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, patches@linaro.org
Subject: Re: [PATCH] block: Fix sparse warning
Message-Id: <20121206153227.91a6ec69.akpm@linux-foundation.org>
In-Reply-To: <1353322840-2881-1-git-send-email-tushar.behera@linaro.org>
References: <1353322840-2881-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2012 16:30:40 +0530
Tushar Behera <tushar.behera@linaro.org> wrote:

> blk_drain_queue is only used in this file, so should be marked static.
> 
> Fixes following sparse warning.
> 
> block/blk-core.c:361:6: warning: symbol 'blk_drain_queue' was not
> declared. Should it be static?
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  block/blk-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index a8b1527..5db63eb 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -358,7 +358,7 @@ EXPORT_SYMBOL(blk_put_queue);
>   * If not, only ELVPRIV requests are drained.  The caller is responsible
>   * for ensuring that no new requests which need to be drained are queued.
>   */
> -void blk_drain_queue(struct request_queue *q, bool drain_all)
> +static void blk_drain_queue(struct request_queue *q, bool drain_all)
>  {
>  	int i;

nit: the objective of this patch is not to reduce the sparse output; it
is to improve the kernel by giving an unnecessarily-global symbol
static scope.

So a better title is one which describes the code fix.  The fact that
sparse happened to detect it is less important.  I chose
"block/blk-core.c: make blk_drain_queue() static".
