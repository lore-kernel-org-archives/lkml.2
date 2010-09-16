Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab0IPVZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 17:25:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35670 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab0IPVZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 17:25:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Fix potential issue with failing asynchronous suspend (was: Re: [PATCH] PM: Prevent waiting ...)
Date: Thu, 16 Sep 2010 23:24:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>
References: <Pine.LNX.4.44L0.1009161655470.1695-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009161655470.1695-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009162324.19109.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 16, 2010, Alan Stern wrote:
> On Thu, 16 Sep 2010, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM: Fix potential issue with failing asynchronous suspend
> > 
> > There is a potential issue with the asynchronous suspend code that
> > a device driver suspending asynchronously may not notice that it
> > should back off.  There are two failing scenarions, (1) when the
> > driver is waiting for a driver suspending synchronously to complete
> > and that second driver returns error code, in which case async_error
> > won't be set and the waiting driver will continue suspending and (2)
> > after the driver has called device_pm_wait_for_dev() and the waited
> > for driver returns error code, in which case the caller of
> > device_pm_wait_for_dev() will not know that there was an error and
> > will continue suspending.
> > 
> > To fix this issue make __device_suspend() set async_error, so
> > async_suspend() doesn't need to set it any more, and make
> > device_pm_wait_for_dev() return async_error, so that its callers
> > can check whether or not they should continue suspending.
> > 
> > No more changes are necessary, since device_pm_wait_for_dev() is
> > not used by any drivers' suspend routines at the moment.
> 
> You just squeaked by, since it is _is_ being used by a USB _resume_
> routine.  :-)

I know that, but resume actually doesn't need to care about async_error.

Thanks,
Rafael
