Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab0EPTgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 15:36:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34338 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab0EPTgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 15:36:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while userspace is frozen?
Date: Sun, 16 May 2010 21:38:07 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       Matt Reimer <mattjreimer@gmail.com>
References: <Pine.LNX.4.44L0.1005142231390.11498-100000@netrider.rowland.org> <201005152230.10230.rjw@sisk.pl> <4BEFA375.7030404@crca.org.au>
In-Reply-To: <4BEFA375.7030404@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005162138.07105.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 May 2010, Nigel Cunningham wrote:
> Hi.
> 
> On 16/05/10 06:30, Rafael J. Wysocki wrote:
> > On Saturday 15 May 2010, Alan Stern wrote:
> >> On Thu, 13 May 2010, Matt Reimer wrote:
> >>
> >>>> I don't see anything wrong with the patch itself, but I dislike the
> >>>> description.  Devices can come and go from any hotpluggable bus, not
> >>>> just MMC/SD.  That just happens to be the first place the problem was
> >>>> observed.
> >>>
> >>> Good point. How about this?
> >>>
> >>> Matt
> >>>
> >>>  From 813bd223e5a2fa577b9e64ddf12654a93d0aab8b Mon Sep 17 00:00:00 2001
> >>> From: Matt Reimer<mreimer@sdgsystems.com>
> >>> Date: Thu, 13 May 2010 14:36:54 -0700
> >>> Subject: [PATCH] fs: prevent hang on suspend/resume when MMC/SD card present
> >>>
> >>> Devices can come and go bus during suspend or resume, when the
> >>> writeback thread is frozen, resulting in a hang. Prevent the hang
> >>> by thawing the writeback thread in del_gendisk().
> >>
> >> I would have said "the block layer's writeback thread", but this is
> >> okay.
> >
> > OK, so now I have a question who's going to take the patch.
> 
> I object to the patch.
> 
> Tell the patch it ought to exit once thawed, by all means.

I'm not sure what you mean.  Care to explain?

> Make the patch unfreezeable to begin with, by all means.

That wouldn't work.

> But don't go down the path of having $random_code_path unfreeze a 
> thread. That will lead to unpredictability, confusion and bugs.

As a general rule, I agree, but this particular case is somewhat special.

> If you know a disk is going to be unregistered during resume,

How do we check that, exactly?

> use the hooks early in the suspend / hibernate process to block new I/O and 
> flush what's already there so that there's no need to block on the 
> writeback thread, and/or no need to have the writeback thread frozen.

I'm not sure if that's realistic.  Do you have a specific implementation in
mind?

Rafael
