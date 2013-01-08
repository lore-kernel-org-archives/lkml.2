Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab3AHP14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 10:27:56 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34901 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756613Ab3AHP1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 10:27:55 -0500
Date: Tue, 8 Jan 2013 10:27:54 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Aaron Lu <aaron.lu@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Aaron Lu <aaron.lwe@gmail.com>,
        Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v6 0/4] block layer runtime pm
In-Reply-To: <50EBCBC3.4070606@intel.com>
Message-ID: <Pine.LNX.4.44L0.1301081024300.1535-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2013, Aaron Lu wrote:

> So this also reminds me that as long as CONFIG_PM_RUNTIME is selected,
> the blk_pm_add/put/peek_request functions will be in the block IO path.
> Shall we introduce a new config option to selectively build block
> runtime PM functionality? something like CONFIG_BLK_PM_RUNTIME perhaps?
> 
> Just some condition checks in those functions, not sure if it is worth a
> new config though. Please suggest, thanks.

I don't think it is needed.  The new routines will be very quick when 
blk_pm_runtime_init() hasn't been called, once you add back the checks 
for the queue's device.

Alan Stern

