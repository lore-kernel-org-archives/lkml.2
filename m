Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab2ASH6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 02:58:23 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:59347 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753177Ab2ASH6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 02:58:21 -0500
Message-ID: <1326959897.6404.17.camel@joe2Laptop>
Subject: Re: Change request: "scsi: killing requests for dead queue"
From: Joe Perches <joe@perches.com>
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 18 Jan 2012 23:58:17 -0800
In-Reply-To: <4F17D4C2020000A100008B19@gwsmtp1.uni-regensburg.de>
References: <4F17D4C2020000A100008B19@gwsmtp1.uni-regensburg.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-19 at 08:30 +0100, Ulrich Windl wrote:
> Hi!
> 
> I have a change request: I saw three message that I couldn't bring into context with any other event (SLES11 SP1 (2.6.32.49-0.3-default)):
> 
> Jan 18 15:33:04 h03 kernel: [2866825.805434] scsi: killing requests for dead queue
> Jan 18 15:33:04 h03 kernel: [2866825.812129] scsi: killing requests for dead queue
> Jan 18 15:33:04 h03 kernel: [2866825.815553] scsi: killing requests for dead queue
> 
> Unfortunately the kernel message doesn't give some kind of queue identifier, so that's hard to correlate with any other events.
> 
> Can this message be improved to include some variable output?

It was improved by:

commit 745718132c3c7cac98a622b610e239dcd5217f71
Author: Hannes Reinecke <hare@suse.de>
Date:   Wed Nov 9 08:39:24 2011 +0100

    [SCSI] Silencing 'killing requests for dead queue'
    
    When we tear down a device we try to flush all outstanding
    commands in scsi_free_queue(). However the check in
    scsi_request_fn() is imperfect as it only signals that
    we _might start_ aborting commands, not that we've actually
    aborted some.
    So move the printk inside the scsi_kill_request function,
    this will also give us a hint about which commands are aborted.
    
    Signed-off-by: Hannes Reinecke <hare@suse.de>
    Signed-off-by: James Bottomley <JBottomley@Parallels.com>


