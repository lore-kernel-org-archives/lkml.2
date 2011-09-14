Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab1INGAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 02:00:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:5024 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab1INGAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 02:00:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,378,1312182000"; 
   d="scan'208";a="52891220"
Subject: Re: [RFC]block: don't mark flush request as SOFTBARRIER
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        Vivek Goyal <vgoyal@redhat.com>
In-Reply-To: <20110913074653.GC11397@mtj.dyndns.org>
References: <1315445394.29510.71.camel@sli10-conroe>
	 <20110911025128.GM29319@htj.dyndns.org>
	 <1315875841.29510.80.camel@sli10-conroe>
	 <20110913074653.GC11397@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 14:04:23 +0800
Message-ID: <1315980263.29510.114.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 15:46 +0800, Tejun Heo wrote:
> Hello, Shaohua.
> 
> On Tue, Sep 13, 2011 at 09:04:01AM +0800, Shaohua Li wrote:
> > we do the flush first and then dispatch the data. The flush is
> > already delayed a lot, so if latency is a problem, we already saw
> > it.
> 
> I don't necessarily agree with the above.  We don't induce any extra
> latency for flushes which don't overlap.
> 
> > Why not just remove SOFTBARRIER and use elv_dispatch_sort() for
> > flush data so drive can better arrange requests?
> 
> Maybe, I don't know.  Elevator sorting on writes is likely to be much
> less important to begin with.  Combined with the fact that sorting
> flush data would require more writes to be flushed by the following
> flush, I don't think it would be clear which way would be better.  If
> it can be shown that sorting flush data is better, why not?
Just found request_queue->queue_head list usually has only one entry,
because drive only takes one extra request from elevator. so either
dispatch_sort() or dispatch_add_tail() has no difference.

Thanks,
Shaohua

