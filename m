Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab1IZJqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:46:00 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43010
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677Ab1IZJp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:45:59 -0400
Date: Mon, 26 Sep 2011 05:45:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch]mm: add more blk plug
Message-ID: <20110926094554.GA30827@infradead.org>
References: <1317004226.29510.172.camel@sli10-conroe>
 <20110926073025.GB21079@infradead.org>
 <1317022727.29510.175.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317022727.29510.175.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 03:38:47PM +0800, Shaohua Li wrote:
> On Mon, 2011-09-26 at 15:30 +0800, Christoph Hellwig wrote:
> > On Mon, Sep 26, 2011 at 10:30:26AM +0800, Shaohua Li wrote:
> > > Some filesystems implement .writepages. We don't have blk plug
> > > in such filesystems for .writepages.
> > 
> > Please add the plugging in the actual ->writepages instances.
> there are several filesystems have ->writepages. Can you share an hint
> why we don't add plugging in the do_writepages?

Because do_writepages is completely generic code with no knowledge of
block I/O.  I really don't want to have block plugging be intimately
tied into core VM/writeback code all over.  We've been there with
->sync_page, and it was a major pain - nevermind the additional (small)
overhead for the not block based filesystems.

