Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761535Ab0J2OI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:08:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35481 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757785Ab0J2OIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:08:55 -0400
Date: Fri, 29 Oct 2010 10:08:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Kevin Winchester <kjwinchester@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] power: Fix typo in status comparison causing warning
In-Reply-To: <201010290949.11833.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1010291006340.1588-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Oct 2010, Rafael J. Wysocki wrote:

> On Friday, October 29, 2010, Kevin Winchester wrote:
> > GCC version 4.5.1 gives the following warning:
> > 
> > 	drivers/base/power/runtime.c: In function ‘rpm_check_suspend_allowed’:
> > 	drivers/base/power/runtime.c:146:25: warning: comparison between ‘enum dpm_state’ and ‘enum rpm_status’
> > 
> > which seems to be a typo in that dev->power.runtime_status
> > should be compared instead of dev->power.status.
> > 
> > Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> > ---
> >  drivers/base/power/runtime.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> > index 126ca49..02c652b 100644
> > --- a/drivers/base/power/runtime.c
> > +++ b/drivers/base/power/runtime.c
> > @@ -143,7 +143,7 @@ static int rpm_check_suspend_allowed(struct device *dev)
> >  
> >  	/* Pending resume requests take precedence over suspends. */
> >  	else if ((dev->power.deferred_resume
> > -			&& dev->power.status == RPM_SUSPENDING)
> > +			&& dev->power.runtime_status == RPM_SUSPENDING)
> >  	    || (dev->power.request_pending
> >  			&& dev->power.request == RPM_REQ_RESUME))
> >  		retval = -EAGAIN;
> 
> Ouch, this actually is a serious bug.

Yes indeed.  I should have caught it while reviewing the patch.  A 
quick check shows there are no other similar typos.

> Thanks a lot for the fix, will push to Linus shortly.
> 
> Rafael

Alan Stern

