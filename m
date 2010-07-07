Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0GGOEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 10:04:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61405 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab0GGOEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 10:04:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] block: push down BKL into .open and .release
Date: Wed, 7 Jul 2010 16:04:03 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
References: <1278193640-24223-1-git-send-email-arnd@arndb.de> <1278193640-24223-3-git-send-email-arnd@arndb.de> <20100707015000.GC2950@infradead.org>
In-Reply-To: <20100707015000.GC2950@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007071604.04086.arnd@arndb.de>
X-Provags-ID: V02:K0:2sjlLDJdFB+NmPNcsDi1Wj4/imfEY6Pbor4tqR9CcYJ
 go6p/5MXdkyik0+lrIkLJCVVTvy/7V7ARAmdQ/nl9+VNnv35E8
 0DcXnG+xcol4kS/cyP/8WgRkqtTBuNAxTEJSgb3PVsvPTZMTSZ
 Uas6b5Wp9fKC8uzndwwgz0gjvqH5fdH0hMxv0pKBCapjtj3lak
 AAIa9HqPk8keo/bX08w8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 July 2010, Christoph Hellwig wrote:
> I might be missing something, but this doesn't actually push the
> BKL anyway.  It adds duplicate BKL locking inside the ->open and
> ->release methods without actually removing it in the callers.
> 
> That's a pretty pointless thing to do.  If you're not feeling
> confident enough about touching block_dev.c I can look into that
> part of the pushdown, but this patch on it's own is not actually
> useful.

My idea was that the patch in its current form would be less
controversial if it can't break anything, but you're certainly
right that the description doesn't match what the patch does.

I'm now integrating the half of patch 5, as you suggested.
I would much appreciate if you could verify my assumptions
about the blkdev_get/blkdev_put functions in the combined patch.

	Arnd
