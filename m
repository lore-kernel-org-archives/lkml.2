Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965350Ab2EOPcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:32:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:37750 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965126Ab2EOPcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:32:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100343911"
Subject: Re: [RFC PATCH 1/3] block: add a flag to identify PM request
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1205151028020.1796-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1205151028020.1796-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 15 May 2012 23:33:05 +0800
Message-ID: <1337095985.3515.1.camel@chief-river-32>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 10:35 -0400, Alan Stern wrote:
> On Tue, 15 May 2012, Lin Ming wrote:
> 
> > Add a flag REQ_PM to identify the request is PM related.
> > As an example, modify scsi code to use this flag.
> 
> There already is such a flag; you don't need to add one.  In fact, 
> there already are _two_ such flags, and it would be best to remove one 
> of them.  In include/linux/blkdev.h:
> 
> 	REQ_TYPE_PM_SUSPEND,		/* suspend request */
> 	REQ_TYPE_PM_RESUME,		/* resume request */
> 
> Apparently they had been used by the old ide driver, but they don't
> seem to be used anywhere now.

IDE code still uses both types and they are used for system
suspend/resume. See generic_ide_suspend and generic_ide_resume.

But we need a flag to check whether it is runtime suspend/resume
request.

> 
> Aside from that, this patch seems to be going in the right direction.
> 
> Alan Stern
> 


