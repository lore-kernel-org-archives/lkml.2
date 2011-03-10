Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab1CJQzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:55:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab1CJQzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:55:03 -0500
Date: Thu, 10 Mar 2011 11:54:52 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, hch@infradead.org,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 04/10] block: initial patch for on-stack per-task plugging
Message-ID: <20110310165452.GE29464@redhat.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-5-git-send-email-jaxboe@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295659049-2688-5-git-send-email-jaxboe@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 01:17:23AM +0000, Jens Axboe wrote:

[..]
> -/*
> - * Only disabling plugging for non-rotational devices if it does tagging
> - * as well, otherwise we do need the proper merging
> - */
> -static inline bool queue_should_plug(struct request_queue *q)
> -{
> -	return !(blk_queue_nonrot(q) && blk_queue_tagged(q));
> -}
> -

Jens,

While discussing stack plug with Mike Snitzer, this occurred to us that in
new code we seem to be plugging even if underlying device is SSD with NCQ.
Should we continue to maintain the old behavior of not plugging for NCQ SSD?

Thanks
Vivek
