Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab2AaL5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 06:57:21 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53853
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758Ab2AaL5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 06:57:20 -0500
Date: Tue, 31 Jan 2012 06:57:16 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <wfg@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Herbert Poetzl <herbert@13thfloor.at>,
        Eric Dumazet <eric.dumazet@gmail.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] fix readahead pipeline break caused by block plug
Message-ID: <20120131115716.GA19829@infradead.org>
References: <1327996780.21268.42.camel@sli10-conroe>
 <20120131103416.GA1661@localhost>
 <20120131104621.GA27003@infradead.org>
 <20120131105754.GA3867@localhost>
 <20120131113452.GA3235@infradead.org>
 <20120131114256.GA8796@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131114256.GA8796@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 07:42:56PM +0800, Wu Fengguang wrote:
> > So what?  Better do a bit more work now and keep the damn thing
> > maintainable.
> 
> What if we add a wrapper function for doing
> 
>         blk_start_plug(&plug);
>         ->direct_IO()
>         blk_finish_plug(&plug);

No.  Just put it into __blockdev_direct_IO - a quick 2 minute audit of
the kernel source shows that is in fact the only ->direct_IO instance
which ever submits block I/O anyway.

