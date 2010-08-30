Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab0H3TIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 15:08:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab0H3TIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 15:08:52 -0400
Date: Mon, 30 Aug 2010 15:08:35 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/5] dm: implement REQ_FLUSH/FUA support for
 request-based dm
Message-ID: <20100830190835.GA8458@redhat.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
 <1283162296-13650-5-git-send-email-tj@kernel.org>
 <20100830132836.GB5283@redhat.com>
 <4C7BB932.1070405@kernel.org>
 <4C7BC942.7070703@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7BC942.7070703@kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30 2010 at 11:07am -0400,
Tejun Heo <tj@kernel.org> wrote:

> On 08/30/2010 03:59 PM, Tejun Heo wrote:
> > Ah... that's probably from "if (!elv_queue_empty(q))" check below,
> > flushes are on a separate queue but I forgot to update
> > elv_queue_empty() to check the flush queue.  elv_queue_empty() can
> > return %true spuriously in which case the queue won't be plugged and
> > restarted later leading to queue hang.  I'll fix elv_queue_empty().
> 
> I think I was too quick to blame elv_queue_empty().  Can you please
> test whether the following patch fixes the hang?

It does, thanks!

Tested-by: Mike Snitzer <snitzer@redhat.com>
