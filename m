Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab1DWPTw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 11:19:52 -0400
Received: from kroah.org ([198.145.64.141]:53498 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab1DWPTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 11:19:51 -0400
Date: Sat, 23 Apr 2011 08:20:55 -0700
From: Greg KH <greg@kroah.com>
To: Greg KH <gregkh@suse.de>
Cc: KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: Hyper-V vmbus driver
Message-ID: <20110423152055.GA29109@kroah.com>
References: <6E21E5352C11B742B20C142EB499E0481C8D35@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110411190708.GA21355@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110411190708.GA21355@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 12:07:08PM -0700, Greg KH wrote:
> > With that patch-set, I think I have addressed all architectural issues that I
> > am aware of.
> > 
> > I was wondering if you would have the time to let me know what else would have
> > to be addressed
> > 
> > in the vmbus driver, before it could be considered ready for exiting staging.
> > As always your help is
> > 
> > greatly appreciated.
> 
> Anyway, yes, I discussed this with Hank last week at the LF Collab
> summit.  I'll look at the vmbus code later this week when I catch up on
> all of my other work (stable, usb, tty, staging, etc.) that has piled up
> during my 2 week absence, and get back to you with what I feel is still
> needed to be done, if anything.

Due to other external issues, my patch backlog is still not gotten
through yet, sorry.  Sometimes "real life" intrudes on the best of
plans.

I'll get to this when I get through the rest of your hv patches, and the
other patches pending that I have in my queues.

But, I would recommend you going through and looking at the code and
verifying that you feel the bus code is "ready".  At a very quick
glance, you should not have individual drivers have to set their 'struct
device' pointers directly, that is something that the bus does, not the
driver.  The driver core will call your bus and your bus will then do
the matching and call the probe function of the driver if needed.

See the PCI driver structure for an example of this if you are curious.
It should also allow you to get rid of that unneeded *priv pointer in
the struct hv_driver.  You should be able to set that structure
constant, like all other busses.  Right now you can not which shows a
design issue.

So, take a look at that and let me know what you think.

thanks,

greg k-h
