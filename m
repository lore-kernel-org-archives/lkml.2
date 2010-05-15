Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0EOXll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 19:41:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32824 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab0EOXli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 19:41:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while userspace is frozen?
Date: Sat, 15 May 2010 22:30:10 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Matt Reimer <mattjreimer@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>
References: <Pine.LNX.4.44L0.1005142231390.11498-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1005142231390.11498-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005152230.10230.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 May 2010, Alan Stern wrote:
> On Thu, 13 May 2010, Matt Reimer wrote:
> 
> > > I don't see anything wrong with the patch itself, but I dislike the
> > > description.  Devices can come and go from any hotpluggable bus, not
> > > just MMC/SD.  That just happens to be the first place the problem was
> > > observed.
> > 
> > Good point. How about this?
> > 
> > Matt
> > 
> > From 813bd223e5a2fa577b9e64ddf12654a93d0aab8b Mon Sep 17 00:00:00 2001
> > From: Matt Reimer <mreimer@sdgsystems.com>
> > Date: Thu, 13 May 2010 14:36:54 -0700
> > Subject: [PATCH] fs: prevent hang on suspend/resume when MMC/SD card present
> > 
> > Devices can come and go bus during suspend or resume, when the
> > writeback thread is frozen, resulting in a hang. Prevent the hang
> > by thawing the writeback thread in del_gendisk().
> 
> I would have said "the block layer's writeback thread", but this is 
> okay.

OK, so now I have a question who's going to take the patch.

Jens, what's your opinion?

Rafael
