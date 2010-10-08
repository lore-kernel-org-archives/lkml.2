Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab0JHIXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:23:22 -0400
Received: from vwp2514.webpack.hosteurope.de ([87.230.42.24]:48156 "EHLO
	vwp2514.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755640Ab0JHIXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:23:20 -0400
Subject: Re: 2.6.35.6 fails to suspend (pxa2xx-mci.0)
From: Sven Neumann <s.neumann@raumfeld.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Mack <daniel@caiaq.de>, Colin Cross <ccross@android.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <201010072323.05218.rjw@sisk.pl>
References: <1286177435.2140.5.camel@sven> <201010070218.41944.rjw@sisk.pl>
	 <1286463808.797.10.camel@bender>  <201010072323.05218.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Organization: RAUMFELD GmbH
Date: Fri, 08 Oct 2010 10:23:17 +0200
Message-ID: <1286526197.4493.19.camel@sven>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;s.neumann@raumfeld.com;1286526200;0b53c7ff;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 23:23 +0200, Rafael J. Wysocki wrote:

> > > I wonder what happens if you echo 0 to /sys/power/pm_async ?
> > 
> > Nothing happens. The problem persists (tested with 2.6.36-rc7). What
> > would you expect to happen?
> 
> Exactly that. :-)
> 
> Commit 152e1d5920 should not affect the non-async case (I'd be surprised if
> it did really) and things should work with /sys/power/pm_async = 0 anyway.
> 
> Please try check if you can reproduce with commt 152e1d5920 reverted and
> /sys/power/pm_async = 0.  If you can, that's a driver bug.

Ok, for the record, here's what I tried. I have rebooted between tests
to make sure there's no state pulled in from the previous test:

 2.6.36-rc7, no changes,      pm_async 1 :  suspend fails
 2.6.36-rc7, no changes,      pm_async 0 :  suspend fails

 2.6.36-rc7, 152e1d reverted, pm_async 1 :  suspend works
 2.6.36-rc7, 152e1d reverted, pm_async 0 :  suspend fails

 2.6.34.7, no changes,        pm_async 1 :  suspend works
 2.6.34.7, no changes,        pm_async 0 :  suspend works

I am not sure how this should be interpreted.


Sven



