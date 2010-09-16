Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab0IPVAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 17:00:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34553 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756285Ab0IPVAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 17:00:15 -0400
Date: Thu, 16 Sep 2010 17:00:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Colin Cross <ccross@android.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] PM: Fix potential issue with failing asynchronous suspend
 (was: Re: [PATCH] PM: Prevent waiting ...)
In-Reply-To: <201009162236.39660.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1009161655470.1695-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Fix potential issue with failing asynchronous suspend
> 
> There is a potential issue with the asynchronous suspend code that
> a device driver suspending asynchronously may not notice that it
> should back off.  There are two failing scenarions, (1) when the
> driver is waiting for a driver suspending synchronously to complete
> and that second driver returns error code, in which case async_error
> won't be set and the waiting driver will continue suspending and (2)
> after the driver has called device_pm_wait_for_dev() and the waited
> for driver returns error code, in which case the caller of
> device_pm_wait_for_dev() will not know that there was an error and
> will continue suspending.
> 
> To fix this issue make __device_suspend() set async_error, so
> async_suspend() doesn't need to set it any more, and make
> device_pm_wait_for_dev() return async_error, so that its callers
> can check whether or not they should continue suspending.
> 
> No more changes are necessary, since device_pm_wait_for_dev() is
> not used by any drivers' suspend routines at the moment.

You just squeaked by, since it is _is_ being used by a USB _resume_
routine.  :-)

Alan Stern

