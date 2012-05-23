Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965200Ab2EWP1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:27:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51800 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933684Ab2EWP1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:27:21 -0400
Date: Wed, 23 May 2012 11:27:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH v3 0/4]: block layer runtime pm
In-Reply-To: <CAF1ivSYTw19AEXmhAsvXp-vVk5ZGeFPzi9omBzCtYGKixNS5xw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1205231124460.1566-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Lin Ming wrote:

> On Wed, May 23, 2012 at 11:03 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Wed, 23 May 2012, Lin Ming wrote:
> >
> >> Another thing need to check is if system suspend/resume works.
> >
> > Right!  Although I would hope that your work doesn't interfere at all
> > with system sleep, since it touches only the runtime PM pathways.
> 
> sd_sync_cache and sd_start_stop_device are changed with REQ_PM set.
> And they are called for system suspend too.
> 
> So it probably will have problem.

People have already run into problems where system suspend 
occurred at a time when a SCSI device was already runtime suspended.  
That's why scsi_bus_suspend_common() includes an appropriate check.

Alan Stern

