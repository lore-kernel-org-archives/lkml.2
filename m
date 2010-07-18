Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab0GRGwE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 02:52:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49244 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab0GRGwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 02:52:01 -0400
Date: Sun, 18 Jul 2010 02:52:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 08/16] writeback: do not lose default bdi wake-ups
Message-ID: <20100718065200.GG23811@infradead.org>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
 <1279284312-2411-9-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279284312-2411-9-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch also removes strange comment about a temporary measure,
> because there is nothing temporary there - many FSes use default
> bdi.

I don't think that's correct.  We're not using default_backing_dev_info
for filesystems anymore for various reasons.  Look at the spread of
private bdi initializations for all the non-block backed filesystems.

The actual __set_current_state change looks good to me, but shouldn't
have been mixed up with this to start with.

