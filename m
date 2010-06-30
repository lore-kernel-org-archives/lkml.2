Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab0F3WWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 18:22:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752754Ab0F3WWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 18:22:36 -0400
Date: Wed, 30 Jun 2010 15:21:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kyungmin Park <kmpark@infradead.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       linux-mmc Mailing List <linux-mmc@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V3 1/5] mmc: Add erase, secure erase, trim and secure
 trim operations
Message-Id: <20100630152144.3822fe6b.akpm@linux-foundation.org>
In-Reply-To: <20100624084400.25444.57158.sendpatchset@ahunter-work.research.nokia.com>
References: <20100624084351.25444.30143.sendpatchset@ahunter-work.research.nokia.com>
	<20100624084400.25444.57158.sendpatchset@ahunter-work.research.nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010 11:44:00 +0300
Adrian Hunter <adrian.hunter@nokia.com> wrote:

> SD/MMC cards tend to support an erase operation.  In addition,
> eMMC v4.4 cards can support secure erase, trim and secure trim
> operations that are all variants of the basic erase command.

The patch proposes a new userspace interface via sysfs, yes?

Please fully describe that interface and its operation in the
changelog.  It'd also be nice to add permanent documentation for it.

>From reading the code, it appears that erase_size and
preferred_erase_size have units in bytes.  But users shouldn't need to
read the code to find that out.  What are the alignemnt and size
requirements on these?  What is their position in /sys?  What do they
actually *do* and what is the difference between them?

etetera.  People want to review this code and other people actually
want to use it.  I'm not sure that I want to try to review this code
when nobody's told me what interface it implements and how it's
supposed to work.  Seems that whoever implemented BLKDISCARD didn't
want anyone to use it either.  Sigh.


All of mmc core appears to use 32-bit quantities to represent sectors,
yes?  Why didn't it use sector_t?  What are the implications of this?

