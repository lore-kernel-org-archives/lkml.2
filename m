Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab0GRG4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 02:56:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42019 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0GRG4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 02:56:14 -0400
Date: Sun, 18 Jul 2010 02:56:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 10/16] writeback: simplify bdi code a little
Message-ID: <20100718065613.GI23811@infradead.org>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
 <1279284312-2411-11-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279284312-2411-11-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks correct, but I would do this slightly different.  Add a new
bdi_writeback_start_thread helper, and then call it from the list
walk as long as there are bdis that need a thread.  Only break
out of the loop once nothing needs to be done and then sleep.

