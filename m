Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab0EOCcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 22:32:43 -0400
Received: from netrider.rowland.org ([192.131.102.5]:32935 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751350Ab0EOCcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 22:32:42 -0400
Date: Fri, 14 May 2010 22:32:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Matt Reimer <mattjreimer@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while 
 userspace is frozen?
In-Reply-To: <AANLkTimBxoCCeT_ns30JTIGKqgkiRIvKTf4LfE3mopkS@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1005142231390.11498-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010, Matt Reimer wrote:

> > I don't see anything wrong with the patch itself, but I dislike the
> > description.  Devices can come and go from any hotpluggable bus, not
> > just MMC/SD.  That just happens to be the first place the problem was
> > observed.
> 
> Good point. How about this?
> 
> Matt
> 
> From 813bd223e5a2fa577b9e64ddf12654a93d0aab8b Mon Sep 17 00:00:00 2001
> From: Matt Reimer <mreimer@sdgsystems.com>
> Date: Thu, 13 May 2010 14:36:54 -0700
> Subject: [PATCH] fs: prevent hang on suspend/resume when MMC/SD card present
> 
> Devices can come and go bus during suspend or resume, when the
> writeback thread is frozen, resulting in a hang. Prevent the hang
> by thawing the writeback thread in del_gendisk().

I would have said "the block layer's writeback thread", but this is 
okay.

Alan Stern

