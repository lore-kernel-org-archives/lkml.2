Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab0FVWMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 18:12:44 -0400
Received: from hera.cwi.nl ([192.16.191.8]:60540 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab0FVWMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 18:12:31 -0400
X-Greylist: delayed 1829 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jun 2010 18:12:31 EDT
Date: Tue, 22 Jun 2010 23:48:13 +0200
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Andries Brouwer <Andries.Brouwer@cwi.nl>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Ulf Hansson <ulf.hansson@stericsson.com>
Subject: Re: [PATCH] Add commandline partitions for block devices v2
Message-ID: <20100622214812.GB1797@ub>
References: <1275997141-25419-1-git-send-email-linus.walleij@stericsson.com>
 <20100622130915.16ad67cd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100622130915.16ad67cd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 Andrew Morton wrote:
> On Tue, 8 Jun 2010 Linus Walleij wrote:
> 
> > From: Ulf Hansson <ulf.hansson@stericsson.com>
> > 
> > This adds an option to pass in block device partitions from the kernel
> > cmdline.
> > 
> > The rationale is that in embedded systems we sometimes have no standard
> > partition table available: often due to the fact that raw binary data is
> > read out from the first sectors of the device by ROM code in ASICs. We
> > have for a long time supplied custom partition information to embedded
> > flash memories through the MTDparts interface which has similar
> > semantics, and with the advent of embedded MMC block devices this now
> > comes to standard block devices.

There exist ioctls BLKPG_ADD_PARTITION and BLKPG_DEL_PARTITION that
allow one to add or remove partitions at run time, without having
a partition table, or without having a partition table in a format
understood by the kernel. Things can be done in user space.

In general there are many things one would like the kernel to do at
init time, and it is a bad idea to do all of this from the kernel
command line. So adding options like these should be done only
if it would be really awkward to do the same from an initial
ramdisk.

Andries

