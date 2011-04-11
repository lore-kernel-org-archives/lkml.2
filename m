Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1DKW6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 18:58:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43036 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab1DKW6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 18:58:15 -0400
Date: Mon, 11 Apr 2011 18:58:12 -0400
From: "hch@infradead.org" <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110411225812.GA32310@infradead.org>
References: <20110308202100.GA31744@redhat.com>
 <4D76912C.9040705@fusionio.com>
 <20110308220526.GA393@redhat.com>
 <20110310005810.GA17911@redhat.com>
 <20110405130541.6c2b5f86@notabene.brown>
 <20110411145022.710c30e9@notabene.brown>
 <4DA2C7BE.6060804@fusionio.com>
 <20110411205928.13915719@notabene.brown>
 <20110411215521.78c87573@notabene.brown>
 <4DA2F02D.2000903@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA2F02D.2000903@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at the patch
(http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=761e433f3de6fb8e369af9e5c08beb86286d023f)

I'm not sure it's an optimal design.  The flush callback really
is a per-queue thing.  Why isn't it a function pointer in the request
queue when doing the blk_run_queue call once we're done with a given
queue before moving on to the next one?
