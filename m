Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab0FJIUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 04:20:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49153 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab0FJIUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 04:20:01 -0400
Date: Thu, 10 Jun 2010 04:19:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] block: Allow drivers to implement BLKDISCARD and add
 BLKSECDISCARD
Message-ID: <20100610081950.GA15888@infradead.org>
References: <4C081AEC.7010302@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C081AEC.7010302@nokia.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 12:13:16AM +0300, Adrian Hunter wrote:
> SD/MMC cards provide an erase operation that is too inefficient to
> allow file systems to use it, however it is still useful for
> userspace tools because it is still 10 - 100 times faster than
> writing zeroes.  Allow the MMC block driver to provide its own
> BLKDISCARD implementation for this purpose.

That's no good reason.  Almost all current SSD TRIM implementations
have the same issue, that's why filesustems require the -o discard
option to enabled it.  In addition I've not actually seen any numbers
from you on a current kernel.

