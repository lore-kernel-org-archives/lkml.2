Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614Ab2EWOyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:54:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51753 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932304Ab2EWOyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:54:00 -0400
Date: Wed, 23 May 2012 10:53:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH v3 3/4] block: implement runtime pm strategy
In-Reply-To: <CAF1ivSbukHBZJsguAcUVDbQotyvE5iAfccgfv+-bGw1v6Z3Dvw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1205231052270.1566-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Lin Ming wrote:

> >> +             /* Only PM request is allowed to go if the queue is suspended */
> >> +             if (q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM)) {
> >> +                     rq = NULL;
> >> +                     break;
> >> +             }
> >
> > Not even PM requests should be allowed to go if the status is
> > RPM_SUSPENDED.
> 
> PM requests are used to wake up the device.
> If they are not allowed to go, then how to wake up the device?

When blk_pre_runtime_resume runs, the status is changed to
RPM_RESUMING.  _Then_ PM requests are allowed to go.  Not before.

Alan Stern

