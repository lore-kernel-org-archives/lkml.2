Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab0JHJZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:25:37 -0400
Received: from verein.lst.de ([213.95.11.210]:60284 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177Ab0JHJZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:25:34 -0400
Date: Fri, 8 Oct 2010 11:25:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@lst.de>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, xia.wu@intel.com
Subject: Re: [PATCH] bdi: use deferable timer for sync_supers task
Message-ID: <20101008092520.GB5426@lst.de>
References: <20101008083514.GA12402@ywang-moblin2.bj.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008083514.GA12402@ywang-moblin2.bj.intel.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:35:14PM +0800, Yong Wang wrote:
> sync_supers task currently wakes up periodically for superblock
> writeback. This hurts power on battery driven devices. This patch
> turns this housekeeping timer into a deferable timer so that it
> does not fire when system is really idle.

How long can the timer be defereed?  We can't simply stop writing
out data for a long time.  I think the current timer value should be
the upper bound, but allowing to fire earlier to run during the
same wakeup cycle as others is fine.

