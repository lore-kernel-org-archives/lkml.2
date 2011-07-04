Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab1GDL1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 07:27:54 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:55528 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab1GDL1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 07:27:51 -0400
Date: Mon, 4 Jul 2011 13:27:27 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: axboe@kernel.dk, James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Message-ID: <20110704112727.GA2557@osiris.boeblingen.de.ibm.com>
References: <1309609482.2554.8.camel@mulgrave>
 <Pine.LNX.4.44L0.1107021320180.14703-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107021320180.14703-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 02, 2011 at 01:37:59PM -0400, Alan Stern wrote:
> The second bug, which hit me but apparently not any of you, is that the 
> request_queue's elevator gets deallocated while it is still in use.  
> That's because __scsi_remove_device() calls scsi_free_queue(), which 
> does blk_cleanup_queue(), which calls elevator_exit(), even though the 
> device file is still open and more requests will be submitted when the 
> file is closed.
> 
> I'm not sure of the right fix for this.  One possibility is to move the 
> scsi_free_queue() call to scsi_device_dev_release_usercontext().  Or 
> maybe the elevator_exit() call should be moved to blk_release_queue().
> 
> Also, I have no idea why this shows up with USB drives but not other 
> SCSI transports.  A fluke of timing?

FWIW, I reported a bug where the request_queue's elevator got deallocated
while it was still in use (fc transport with device hotplug):

http://www.spinics.net/lists/linux-scsi/msg52879.html
