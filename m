Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964977Ab2EOOhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:37:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45558 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758244Ab2EOOhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:37:47 -0400
Date: Tue, 15 May 2012 10:37:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH 2/3] block: add queue runtime pm callback
In-Reply-To: <1337071697-30920-3-git-send-email-ming.m.lin@intel.com>
Message-ID: <Pine.LNX.4.44L0.1205151036510.1796-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012, Lin Ming wrote:

> Add ->runtime_pm callback and ->pm_status to request queue.
> As an example, implement a simple queue runtime_pm callback
> in sd driver.

> +static int sd_runtime_pm_fn(struct request_queue *q, pm_message_t mesg)
> +{
> +	struct scsi_device *sdp = q->queuedata;
> +
> +	if (mesg.event == PM_EVENT_SUSPEND) {
> +		q->pm_status = RPM_SUSPENDING;
> +		pm_runtime_put(&sdp->sdev_gendev);
> +	}
> +	else if (mesg.event == PM_EVENT_RESUME) {
> +		q->pm_status = RPM_RESUMING;
> +		pm_runtime_get(&sdp->sdev_gendev);
> +	}

Don't use pm_message_t arguments for runtime PM.  Implement separate 
routines for suspend and resume.

Alan Stern

