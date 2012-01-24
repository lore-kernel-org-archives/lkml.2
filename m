Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab2AXRZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 12:25:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932Ab2AXRZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 12:25:25 -0500
Date: Tue, 24 Jan 2012 09:22:31 -0800
From: Greg KH <gregkh@suse.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Simon Glass <sjg@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH] usb: Use a workqueue in usb_add_hcd() to reduce boot time
Message-ID: <20120124172231.GA27273@suse.de>
References: <CAPnjgZ0-VdAzudGFopBd+5j4HhOp10C=x0kPuJEZyaYSzwjBAA@mail.gmail.com>
 <Pine.LNX.4.44L0.1201211055180.24505-100000@netrider.rowland.org>
 <20120124165711.GC3836@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124165711.GC3836@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 05:57:11PM +0100, Sebastian Andrzej Siewior wrote:
> * Alan Stern | 2012-01-21 11:11:09 [-0500]:
> 
> >Doing time-consuming things later won't make any difference.  That is,
> >suppose the boot sequence performs activities A and B, where A takes a
> >long time.  Doing A later, so that the boot sequence performs B and
> >then A, won't change the total time required.
> 
> That is true. However if you show the gui _now_ and look for USB later
> then it feels faster and this is usually enough.

Which has been done before, with great success (i.e. we did it for
Moblin boot times), so it shouldn't be that big of an issue.

Which points out the question, exactly what is the issue here?  We have
"multithreaded" pci driver startup for a long time now, did that stop
working here?  If you use bootchart, does it show that the USB host
driver is stoping the machine from proceeding to the next stage in the
boot process?

>From my experience, I never saw the USB host controller get in the way
at all, it was always somethine else happening that caused problems
(i.e. video.)

Simon, do you have boot charts anywhere showing this?

thanks,

greg k-h
