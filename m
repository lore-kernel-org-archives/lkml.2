Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab1DOE0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 00:26:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42280 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1DOE0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 00:26:13 -0400
Date: Fri, 15 Apr 2011 00:26:11 -0400
From: "hch@infradead.org" <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110415042611.GA3116@infradead.org>
References: <20110310005810.GA17911@redhat.com>
 <20110405130541.6c2b5f86@notabene.brown>
 <20110411145022.710c30e9@notabene.brown>
 <4DA2C7BE.6060804@fusionio.com>
 <20110411205928.13915719@notabene.brown>
 <4DA2E03A.2080607@fusionio.com>
 <20110411212635.7959de70@notabene.brown>
 <4DA2E7F0.9010904@fusionio.com>
 <20110411220505.1028816e@notabene.brown>
 <4DA2F00E.6010907@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA2F00E.6010907@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, "block: move queue run on unplug to kblockd" currently moves
the __blk_run_queue call to kblockd unconditionally currently.  But
I'm not sure that's correct - if we do an explicit blk_finish_plug
there's no point in forcing the context switch.
