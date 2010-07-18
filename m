Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab0GRGrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 02:47:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48980 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0GRGrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 02:47:21 -0400
Date: Sun, 18 Jul 2010 02:47:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 04/16] writeback: fix possible race when shutting
 down bdi
Message-ID: <20100718064720.GD23811@infradead.org>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
 <1279284312-2411-5-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279284312-2411-5-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 03:45:00PM +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> Current bdi code has the following race between 'bdi_wb_shutdown()'
> and 'bdi_forker_thread()'.
> 
> Initial condition: BDI_pending is cleaned, bdi has no writeback thread,
> because it was inactive and exited, 'bdi_wb_shutdown()' and
> 'bdi_forker_thread()' are executed concurrently.

Wouldn't it be better to have a per-bdi mutex to serialize thread
creation and shutdown?  And please also kill the bit wait in favour
of a proper wait queue - the bit wait interface really is just a hack
for structures that are very size sensitive, which the backing device
is not.

