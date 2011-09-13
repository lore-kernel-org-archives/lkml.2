Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1IMBAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 21:00:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:30845 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab1IMBAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 21:00:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="47680631"
Subject: Re: [RFC]block: don't mark flush request as SOFTBARRIER
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        Vivek Goyal <vgoyal@redhat.com>
In-Reply-To: <20110911025128.GM29319@htj.dyndns.org>
References: <1315445394.29510.71.camel@sli10-conroe>
	 <20110911025128.GM29319@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 09:04:01 +0800
Message-ID: <1315875841.29510.80.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-11 at 10:51 +0800, Tejun Heo wrote:
> Hello,
> 
> On Thu, Sep 08, 2011 at 09:29:54AM +0800, Shaohua Li wrote:
> > I'm wondering why flush request should be marked as
> > SOFTBARRIER. Current flush sequence guarantees the correctness of
> > flush even the request is reordered by ioscheduler.
> 
> The primary reason would be because when those flush data requests are
> put on the dispatch queue, it doesn't go through elv_dispatch_sort().
> SOFTBARRIERs function as dispatch sort boundaries and queueing flush
> data request at the head w/o SOFTBARRIER would confuse dispatch
> sorting, and we want to put it at the head of dispatch queue to
> decrease latency for flush sequence.
we do the flush first and then dispatch the data. The flush is already
delayed a lot, so if latency is a problem, we already saw it. Why not
just remove SOFTBARRIER and use elv_dispatch_sort() for flush data so
drive can better arrange requests?

Thanks,
Shaohua

