Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965401Ab2EOPga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:36:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:3815 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965242Ab2EOPg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:36:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166616313"
Subject: Re: [RFC PATCH 2/3] block: add queue runtime pm callback
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.1205151036510.1796-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1205151036510.1796-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 15 May 2012 23:36:28 +0800
Message-ID: <1337096188.3515.3.camel@chief-river-32>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 10:37 -0400, Alan Stern wrote:
> On Tue, 15 May 2012, Lin Ming wrote:
> 
> > Add ->runtime_pm callback and ->pm_status to request queue.
> > As an example, implement a simple queue runtime_pm callback
> > in sd driver.
> 
> > +static int sd_runtime_pm_fn(struct request_queue *q, pm_message_t mesg)
> > +{
> > +	struct scsi_device *sdp = q->queuedata;
> > +
> > +	if (mesg.event == PM_EVENT_SUSPEND) {
> > +		q->pm_status = RPM_SUSPENDING;
> > +		pm_runtime_put(&sdp->sdev_gendev);
> > +	}
> > +	else if (mesg.event == PM_EVENT_RESUME) {
> > +		q->pm_status = RPM_RESUMING;
> > +		pm_runtime_get(&sdp->sdev_gendev);
> > +	}
> 
> Don't use pm_message_t arguments for runtime PM.  Implement separate 
> routines for suspend and resume.

OK, I'll add 2 callbacks to request_queue.

runtime_pm_fn runtime_suspend;
runtime_pm_fn runtime_resume;

> 
> Alan Stern
> 


