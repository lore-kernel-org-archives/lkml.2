Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2BAJSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 04:18:17 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58285
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753949Ab2BAJSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 04:18:14 -0500
Date: Wed, 1 Feb 2012 04:18:07 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Jens Axboe <axboe@kernel.dk>,
        Herbert Poetzl <herbert@13thfloor.at>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Wu Fengguang <wfg@linux.intel.com>
Subject: Re: [PATCH] fix readahead pipeline break caused by block plug
Message-ID: <20120201091807.GA7451@infradead.org>
References: <1327996780.21268.42.camel@sli10-conroe>
 <20120131220333.GD4378@redhat.com>
 <20120131141301.ba35ffe0.akpm@linux-foundation.org>
 <20120131222217.GE4378@redhat.com>
 <20120201033653.GA12092@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120201033653.GA12092@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 10:36:53PM -0500, Vivek Goyal wrote:
> I still see that IO is being submitted one page at a time. The only
> real difference seems to be that queue unplug happening at random times
> and many a times we are submitting much smaller requests (40 sectors, 48
> sectors etc).

This is expected given that the block device node uses
block_read_full_page, and not mpage_readpage(s).
