Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab0JHUJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 16:09:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57650 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab0JHUJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 16:09:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sven Neumann <s.neumann@raumfeld.com>
Subject: Re: 2.6.35.6 fails to suspend (pxa2xx-mci.0)
Date: Fri, 8 Oct 2010 22:08:25 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Daniel Mack <daniel@caiaq.de>, Colin Cross <ccross@android.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1286177435.2140.5.camel@sven> <201010072323.05218.rjw@sisk.pl> <1286526197.4493.19.camel@sven>
In-Reply-To: <1286526197.4493.19.camel@sven>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010082208.25767.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 08, 2010, Sven Neumann wrote:
> On Thu, 2010-10-07 at 23:23 +0200, Rafael J. Wysocki wrote:
> 
> > > > I wonder what happens if you echo 0 to /sys/power/pm_async ?
> > > 
> > > Nothing happens. The problem persists (tested with 2.6.36-rc7). What
> > > would you expect to happen?
> > 
> > Exactly that. :-)
> > 
> > Commit 152e1d5920 should not affect the non-async case (I'd be surprised if
> > it did really) and things should work with /sys/power/pm_async = 0 anyway.
> > 
> > Please try check if you can reproduce with commt 152e1d5920 reverted and
> > /sys/power/pm_async = 0.  If you can, that's a driver bug.
> 
> Ok, for the record, here's what I tried. I have rebooted between tests
> to make sure there's no state pulled in from the previous test:
> 
>  2.6.36-rc7, no changes,      pm_async 1 :  suspend fails
>  2.6.36-rc7, no changes,      pm_async 0 :  suspend fails
> 
>  2.6.36-rc7, 152e1d reverted, pm_async 1 :  suspend works
>  2.6.36-rc7, 152e1d reverted, pm_async 0 :  suspend fails
> 
>  2.6.34.7, no changes,        pm_async 1 :  suspend works
>  2.6.34.7, no changes,        pm_async 0 :  suspend works
> 
> I am not sure how this should be interpreted.

There is a problem with the pxa2xx-mci.0 suspend that has been introduced
some time after 2.6.34, but it is not related to commit 152e1d5920.  The
problem was not visible with pm_async=1 because of the very bug fixed by
commit 152e1d5920.

Please see if the problem is there in 2.6.35 (please test with pm_async=0).

Thanks,
Rafael
