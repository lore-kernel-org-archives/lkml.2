Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab2EOOf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:35:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45550 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932912Ab2EOOfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:35:52 -0400
Date: Tue, 15 May 2012 10:35:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: Jens Axboe <axboe@kernel.dk>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] block: add a flag to identify PM request
In-Reply-To: <1337071697-30920-2-git-send-email-ming.m.lin@intel.com>
Message-ID: <Pine.LNX.4.44L0.1205151028020.1796-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012, Lin Ming wrote:

> Add a flag REQ_PM to identify the request is PM related.
> As an example, modify scsi code to use this flag.

There already is such a flag; you don't need to add one.  In fact, 
there already are _two_ such flags, and it would be best to remove one 
of them.  In include/linux/blkdev.h:

	REQ_TYPE_PM_SUSPEND,		/* suspend request */
	REQ_TYPE_PM_RESUME,		/* resume request */

Apparently they had been used by the old ide driver, but they don't
seem to be used anywhere now.

Aside from that, this patch seems to be going in the right direction.

Alan Stern

