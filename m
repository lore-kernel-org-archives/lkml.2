Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0K1WxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 17:53:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35847 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab0K1WxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 17:53:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Prevent dpm_prepare() from returning errors unnecessarily
Date: Sun, 28 Nov 2010 23:52:10 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1011281031240.27303-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1011281031240.27303-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011282352.10498.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 28, 2010, Alan Stern wrote:
> On Sun, 28 Nov 2010, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Currently dpm_prepare() returns error code if it finds that a device
> > being suspended has a pending runtime resume request.  However, it
> > should not do that if the checking for wakeup events is not enabled.
> 
> It doesn't.  The line you changed _does_ check device_may_wakeup().

That's not the point.  The problem is that it shouldn't abort suspend
when events_check_enabled is unset.

> > On the other hand, if the checking for wakeup events is enabled, it
> > can return error when a wakeup event is detected, regardless of its
> > source.
> 
> Will adding this call to pm_wakeup_event() end up double-counting some 
> events?

Yes, it will, if the event has already been reported by the subsystem or driver.

I don't think it's a very big issue and I'm not sure trying to avoid it is
worth the effort (we can check if the device's wakeup source object is active
and skip reporting the wakeup event in that case, but that doesn't guarantee
that the event won't be counted twice anyway).

Thanks,
Rafael
