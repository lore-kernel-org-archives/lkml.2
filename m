Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2AaAvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 19:51:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:34684 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab2AaAvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 19:51:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118293448"
Subject: Re: [patch v2 0/8]block: An IOPS based ioscheduler
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, david@fromorbit.com,
        jack@suse.cz, zhu.yanhai@gmail.com, namhyung.kim@lge.com
In-Reply-To: <20120130153009.GB30245@redhat.com>
References: <20120130070213.793690895@sli10-conroe.sh.intel.com>
	 <20120130153009.GB30245@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Jan 2012 08:50:40 +0800
Message-ID: <1327971040.21268.24.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 10:30 -0500, Vivek Goyal wrote:
> On Mon, Jan 30, 2012 at 03:02:13PM +0800, Shaohua Li wrote:
> > An IOPS based I/O scheduler
> > 
> > Flash based storage has some different characteristics against rotate disk.
> > 1. no I/O seek.
> > 2. read and write I/O cost usually is much different.
> > 3. Time which a request takes depends on request size.
> > 4. High throughput and IOPS, low latency.
> 
> Hi Shaohua,
> 
> Last time we agreed that you will try to extend CFQ iops mode to take care
> of this case. I was wondering that if that idea is out of the window?
I felt there is complexity to do the merge and mess code even with
wrapping some functions as you suggested. Another thing is I want to
avoid complexity of CFQ, for example allocating queue and sharing it
between tasks. cfq_set_request is one source that queue_lock gets
contented, making the code simple can avoid such contention.

> Also what's the real workload where this is going to benefit us. I had
> struggled to run something which drove constantly deep queue depths to
> get the fairness without idling.
To be honest, I don't have real workload. Our test environment runs some
micro benchmarks, which has some problems. I thought we all agreed CFQ
has some limitations. Hoping somebody having real workload can have a
look.

Thanks,
Shaohua

