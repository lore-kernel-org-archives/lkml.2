Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab2KSWst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 17:48:49 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:39664 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab2KSWsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 17:48:47 -0500
Date: Mon, 19 Nov 2012 15:48:45 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Bill Pemberton <wfp5p@virginia.edu>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH 407/493] infiniband: remove use of __devexit
Message-ID: <20121119224845.GB5636@obsidianresearch.com>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
 <1353349642-3677-407-git-send-email-wfp5p@virginia.edu>
 <20121119200921.GD1556@obsidianresearch.com>
 <20121119201938.GA5614@kroah.com>
 <20121119214922.GA5636@obsidianresearch.com>
 <20121119220632.GA1946@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121119220632.GA1946@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 02:06:32PM -0800, Greg KH wrote:

> > 5k isn't a lot, but in the context of 'I have to figure out how to
> > trim ~1MB off the 3.6 kernel to run it in our smallest hardware' it is
> > the wrong direction :(
> 
> It is only 0.138% in the "wrong" direction.  Seriously, that's a very
> tiny percentage here, for an option that people _always_ get wrong, and
> almost no system does not need.  The number of bugs we have had in this
> area is huge, and by fixing this option like this, it takes them all
> away.

Sure, it isn't a lot. I don't have any idea about problems
CONFIG_HOTPLUG causes, but it seems alot of work has gone into making
this option over the years (the patch to remove it is huge), is there
no other way to get what you want?

> Yes, there are going to be exceptions, like yours, that somehow do run
> properly without CONFIG_HOTPLUG enabled.  But really, are you worried
> about 0.138% right now?  The amount of time we just spent writing these
> emails, memory sizes increased this much for your next platform, for the
> same cost as your last platform.

Well, I'm not worried looking forward, as you say, it just doesn't
matter. The systems we designed today have 128M and that was pretty
much the *smallest* dram we could provision.

> Thanks for running the numbers, I appreciate it.  I'm amazed that your
> kernel growth from 2.6.16 to 3.6 is 1Mb.  Why would you want to run the
> 3.6 kernel in a system designed for the 2.6.16 kernel (i.e. one designed
> over 6 _years_ ago)?

I haven't had any time to inspect the 1MB growth, so I can't comment
on what is going on there.. A chunk of that will be some initrd
growth too..

As for why the interest in upgrading? Well, we don't make consumer
products, our stuff has long life cycles and the 6 year old system
continues to be manufactured and sold today.

Our latest platform is ARM based, and we've had to re-spin and re-test
*everything*. The work to bundle PPC along in that effort is fairly
minor, so we are looking at keeping it up-to-date with our unified
firmware.

Regards,
Jason
