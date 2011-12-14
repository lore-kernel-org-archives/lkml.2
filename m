Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab1LNSgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:36:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:35272 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757724Ab1LNSgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:36:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102212390"
Subject: Re: [PATCH 1/3] [SCSI] sd: fix runtime status check in sd_shutdown
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1112141146230.1707-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1112141146230.1707-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 15 Dec 2011 02:34:24 +0800
Message-ID: <1323887664.7655.5.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 00:49 +0800, Alan Stern wrote:
> On Wed, 14 Dec 2011, Lin Ming wrote:
> 
> > Commit af8db15 disabled device's runtime PM during shutdown.
> > So sd's runtime status can't be checked with pm_runtime_suspended(dev)
> > any more.
> > 
> > Fix it by checking runtime status with pm_runtime_status_suspended(dev).
> > 
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  drivers/scsi/sd.c |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 7b3f807..284b087 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -2742,7 +2742,12 @@ static void sd_shutdown(struct device *dev)
> >  	if (!sdkp)
> >  		return;         /* this can happen */
> >  
> > -	if (pm_runtime_suspended(dev))
> > +	/*
> > +	 * Check runtime status with pm_runtime_status_suspended(dev)
> > +	 * instead of pm_runtime_suspended(dev),
> > +	 * because device_shutdown() has disabled the device's runtime PM.
> > +	 */
> > +	if (pm_runtime_status_suspended(dev))
> >  		goto exit;
> >  
> >  	if (sdkp->WCE) {
> 
> This is no longer needed.  See commit
> fe6b91f47080eb17d21cbf2a39311877d57f6938 (PM / Driver core: leave
> runtime PM enabled during system shutdown).

I'll remove this patch.

Thanks.

> 
> Alan Stern
> 


