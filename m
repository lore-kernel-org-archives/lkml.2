Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329Ab2EOSaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:30:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45663 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932894Ab2EOSaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:30:01 -0400
Date: Tue, 15 May 2012 14:30:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] block: add a flag to identify PM request
In-Reply-To: <1337097533.3515.17.camel@chief-river-32>
Message-ID: <Pine.LNX.4.44L0.1205151424450.1796-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012, Lin Ming wrote:

> > > IDE code still uses both types and they are used for system
> > > suspend/resume. See generic_ide_suspend and generic_ide_resume.
> > 
> > drivers/ide is obsolete code though so we shouldn't be forcing its needs
> > on the future
> 
> Do you mean we don't care about breaking ide code?

As far as I can tell, Alan means that you shouldn't hesitate to change
the IDE code in order to make things easier for more up-to-date
systems.  But don't _break_ the IDE driver!

> struct request {
>         ....
>         unsigned int cmd_flags;
>         enum rq_cmd_type_bits cmd_type;
> 
> Another reason I didn't reuse REQ_TYPE_PM_SUSPEND/REQ_TYPE_PM_RESUME is
> because all scsi requests set the cmd_type to REQ_TYPE_BLOCK_PC.
> 
> So I think we should add a new cmd_flags(REQ_PM) to tell if it's a
> runtime pm request.

Yes, that does make more sense, even though it seems silly to have both
a flag and a type code for the same thing.  Maybe the IDE driver could
be changed to use the new flag.

Alan Stern

