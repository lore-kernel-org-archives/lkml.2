Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab0JHKFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:05:40 -0400
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:18918 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810Ab0JHKFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:05:39 -0400
Subject: Re: [PATCH] bdi: use deferable timer for sync_supers task
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: ext Christoph Hellwig <hch@lst.de>
Cc: Yong Wang <yong.y.wang@linux.intel.com>, Jens Axboe <jaxboe@fusionio.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "xia.wu@intel.com" <xia.wu@intel.com>
In-Reply-To: <20101008092520.GB5426@lst.de>
References: <20101008083514.GA12402@ywang-moblin2.bj.intel.com>
	 <20101008092520.GB5426@lst.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Fri, 08 Oct 2010 13:02:35 +0300
Message-ID: <1286532155.2095.52.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 11:25 +0200, ext Christoph Hellwig wrote:
> On Fri, Oct 08, 2010 at 04:35:14PM +0800, Yong Wang wrote:
> > sync_supers task currently wakes up periodically for superblock
> > writeback. This hurts power on battery driven devices. This patch
> > turns this housekeeping timer into a deferable timer so that it
> > does not fire when system is really idle.
> 
> How long can the timer be defereed?  We can't simply stop writing
> out data for a long time.  I think the current timer value should be
> the upper bound, but allowing to fire earlier to run during the
> same wakeup cycle as others is fine.

Infinitely.

There are range hrtimers which can do exactly what you said - you
specify the hard and soft limits there.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

