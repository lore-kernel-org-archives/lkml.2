Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab2BHSHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 13:07:24 -0500
Received: from plane.gmane.org ([80.91.229.3]:40577 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab2BHSHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 13:07:23 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: Re: [patch]block: fix ioc locking warning
Date: Wed, 08 Feb 2012 10:07:05 -0800
Message-ID: <jgudka$pbj$1@dough.gmane.org>
References: <1328514611.21268.66.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-183-100.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0) Gecko/20120129 Thunderbird/10.0
In-Reply-To: <1328514611.21268.66.camel@sli10-conroe>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2012 11:50 PM, Shaohua Li wrote:

> diff --git a/block/blk-ioc.c b/block/blk-ioc.c
> index 27a06e0..7490b6d 100644
> --- a/block/blk-ioc.c
> +++ b/block/blk-ioc.c
> @@ -204,7 +204,9 @@ void put_io_context(struct io_context *ioc, struct request_queue *locked_q)
>   				spin_unlock(last_q->queue_lock);
>   			last_q = NULL;
>
> -			if (!spin_trylock(this_q->queue_lock))
> +			/* spin_trylock() always successes in UP case */
> +			if (this_q != locked_q&&
> +			    !spin_trylock(this_q->queue_lock))
>   				break;
>   			last_q = this_q;
>   			continue;

I can see from the rest of this thread that your patch fixes a multitude
of different backtraces, including (most importantly :) mine, thanks:

http://marc.info/?l=linux-kernel&m=132804761925018&w=2



