Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab1GHOML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 10:12:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44521 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750847Ab1GHOMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 10:12:07 -0400
Date: Fri, 8 Jul 2011 10:12:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: 3.0-rc6: USB khubd deadlock when hub is powered down
In-Reply-To: <20110707235647.13264b8a@stein>
Message-ID: <Pine.LNX.4.44L0.1107081005080.2208-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011, Stefan Richter wrote:

> > > On a general level, the last few kernel.org releases have all been rather
> > > weak.  Dissatisfied,
> > 
> > For USB regressions or the kernel overall?
> 
> Kernel overall.  USB unplug issues have been there before, but not as
> reproducible as this one now.  (Which is apparently fixed for me now.)
> 
> I felt compelled to comment on Alan's sentence though because this does
> not sound like the 2.6 development approach at all.  (Some other
> subsystem projects, outside USB, ignore that approach anyway and work 2.5
> style.)

In general, adding support for USB-3.0 has been a tremendous job (of 
which Sarah has done the lion's share of the work), involving not just 
adding a new driver but also making significant changes to the 
subsystem core.  Those changes have been sufficiently complicated that 
things haven't settled down yet.

Particularly since it has now become clear that a key implementation
decision (to allocate periodic bandwidth dynamically, as it is used,
rather than statically) needs to be reversed.  The fan-out effects from
this will require changes to several other drivers as well, and this is 
all still in the design stage.  Thus, we are forced to limp along with 
a hacky, not-entirely-correct implementation until everything can be 
put right.  I don't expect this to happen quickly.

Alan Stern

