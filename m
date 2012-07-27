Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab2G0U1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 16:27:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:17130 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab2G0U1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 16:27:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="187950809"
Date: Fri, 27 Jul 2012 16:26:55 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Keith Busch <keith.busch@intel.com>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] NVMe: Add a character device for each nvme device
Message-ID: <20120727202655.GP22985@linux.intel.com>
References: <1343407458-29909-1-git-send-email-keith.busch@intel.com>
 <20120727181212.GM22985@linux.intel.com>
 <5012EBD9.8010602@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5012EBD9.8010602@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 03:28:25PM -0400, Jeff Garzik wrote:
> On 07/27/2012 02:12 PM, Matthew Wilcox wrote:
> >On Fri, Jul 27, 2012 at 10:44:18AM -0600, Keith Busch wrote:
> >>Registers a character device for the nvme module and creates character
> >>files as /dev/nvmeN for each nvme device probed, where N is the device
> >>instance. The character devices support nvme admin ioctl commands so
> >>that nvme devices without namespaces can be managed.
> >
> >I don't see a problem here, but I'm no expert at sysfs / character devices.
> >Alan, Greg, anyone else see any problems with how this character device is
> >created / destroyed?
> 
> This seems like something normally done via a control device that is
> addressible via bsg.

I'm not convinced about that.  bsg requires a request_queue, and we
don't have one in the absence of any storage.  There doesn't even seem
to be a standard way of sending commands to SCSI hosts, let alone block
device controllers.

Maybe we should design such a mechanism, but maybe we shouldn't ... as we
find common things to do, we tend to move those to sysfs, not ioctls,
and the kinds of commands that are being sent here are essentially
vendor-specific NVMe commands; it's not clear they'd fit neatly into a
generic mechanism.

> This is -not- a NAK, but maybe the storage folks have a different
> preference for an admin-command path.
> 
> 	Jeff
> 
