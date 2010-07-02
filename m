Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab0GBKsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 06:48:42 -0400
Received: from verein.lst.de ([213.95.11.210]:59472 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856Ab0GBKsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 06:48:40 -0400
Date: Fri, 2 Jul 2010 12:48:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, axboe@kernel.dk,
       hch@lst.de, James.Bottomley@suse.de, linux-scsi@vger.kernel.org,
       dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: address leak in the error path of discard page allocation
Message-ID: <20100702104824.GB26318@lst.de>
References: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1277981359-10717-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20100701130328.GB19605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701130328.GB19605@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 09:03:28AM -0400, Mike Snitzer wrote:
> On Thu, Jul 01 2010 at  6:49am -0400,
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > This fixes discard page leak by using q->unprep_rq_fn facility.
> > 
> > q->unprep_rq_fn is called when all the data buffer (req->bio and
> > scsi_data_buffer) in the request is freed.
> > 
> > sd_unprep() uses rq->buffer to free discard page allocated in
> > sd_prepare_discard().
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Thanks for sorting this out Tomo, all 3 patches work great!
> 
> BTW, there is one remaining (rare) leak in the allocation path.
> 
> The following patch serves to fix it but I'm not sure if there is a more
> elegant way to address this.
> 
> An alternative would be to check if the page is already allocated
> (before allocating the page in scsi_setup_discard_cmnd)?

Ah, should have read your mail first, sorry..

