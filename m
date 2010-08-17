Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab0HQN4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:56:46 -0400
Received: from verein.lst.de ([213.95.11.210]:46244 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab0HQN4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:56:45 -0400
Date: Tue, 17 Aug 2010 15:56:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH block#for-2.6.36-post] block: fix incorrect bio/request flag conversion in md
Message-ID: <20100817135638.GA5382@lst.de>
References: <4C694965.6040805@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C694965.6040805@kernel.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 04:21:25PM +0200, Tejun Heo wrote:
> Commit 74450be1 (block: unify flags for struct bio and struct request)
> incorrectly converted @do_sync in md raid1 and raid10 make_requst()
> functions.
> 
> @do_sync is now supposed to carry the actual flag bit and directly
> OR'd into bio->bi_rw but is still a bool and thus carries either 0 or
> 1 instead of the actual flag bit.  This makes REQ_SYNC ignored on
> writes and flips the direction of READ_SYNCs to WRITEs.
> 
> Fix it by making @do_sync unsigned integers.

Yeah, you're the fourth person coming up with this independently.  Now
all we need is to get one of the patches actually into Linus tree.

