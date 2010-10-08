Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab0JHKGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:06:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:44618 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756990Ab0JHKGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:06:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,302,1283756400"; 
   d="scan'208";a="614635332"
From: "Wu, Xia" <xia.wu@intel.com>
To: Christoph Hellwig <hch@lst.de>, Yong Wang <yong.y.wang@linux.intel.com>
CC: Jens Axboe <jaxboe@fusionio.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Fri, 8 Oct 2010 18:04:44 +0800
Subject: RE: [PATCH] bdi: use deferable timer for sync_supers task
Thread-Topic: [PATCH] bdi: use deferable timer for sync_supers task
Thread-Index: ActmytHoEYGgq7d/Qx+YxEVW0Xs1NAAA1ojg
Message-ID: <A24AE1FFE7AEC5489F83450EE98351BF227AB58D43@shsmsx502.ccr.corp.intel.com>
References: <20101008083514.GA12402@ywang-moblin2.bj.intel.com>
 <20101008092520.GB5426@lst.de>
In-Reply-To: <20101008092520.GB5426@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, Oct 08, 2010 at 04:35:14PM +0800, Yong Wang wrote:
> > sync_supers task currently wakes up periodically for superblock
> > writeback. This hurts power on battery driven devices. This patch
> > turns this housekeeping timer into a deferable timer so that it
> > does not fire when system is really idle.

> How long can the timer be defereed?  We can't simply stop writing
> out data for a long time.  I think the current timer value should be
> the upper bound, but allowing to fire earlier to run during the
> same wakeup cycle as others is fine.

If the system is in sleep state, this timer can be deferred to the next wake-up interrupt.
If the system is busy, this timer will fire at the scheduled time.


