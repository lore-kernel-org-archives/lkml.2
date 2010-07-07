Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab0GGBuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 21:50:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59618 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab0GGBuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 21:50:02 -0400
Date: Tue, 6 Jul 2010 21:50:00 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/6] block: push down BKL into .open and .release
Message-ID: <20100707015000.GC2950@infradead.org>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
 <1278193640-24223-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278193640-24223-3-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I might be missing something, but this doesn't actually push the
BKL anyway.  It adds duplicate BKL locking inside the ->open and
->release methods without actually removing it in the callers.

That's a pretty pointless thing to do.  If you're not feeling
confident enough about touching block_dev.c I can look into that
part of the pushdown, but this patch on it's own is not actually
useful.

