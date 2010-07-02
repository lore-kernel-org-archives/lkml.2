Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab0GBH4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:56:51 -0400
Received: from sh.osrg.net ([192.16.179.4]:39633 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab0GBH4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:56:50 -0400
Date: Fri, 2 Jul 2010 16:56:29 +0900
To: axboe@kernel.dk
Cc: hch@infradead.org, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de,
       hch@lst.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] use q->prep_rq_fn for flush requests instead of 
 q->prepare_flush_fn()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C2D9AFF.7010401@kernel.dk>
References: <1278056005-25438-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20100702075248.GB21266@infradead.org>
	<4C2D9AFF.7010401@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100702165617B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 02 Jul 2010 16:56:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Jul 2010 09:53:35 +0200
Jens Axboe <axboe@kernel.dk> wrote:

> On 2010-07-02 09:52, Christoph Hellwig wrote:
> > On Fri, Jul 02, 2010 at 04:33:23PM +0900, FUJITA Tomonori wrote:
> >> We could kill q->prepare_flush_fn(). Except for ide, all the users
> >> just mark flush requests. They can use REQ_FLUSH flag instead. Ide can
> >> do like SCSI.
> > 
> > Yes, and I think you should go all the way to kill it instead of
> > keeping both APIs around.  Otherwise the patchset looks good to me.
> 
> Fully agree, lets get rid of ->prepare_flush_fn().

Ok, I'll send patches to clean up all the users of prepare_flush_fn()
soon.
