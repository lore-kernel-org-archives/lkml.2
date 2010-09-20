Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab0ITTA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:00:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:54566 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757150Ab0ITTA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:00:56 -0400
Date: Mon, 20 Sep 2010 11:59:29 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Colin Cross <ccross@android.com>
Subject: Re: [PATCH 2/2] PM: Fix potential issue with failing asynchronous
 suspend
Message-ID: <20100920185929.GB29380@suse.de>
References: <201009201957.40995.rjw@sisk.pl>
 <201009202000.45147.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009202000.45147.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 08:00:44PM +0200, Rafael J. Wysocki wrote:
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
> No more changes are necessary, since device_pm_wait_for_dev() in
> not used by any drivers' suspend routines.
> 
> Reported-by: Colin Cross <ccross@android.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
