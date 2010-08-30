Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab0H3TSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 15:18:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab0H3TSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 15:18:44 -0400
Date: Mon, 30 Aug 2010 15:18:30 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA support for
 request-based dm
Message-ID: <20100830191829.GB8458@redhat.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
 <1283162296-13650-5-git-send-email-tj@kernel.org>
 <20100830132836.GB5283@redhat.com>
 <4C7BB932.1070405@kernel.org>
 <4C7BD202.4040700@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7BD202.4040700@kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30 2010 at 11:45am -0400,
Tejun Heo <tj@kernel.org> wrote:

> This patch converts request-based dm to support the new REQ_FLUSH/FUA.
> 
> The original request-based flush implementation depended on
> request_queue blocking other requests while a barrier sequence is in
> progress, which is no longer true for the new REQ_FLUSH/FUA.
> 
> In general, request-based dm doesn't have infrastructure for cloning
> one source request to multiple targets, but the original flush
> implementation had a special mostly independent path which can issue
> flushes to multiple targets and sequence them.  However, the
> capability isn't currently in use and adds a lot of complexity.
> Moreoever, it's unlikely to be useful in its current form as it
> doesn't make sense to be able to send out flushes to multiple targets
> when write requests can't be.
> 
> This patch rips out special flush code path and deals handles
> REQ_FLUSH/FUA requests the same way as other requests.  The only
> special treatment is that REQ_FLUSH requests use the block address 0
> when finding target, which is enough for now.
> 
> * added BUG_ON(!dm_target_is_valid(ti)) in dm_request_fn() as
>   suggested by Mike Snitzer
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Looks good.

Acked-by: Mike Snitzer <snitzer@redhat.com>

Junichi and/or Kiyoshi,
Could you please review this patch and add your Acked-by if it is OK?
(Alasdair will want to see NEC's Ack to accept this patch).

Thanks,
Mike

