Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2BTKpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 05:45:34 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:46257 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab2BTKpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 05:45:33 -0500
Subject: Re: [PATCH] Cleaning up code formatting errors in net/wireless
 pointed out by checkpatch.
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Joe Perches <joe@perches.com>,
        Luis Felipe Strano Moraes <lfelipe@profusion.mobi>,
        linville@tuxdriver.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120217110602.2c4e762a@nehalam.linuxnetplumber.net>
References: <1329492603-3972-1-git-send-email-lfelipe@profusion.mobi>
	 <1329504344.584.18.camel@joe2Laptop>
	 <20120217110602.2c4e762a@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Feb 2012 11:45:22 +0100
Message-ID: <1329734722.3458.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 11:06 -0800, Stephen Hemminger wrote:

> > I'd try to make the statement expression visually
> > distinct.  Something like:
> > 
> > 	wait_event(rdev->dev_wait,
> > 		   ({
> > 			   int __count;
> > 			   mutex_lock(&rdev->devlist_mtx);
> > 			   __count = rdev->opencount;
> > 			   mutex_unlock(&rdev->devlist_mtx);
> > 			   __count == 0;
> > 		   })
> > 		  );
> > 
> 
> I prefer to see this done as an inline function
> 
> wait_event(rdev->dev_wait, is_foo_ready(rdev))
> 
> Also, in this case wrapping a condition with a mutex really is
> meaningless because the state is longer protected out side the
> protected region; in other words the mutex here is bogus and
> provides no additional protection.

I don't really care about all the changes suggested here -- feel free to
make them. One thing I'd like to point out though is that generally the
mutex might serve a purpose even here. In this specific case, it
currently doesn't, but I still think it's safer to keep it in case
somebody modifies other code. The case where it matters is when the
modification of the "opencount" variable isn't the last thing that
happens in a locked section, but you here want or need to wait for
everything happening in that section to be done.

johannes

