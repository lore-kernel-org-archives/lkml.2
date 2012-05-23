Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903Ab2EWPCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:02:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51767 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752042Ab2EWPCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:02:40 -0400
Date: Wed, 23 May 2012 11:02:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH v3 1/4] block: add a flag to identify PM request
In-Reply-To: <1337671292-15583-2-git-send-email-ming.m.lin@intel.com>
Message-ID: <Pine.LNX.4.44L0.1205231058400.1566-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Lin Ming wrote:

> Add a flag REQ_PM to identify the request is PM related.
> As an example, modify scsi code to use this flag.

Don't forget to check up on the SCSI error handler.  If I'm not
mistaken, the libata drivers use it during suspend and resume.  Also,
the error handler will run if one of the REQ_PM commands encounters an
error.

Therefore it seems likely that every request submitted by the error 
handler needs to have REQ_PM set.

Alan Stern

