Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab0K3W2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:28:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43108 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822Ab0K3W2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:28:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Prevent dpm_prepare() from returning errors unnecessarily
Date: Tue, 30 Nov 2010 23:27:24 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ming Lei <tom.leiming@gmail.com>
References: <Pine.LNX.4.44L0.1011301008110.1686-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1011301008110.1686-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011302327.24222.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 30, 2010, Alan Stern wrote:
> On Mon, 29 Nov 2010, Rafael J. Wysocki wrote:
> 
> > > Oh, I see.  This is a tricky issue.  Every driver for a device that can
> > > have wakeup-enabled children needs to worry about the race between
> > > suspending the device and receiving a wakeup request from a child.  
> > > For example, in drivers/usb/core/hcd-pci.c, the suspend_common()
> > > routine goes out of its way to return -EBUSY if device_may_wakeup() is
> > > true and the controller's root hub has a pending wakeup request.
> > > 
> > > How should drivers handle this in general?  Should we make an effort to
> > > convert them to use the wakeup framework so they they can let the PM
> > > core take care of these races?
> > 
> > I think so.
> > 
> > We also need to put a pm_check_wakeup_events() check into dpm_suspend() IMO,
> > so that we abort the suspending of devices as soon as a wakeup event is
> > reported.
> 
> You might as well add that into this patch.

I'll do that in a separate patch.

> > > Do we have to consider similar races during runtime suspend?
> > 
> > Ideally, yes, but I'm not sure if that's generally possible.  IMO, it won't be
> > a big deal if a parent device is suspended and immediately resumed occasionally
> > due to a pending wakeup signal from one of its children.  It may be a problem
> > if that happens too often, though.
> 
> Okay.
> 
> > Does it mean you're fine with the patch?
> 
> Provided you repair the error that Lei Ming pointed out.  That's the 
> problem with functions that return Boolean values -- you have to name 
> them very carefully.  Ideally the name should be a predicate or a
> question.

I already have fixed it.

The name is unfortunate indeed, perhaps it's better to call that function
pm_new_wakeup_events() or something like this.

Thanks,
Rafael
