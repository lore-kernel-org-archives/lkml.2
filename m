Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab2KPAzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 19:55:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:16989 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab2KPAy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 19:54:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,259,1352102400"; 
   d="scan'208";a="218451450"
Message-ID: <1353027296.7176.312.camel@yhuang-dev>
Subject: Re: [BUGFIX] PM: Fix active child counting when disabled and
 forbidden
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Fri, 16 Nov 2012 08:54:56 +0800
In-Reply-To: <5403446.Qq6ASJZlmy@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1211141608200.1620-100000@iolanthe.rowland.org>
	 <1353026174.7176.301.camel@yhuang-dev>
	 <193302419.NkjaAjIrYa@vostro.rjw.lan> <5403446.Qq6ASJZlmy@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 01:55 +0100, Rafael J. Wysocki wrote:
> On Friday, November 16, 2012 01:44:00 AM Rafael J. Wysocki wrote:
> > On Friday, November 16, 2012 08:36:14 AM Huang Ying wrote:
> > > On Thu, 2012-11-15 at 10:51 +0100, Rafael J. Wysocki wrote:
> 
> [...]
> 
> > > 
> > > For this situation, if user "echo auto > .../power/control" for the
> > > device, the runtime PM callbacks of device will be called.  I think that
> > > is not intended.  So I think it is better to use some kind of flag or
> > > state for that.
> > 
> > I'm not sure what situation exactly you have in mind.  Care to give an
> > exact scenario?
> 
> Ah, I see.  When we've just called drv->remove(), there is a window in
> which user space may cause the driver's runtime PM callbacks to be
> executed by changing its attribute to "auto".
> 
> So perhaps we should check pci_dev->driver rather than pci_dev->dev.driver
> in the runtime PM callbacks?  With a few more changes that should allow us
> to close that race.

Yes.  And I think, with pci_dev->driver (after some changes suggested by
Alan), we need not to use pm_runtime_get/put_skip_callbacks().

Best Regards,
Huang Ying


