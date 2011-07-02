Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab1GBSPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 14:15:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47058 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab1GBSPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 14:15:02 -0400
Date: Sat, 2 Jul 2011 20:15:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Stern <stern@rowland.harvard.edu>,
        Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk, rjw@sisk.pl,
        linux-usb@vger.kernel.org
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Message-ID: <20110702181501.GN23059@one.firstfloor.org>
References: <1309554818.2722.48.camel@mulgrave> <Pine.LNX.4.44L0.1107012200260.4273-100000@netrider.rowland.org> <20110702060846.GH23059@one.firstfloor.org> <1309609482.2554.8.camel@mulgrave> <20110702170554.GJ23059@one.firstfloor.org> <1309626567.2554.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309626567.2554.11.camel@mulgrave>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And the transition after unplug goes
> 
> 13->12->10->8->7->6->5->3
> 
> implying we're missing put events.

Don't know why. I used this check (with trace_scsi_dev containing the name)
in put_device:

if (trace_scsi && dev->type == &scsi_dev_type &&
     trace_scsi_dev[0] == 0 || !strcmp(dev_name(dev), trace_scsi_dev))) {
	dev_printk ...

If you want instrumentation somewhere else please let me know.

Maybe there simply isn't a put_device to 0 and the NULL pointer happens
for some other reason?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
