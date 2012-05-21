Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab2EUSdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:33:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57673 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751157Ab2EUSdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:33:00 -0400
Date: Mon, 21 May 2012 14:32:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
In-Reply-To: <CAF1ivSajZb_D9nOuA5gYeDgHgbvyqbCueV8+kDyy3DSBs1AumQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1205211430220.1725-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, Lin Ming wrote:

> On Mon, May 21, 2012 at 11:00 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Mon, 21 May 2012, Lin Ming wrote:
> >
> >> On Fri, May 18, 2012 at 2:29 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >> [snip]
> >> > I may have left some parts out from this brief description.  Hopefully
> >> > you'll be able to figure out the general idea and get it to work.
> >>
> >> All journal threads and flusher thread of the disk need to be freezed
> >> before suspend and thaw after resume.
> >
> > Why?  If any of those threads needs to write something to the disk
> > while the disk is suspended, the disk will simply be resumed.
> 
> When tested the patches, I found that kjournald and flusher thread
> frequently resume the disk.
> 
> I'm not familiar with journal.
> Are the journal threads still need to be in active state when the disk
> is already suspended?

I don't know the answers.  Maybe Jens can tell us.

Ideally, a rotating disk wouldn't be suspended unless all the dirty 
blocks were already flushed and the journal was up-to-date.  For an 
SSD, frequently suspending and resuming doesn't matter quite so much.  
This may come down to a matter of setting the right value for the 
autosuspend timeout.

Alan Stern

