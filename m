Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab0F3WKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 18:10:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753562Ab0F3WKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 18:10:44 -0400
Date: Wed, 30 Jun 2010 15:09:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kyungmin Park <kmpark@infradead.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       linux-mmc Mailing List <linux-mmc@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 4/5] block: Add secure discard
Message-Id: <20100630150947.d53200ac.akpm@linux-foundation.org>
In-Reply-To: <20100624084423.25444.1011.sendpatchset@ahunter-work.research.nokia.com>
References: <20100624084351.25444.30143.sendpatchset@ahunter-work.research.nokia.com>
	<20100624084423.25444.1011.sendpatchset@ahunter-work.research.nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010 11:44:23 +0300
Adrian Hunter <adrian.hunter@nokia.com> wrote:

> >From b25b9a499f255ee5999c219525d82ef40382318c Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@nokia.com>
> Date: Wed, 23 Jun 2010 15:41:38 +0300
> Subject: [PATCH 4/5] block: Add secure discard
> 
> Secure discard is the same as discard except that all copies
> of the discarded sectors (perhaps created by garbage collection)
> must also be erased.

That's not an awfully informative changelog.

>From a quick peek at the code it seems that you took your earlier
design sketch:

On Mon, Jun 14, 2010 at 02:10:06PM +0300, Adrian Hunter wrote:
> Needs a bio flag, a request flag, setup the request flag based on the
> bio flag, prevent merging secure and non-secure discards, prevent drivers
> doing non-secure discards for secure discards.
> 
> Seems like a lot of little changes for something that no one wants.
> Shouldn't it wait for someone to need it first?

and changed your mind and implemented it.

Is that a correct interpretation?
