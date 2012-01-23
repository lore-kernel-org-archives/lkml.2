Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2AWUJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:09:35 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44794
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770Ab2AWUJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:09:34 -0500
Date: Mon, 23 Jan 2012 15:09:23 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Asai Thambi SP <asaithambisp@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtip32xx: rename the confusing argument 'barrier', of
 mtip_hw_submit_io()
Message-ID: <20120123200923.GA9801@infradead.org>
References: <CAKgD3HCqS8MkXbve3sT=8vZ4=Mvdtz-JDmy8N5t7moXcjSV1sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgD3HCqS8MkXbve3sT=8vZ4=Mvdtz-JDmy8N5t7moXcjSV1sg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 05:29:40PM -0800, Asai Thambi SP wrote:
> This device does not support write cache, hence renamed confusing argument
> 'barrier' to 'fua'. Setting of FUA bit is done in all IOs for compatibility.

That's not correct, you set it if REQ_FUA is set, which won't ever be
set given how you configure the queue. I.e. it's dead code that can be
removed.
