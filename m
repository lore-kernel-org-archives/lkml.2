Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab1DRJUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 05:20:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44617 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1DRJUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 05:20:04 -0400
Date: Mon, 18 Apr 2011 05:19:59 -0400
From: "hch@infradead.org" <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110418091959.GA32013@infradead.org>
References: <20110411205928.13915719@notabene.brown>
 <4DA2E03A.2080607@fusionio.com>
 <20110411212635.7959de70@notabene.brown>
 <4DA2E7F0.9010904@fusionio.com>
 <20110411220505.1028816e@notabene.brown>
 <4DA2F00E.6010907@fusionio.com>
 <20110418081922.1651474a@notabene.brown>
 <4DABDC60.2090009@fusionio.com>
 <20110418172551.55629fc6@notabene.brown>
 <4DABF1EA.3070301@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DABF1EA.3070301@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, I really start to wonder if the request level is the right place
to do this on-stack plugging.  Wouldn't it be better to just plug
bios in the on-stack queue?  That way we could also stop doing the
special case merging when adding to the plug list, and leave all the
merging / I/O schedule logic in the __make_request path.  Probably
not .39 material, but worth a prototype?

Also what this dicussion brought up is that the block layer data
structures are highly confusing.  Using a small subset of the
request_queue also for make_request based driver just doesn't make
sense.  It seems like we should try to migrate the required state
to struct gendisk, and submit I/O through a block_device_ops.submit
method, leaving the request_queue as an internal abstraction for
the request based drivers.

