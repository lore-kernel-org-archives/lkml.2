Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab2BHBer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 20:34:47 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53739 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756613Ab2BHBeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 20:34:46 -0500
X-Sasl-enc: LnMqSEij9bo8aP5h8Mij/OF69bZD2ofcBhFnBSUm7HFz 1328664885
Date: Tue, 7 Feb 2012 17:34:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kobject (ffff88003ffbb4b8): tried to init an initialized object,
 something is seriously wrong.
Message-ID: <20120208013438.GA11844@kroah.com>
References: <20120203205953.GA2897@phenom.dumpdata.com>
 <20120203213949.GC8196@kroah.com>
 <20120203214235.GA10549@kroah.com>
 <20120206182040.GA1862@phenom.dumpdata.com>
 <20120206182956.GA13819@kroah.com>
 <20120208003537.GA18258@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120208003537.GA18258@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 07:35:37PM -0500, Konrad Rzeszutek Wilk wrote:
> On Mon, Feb 06, 2012 at 10:29:56AM -0800, Greg KH wrote:
> > On Mon, Feb 06, 2012 at 01:20:40PM -0500, Konrad Rzeszutek Wilk wrote:
> > > On Fri, Feb 03, 2012 at 01:42:35PM -0800, Greg KH wrote:
> > > > On Fri, Feb 03, 2012 at 01:39:49PM -0800, Greg KH wrote:
> > > > > On Fri, Feb 03, 2012 at 03:59:53PM -0500, Konrad Rzeszutek Wilk wrote:
> > > > > > Hey Greg,
> > > > > > 
> > > > > > With or without your previous patch (the one that added an cpu_device_release
> > > > > > function) I am getting this in 3.3-rc2.  I did not get this in 3.2.
> > > > > > 
> > > > > > I added some extra printks to make sure that the handle_vcpu_hotplug_event
> > > > > > code actually did call 'arch_unregister_cpu' which is certainly looks
> > > > > > to be doing.
> > > > > > 
> > > > > > I hadn't done a bisection yet, but was wondering if this is related
> > > > > > to the previous issues with the sysdev. Or kobject getting more observant.
> > > > > 
> > > > > No, it's related to the previous issue, let me knock up a patch to fix
> > > > > this as well...
> > > > 
> > > > Does this patch solve the problem for you?
> > > 
> > > Yeah, no warnings. But neither is the CPU coming back up :-(
> > 
> > Very wierd.
> 
> Found the culprit and have a patch for it. But it does not affect baremetal and
> it was in the drivers/xen/cpu_hotplug.c code - so 
> 
> > 
> > > Thought that might be related to something else  - let me double check
> > > with 3.2 whether there are some race-conditions that I might be hitting.
> > 
> > Ok, I'll wait to queue this up until you get back to me.
> 
> .. you can go ahead and queue it up with my Tested-by tag. Thanks!

Great, will do.
