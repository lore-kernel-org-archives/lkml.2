Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab1IMVTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 17:19:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52861
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932708Ab1IMVTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 17:19:20 -0400
Date: Tue, 13 Sep 2011 17:19:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        bharrosh@panasas.com, nab@linux-iscsi.org, ryanh@us.ibm.com
Subject: Re: [PATCH 1/2] block: export __make_request
Message-ID: <20110913211911.GA13894@infradead.org>
References: <20110911145053.GA28996@infradead.org>
 <4E6DD7F0.8020903@kernel.dk>
 <20110912122507.GA12229@infradead.org>
 <4E6DFA8C.3030400@kernel.dk>
 <20110912133826.GA22548@infradead.org>
 <4E6E49BE.6020005@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6E49BE.6020005@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 08:04:46PM +0200, Jens Axboe wrote:
> > I really hate naming things different from the method they are
> > implementing.  I've tried to figure out what the point of the
> > old blk_make_request is - why would we not go through
> > generic_make_request for this?
> > 
> > Boaz, any idea?
> 
> I tend to agree, we could rename the existing blk_make_request(). It
> could be blk_make_request_from_bio() or something like that, since
> that's what it does.

It should at very least be renamed.  But I still can't figure out what
it is for exactly.

There are three users:

 (1) virtio_blk::virtblk_get_id():
	This looks like it really should just use blk_rq_map_kern.
 (2) osd_initiator::_make_request():
	This one looks like it should just use the same scheme as
	sg_io(), as it's doing the same thing.
 (3) target_core_pscsi::__pscsi_map_SG():
	Same as (2).


