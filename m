Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab2AOMoK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 07:44:10 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57915
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764Ab2AOMoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 07:44:09 -0500
Date: Sun, 15 Jan 2012 07:44:05 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Subject: Re: [GIT PULL] Block drivers for 3.3-rc
Message-ID: <20120115124405.GA7389@infradead.org>
References: <4F12A1CC.50105@kernel.dk>
 <20120115103331.GA31956@infradead.org>
 <4F12C4ED.6060301@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F12C4ED.6060301@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 01:22:05PM +0100, Jens Axboe wrote:
> Good point, I had forgotten about the ordered writes, I believe the rest
> of the items have been handled. The driver/hw, as it stands, does not
> reorder writes and it doesn't have a write back cache. So it should
> actually be safe. Any acked write is stable. Sam, correct me if I'm
> wrong.

I tried to get that out of the micron folks a while ago but don't
remember getting an answer.  If that's actually tree please remove
the (misnamed) barrier argument from mtip_hw_submit_io, and maybe add
a comment that the current hardware can't have a volatile write cache.

Btw, does the hardware claim to have writeback caches in the ATA
IDENTIFY words related to it?
