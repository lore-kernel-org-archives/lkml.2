Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab2BQTGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 14:06:12 -0500
Received: from mail.vyatta.com ([76.74.103.46]:52779 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab2BQTGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 14:06:10 -0500
Date: Fri, 17 Feb 2012 11:06:02 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Joe Perches <joe@perches.com>
Cc: Luis Felipe Strano Moraes <lfelipe@profusion.mobi>, linville@tuxdriver.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cleaning up code formatting errors in net/wireless
 pointed out by checkpatch.
Message-ID: <20120217110602.2c4e762a@nehalam.linuxnetplumber.net>
In-Reply-To: <1329504344.584.18.camel@joe2Laptop>
References: <1329492603-3972-1-git-send-email-lfelipe@profusion.mobi>
	<1329504344.584.18.camel@joe2Laptop>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Feb 2012 10:45:44 -0800
Joe Perches <joe@perches.com> wrote:

> On Fri, 2012-02-17 at 07:30 -0800, Luis Felipe Strano Moraes wrote:
> > These are mostly minor changes and they are being sent as one patch only in
> > order to cause the smallest amount of disruption.
> []
> > diff --git a/net/wireless/core.c b/net/wireless/core.c
> []
> > @@ -668,7 +668,7 @@ void wiphy_unregister(struct wiphy *wiphy)
> >  		mutex_lock(&rdev->devlist_mtx);
> >  		__count = rdev->opencount;
> >  		mutex_unlock(&rdev->devlist_mtx);
> > -		__count == 0;}));
> > +		__count == 0; }));
> 
> Inline statement expressions are pretty unusual
> for kernel sources.  Normally these are used via
> macro.
> 
> I'd try to make the statement expression visually
> distinct.  Something like:
> 
> 	wait_event(rdev->dev_wait,
> 		   ({
> 			   int __count;
> 			   mutex_lock(&rdev->devlist_mtx);
> 			   __count = rdev->opencount;
> 			   mutex_unlock(&rdev->devlist_mtx);
> 			   __count == 0;
> 		   })
> 		  );
> 

I prefer to see this done as an inline function

wait_event(rdev->dev_wait, is_foo_ready(rdev))

Also, in this case wrapping a condition with a mutex really is
meaningless because the state is longer protected out side the
protected region; in other words the mutex here is bogus and
provides no additional protection.
