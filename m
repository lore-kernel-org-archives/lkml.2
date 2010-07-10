Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab0GJP5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 11:57:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:33561 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab0GJP5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 11:57:07 -0400
Date: Sat, 10 Jul 2010 09:00:55 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@lists.linux-foundation.org, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH] pm: Add runtime PM statistics to sysfs
Message-ID: <20100710090055.119f77fd@infradead.org>
In-Reply-To: <Pine.LNX.4.44L0.1007091106070.1582-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1007091056510.1582-100000@iolanthe.rowland.org>
	<Pine.LNX.4.44L0.1007091106070.1582-100000@iolanthe.rowland.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010 11:11:06 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Fri, 9 Jul 2010, Alan Stern wrote:
> 
> > On Thu, 8 Jul 2010, Arjan van de Ven wrote:
> > 
> > > From: Arjan van de Ven <arjan@linux.intel.com>
> > > Subject: pm: Add runtime PM statistics to sysfs
> > > 
> > > In order for PowerTOP to be able to report how well the new
> > > runtime PM is working for the various drivers, the kernel needs
> > > to export some basic statistics in sysfs.
> > > 
> > > This patch adds two sysfs files in the runtime PM domain that
> > > expose the total time a device has been active, and the time a
> > > device has been suspended.
> > > 
> > > With this PowerTOP can compute the activity percentage
> > > 
> > > Active %age = 100 * (delta active) / (delta active + delta
> > > suspended)
> > > 
> > > and present the information to the user.
> > > 
> > > I've written the PowerTOP code (slated for version 1.12) already,
> > > and the output looks like this:
> > > 
> > > Runtime Device Power Management statistics
> > > Active  Device name
> > >  10.0%	06:00.0 Ethernet controller: Realtek Semiconductor
> > > Co., Ltd. RTL8101E/RTL8102E
> > 
> > 
> > > @@ -411,6 +433,7 @@ int __pm_runtime_resume(struct device *dev,
> > > bool from_wq) }
> > >  
> > >  	if (retval) {
> > > +		update_pm_runtime_accounting(dev);
> > >  		dev->power.runtime_status = RPM_SUSPENDED;
> > >  		pm_runtime_cancel_pending(dev);
> > >  	} else {
> > 
> > This line was added in the wrong place.  It belongs either before
> > the "if (retval) {" or after the "} else {".
> 
> Whoops, sorry, my mistake.  It doesn't belong here at all.  It
> belongs considerably earlier in the function, before the line:

you are correct.

I'll fix it, I think I'll make a small helper that does the account and
assignment in one place, so that we then can have a rule that nobody
updates this field without calling the function


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
