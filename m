Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab0GGX6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 19:58:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44317 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab0GGX6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 19:58:31 -0400
Date: Wed, 7 Jul 2010 19:58:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@infradead.org, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] remove q->prepare_flush_fn hook
Message-ID: <20100707235829.GA6390@infradead.org>
References: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <20100707195209.GA25635@infradead.org>
 <20100708085404K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100708085404K.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 08:54:59AM +0900, FUJITA Tomonori wrote:
> On Wed, 7 Jul 2010 15:52:09 -0400
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > One weird thing after this set is that the flush commands don't have any
> > cmd_type.  I think it should be set to REQ_TYPE_FS, even if we might be
> > resetting it inside the driver for now.
> 
> I think even before this patchset, the block layer doesn't set
> rq->cmd_type on flush requests (scsi and Ode sets it in
> prepare_flush_fn).

Indeed it didn't.  But before that it matters less because
prepare_flush_fn set it before the command entered prep_fn.

