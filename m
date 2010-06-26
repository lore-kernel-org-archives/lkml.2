Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab0FZJ2Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 05:28:16 -0400
Received: from verein.lst.de ([213.95.11.210]:46420 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab0FZJ2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 05:28:14 -0400
Date: Sat, 26 Jun 2010 11:27:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Vivek Goyal <vgoyal@redhat.com>,
       Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100626092759.GA25896@lst.de>
References: <20100621094828.GA30748@lst.de> <4C1F3916.4070608@kernel.dk> <20100621110436.GA4056@lst.de> <4C1FB5F7.3070908@kernel.dk> <20100621191410.GA24213@lst.de> <20100621213618.GC6474@redhat.com> <20100623100138.GA9575@lst.de> <20100624014420.GB3297@redhat.com> <20100625110319.GA12855@lst.de> <20100626092556.GH29809@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100626092556.GH29809@laptop>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 07:25:56PM +1000, Nick Piggin wrote:
> Biggest thing is multiple small files operations like on the same
> directory. Best case I measured back when doing AS io scheduler
> versus deadline was about 100x improvement on a uncached kernel
> grep workload when competing with a streaming writeout (the writeout
> probably ended up going somewhat slower naturally, but it is fairer).

As I mentioned below I absolutely see the case for reads.  A normal
grep basically is a dependent read kind of workload.  For for writes
it should either be O_SYNC-style workloads or batched I/O. 
