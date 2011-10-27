Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab1J0PjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 11:39:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab1J0PjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 11:39:05 -0400
Date: Thu, 27 Oct 2011 11:39:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/13] block, cfq: misc updates to cfq_io_context
Message-ID: <20111027153901.GG7491@redhat.com>
References: <1319593719-19132-1-git-send-email-tj@kernel.org>
 <1319593719-19132-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319593719-19132-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 06:48:32PM -0700, Tejun Heo wrote:
> Make the following changes to prepare for ioc/cic management cleanup.
> 
> * Add cic->q so that ioc can determine the associated queue without
>   querying cfq.  This will eventually replace ->key.

Not sure what's the advantage of storing cic->q instead of cic->cfqd.
In blk-ioc code getting to cic's queue becomes easier but then reaching
to cfqd in cfq code becomes much longer.

static inline struct cfq_data *cic_to_cfqd(struct cfq_io_context *cic)
{
        return cic->q->elevator->elevator_data;
}

May be storing cic->cfqd is not a bad idea.

For blk-ioc.

cic_queue = cic->cfqd->queue;

And for CFQ

cic_cfqd = cic->cfqd;

None of the paths is too long for either code. It is a very minor point
though.

Thanks
Vivek
