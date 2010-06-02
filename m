Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab0FBKQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:16:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46811 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab0FBKQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:16:49 -0400
Date: Wed, 2 Jun 2010 06:16:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jaxboe@fusionio.com>,
       Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Douglas Gilbert <dgilbert@interlog.com>, Ingo Molnar <mingo@redhat.com>,
       John Kacur <jkacur@redhat.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: push down BKL into .locked_ioctl
Message-ID: <20100602101621.GA8845@infradead.org>
References: <1275428028-10901-1-git-send-email-arnd@arndb.de> <20100601213755.GA1004@infradead.org> <201006020043.12257.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006020043.12257.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, here comes the first step. Can you be more specific
> about what you mean with the open and release methods? 
> Do you mean the sg.c and bsg.c chrdev file operations?

No, the open and release methods in struct block_device_operations.
After this the driver API for block devices is BKL free, which
is an important step.  To get there the locking in blkdev_get/put
needs to be sorted out first, though.


The ioctl pushdown patch looks good to me, btw.

