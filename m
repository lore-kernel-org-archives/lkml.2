Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab0G3J64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 05:58:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58060 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0G3J6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 05:58:55 -0400
Date: Fri, 30 Jul 2010 05:58:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: move del_gendisk() from fs/partitions/check.c to
 block/genhd.c
Message-ID: <20100730095854.GA26949@infradead.org>
References: <1280482741.1851.3.camel@yio.site>
 <20100730094038.GA9570@infradead.org>
 <AANLkTik-htE1mbJbnGCNwsjVJyWF24nA9dNbsRNMzuia@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik-htE1mbJbnGCNwsjVJyWF24nA9dNbsRNMzuia@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 11:56:56AM +0200, Kay Sievers wrote:
> > Sounds fine for del_gendisk, but read_dev_sector which isn't mentioned
> > here really is for partitioning.
> 
> Right, the next patch moves it to /block/partition.c, because all the
> sysfs and driver core code really should not be below fs/.
> 
> If you want me to re reshuffle that, let me know. I was just annoyed
> again, and after all these years I though it's time to move that stuff
> around. :)

So then please keep read_dev_sector in the file where it is right now,
and just move the whole directory from fs/partitions/ to
block/partitions.  While you're at it fs/bio.c and fs/block_dev.c
really belong into block/, too.  The latter could also need some split
up.

