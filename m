Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab0JHKMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:12:52 -0400
Received: from smtp.nokia.com ([192.100.105.134]:29800 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab0JHKMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:12:51 -0400
Subject: RE: [PATCH] bdi: use deferable timer for sync_supers task
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: "ext Wu, Xia" <xia.wu@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Yong Wang <yong.y.wang@linux.intel.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <A24AE1FFE7AEC5489F83450EE98351BF227AB58D43@shsmsx502.ccr.corp.intel.com>
References: <20101008083514.GA12402@ywang-moblin2.bj.intel.com>
	 <20101008092520.GB5426@lst.de>
	 <A24AE1FFE7AEC5489F83450EE98351BF227AB58D43@shsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Fri, 08 Oct 2010 13:09:46 +0300
Message-ID: <1286532586.2095.55.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Oct 2010 10:12:39.0595 (UTC) FILETIME=[56850FB0:01CB66D1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 12:04 +0200, ext Wu, Xia wrote:
> On Fri, Oct 08, 2010 at 04:35:14PM +0800, Yong Wang wrote:
> > > sync_supers task currently wakes up periodically for superblock
> > > writeback. This hurts power on battery driven devices. This patch
> > > turns this housekeeping timer into a deferable timer so that it
> > > does not fire when system is really idle.
> 
> > How long can the timer be defereed?  We can't simply stop writing
> > out data for a long time.  I think the current timer value should be
> > the upper bound, but allowing to fire earlier to run during the
> > same wakeup cycle as others is fine.
> 
> If the system is in sleep state, this timer can be deferred to the next wake-up interrupt.
> If the system is busy, this timer will fire at the scheduled time.

However, when the next wake-up interrupt happens is not defined. It can
happen 1ms after, or 1 minute after, or 1 hour after. What Christoph
says is that there should be some guarantee that sb writeout starts,
say, within 5 to 10 seconds interval. Deferrable timers do not guarantee
this. But take a look at the range hrtimers - they do exactly this.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

