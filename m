Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab0FNIK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 04:10:27 -0400
Received: from verein.lst.de ([213.95.11.210]:51311 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab0FNIKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 04:10:24 -0400
Date: Mon, 14 Jun 2010 10:09:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: jens.axboe@oracle.com, hch@lst.de,
       Andrew Morton <akpm@linux-foundation.org>,
       Kyungmin Park <kmpark@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>
Subject: Re: [PATCH V2 0/4] Add MMC erase and secure erase
Message-ID: <20100614080921.GA28316@lst.de>
References: <4C14AC7E.6030308@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C14AC7E.6030308@nokia.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 01:01:34PM +0300, Adrian Hunter wrote:
> Hi
> 
> Add ability to do MMC erase and secure erase operations from userspace,
> using the BLKDISCARD ioctl and a newly created BLKSECDISCARD ioctl.

Have you done any measurement if the use of the block layer changes
performance of the discard requests for you?  I'd really prefer to
send down the secure erase that way, too.  This could easily be done
by having a DISCARD_SECURE rw flag, which just ORs another flag into
the request type field.

