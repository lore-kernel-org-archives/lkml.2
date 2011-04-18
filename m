Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1DRVXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 17:23:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54166 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab1DRVXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 17:23:09 -0400
Date: Mon, 18 Apr 2011 17:23:06 -0400
From: "hch@infradead.org" <hch@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110418212306.GA21154@infradead.org>
References: <4DA2E03A.2080607@fusionio.com>
 <20110411212635.7959de70@notabene.brown>
 <4DA2E7F0.9010904@fusionio.com>
 <20110411220505.1028816e@notabene.brown>
 <4DA2F00E.6010907@fusionio.com>
 <20110418081922.1651474a@notabene.brown>
 <4DABDC60.2090009@fusionio.com>
 <20110418172551.55629fc6@notabene.brown>
 <4DABF1EA.3070301@fusionio.com>
 <20110418183343.036f412e@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418183343.036f412e@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> NeilBrown (6):
>       md: use new plugging interface for RAID IO.
>       md/dm - remove remains of plug_fn callback.
>       md - remove old plugging code.
>       md: provide generic support for handling unplug callbacks.
>       md: incorporate new plugging into raid5.
>       md: fix up raid1/raid10 unplugging.

Looking over more of the unplugging left over, is there a reason to
keep the unplug_work bits in CFQ?  They seem to rather counter the
current scheme (and it is the last user of kblockd outside of
blk-core.c)

