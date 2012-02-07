Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab2BGE7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 23:59:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:25677 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756469Ab2BGE7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 23:59:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="104773066"
Message-ID: <1328590773.9146.46.camel@yhuang-dev>
Subject: Re: [RFC 0/5] scsi, sd, pm, request based runtime PM for scsi disk
From: Huang Ying <ying.huang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>
Date: Tue, 07 Feb 2012 12:59:33 +0800
In-Reply-To: <Pine.LNX.4.44L0.1202061007570.1525-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1202061007570.1525-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alan,

On Mon, 2012-02-06 at 10:13 -0500, Alan Stern wrote:
> On Mon, 6 Feb 2012, Huang Ying wrote:
> 
> > SSD becomes more and more popular, this makes it possible to put disk into
> > low power state more often.  And request based runtime PM for scsi disk is
> > more useful than open/close based one because disk is normally mounted at
> > most time.
> > 
> > One known issue, because SCSI TEST_UNIT_READY will be put into request
> > queue every 2 seconds by default, this makes it hard for disk to sleep.
> > Maybe we can implement check_events callback in some other way?
> > 
> > [RFC 1/5] pm, runtime, Add resume notifier
> > [RFC 2/5] scsi, pm, rename scsi_autopm_get/put_xxx to
> > [RFC 3/5] scsi, pm, add pm_runtime_get/put in scsi request
> > [RFC 4/5] scsi, pm, use autosuspend for scsi runtime PM
> > [RFC 5/5] scsi, sd, pm, request based runtime PM support
> 
> Your whole approach is at the wrong level.  Runtime PM between I/O 
> requests for block devices should be implemented in the block layer, 
> not in the SCSI layer.
> 
> It also is much more difficult than your patches would indicate.  For 
> example, some USB card readers indicate a media change every time they 
> resume; therefore they must not be suspended while the device file is 
> open.
> 
> Another difficulty arises because some drivers need to send SCSI 
> commands (such as SYNCHRONIZE CACHE) _while_ suspending or resuming.

Thank you very much for your valuable response!  We will do more
research work on this topic, including your previous effort. :)

Best Regards,
Huang Ying


