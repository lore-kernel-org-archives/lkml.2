Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab0KMOsL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 09:48:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59249 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab0KMOsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 09:48:07 -0500
Date: Sat, 13 Nov 2010 06:39:08 -0800
From: Greg KH <gregkh@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Eric Biederman <ebiederm@aristanetworks.com>,
        Stefan Achatz <stefan_achatz@web.de>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Thery <benjamin.thery@bull.net>
Subject: Re: [PATCH 2/2] HID: roccat: using new sysfs_create_bin_group() in
	kone driver
Message-ID: <20101113143908.GA29750@suse.de>
References: <1289585921.2629.13.camel@neuromancer> <AANLkTik4qPyBtKgJwHVnhkTASNORoKrWms6gk8NirYeU@mail.gmail.com> <20101113005232.GA20865@suse.de> <20101113060634.GB1919@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101113060634.GB1919@core.coreip.homeip.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 10:06:34PM -0800, Dmitry Torokhov wrote:
> On Fri, Nov 12, 2010 at 04:52:32PM -0800, Greg KH wrote:
> > On Fri, Nov 12, 2010 at 04:21:45PM -0800, Eric Biederman wrote:
> > > On Fri, Nov 12, 2010 at 10:18 AM, Stefan Achatz <stefan_achatz@web.de> wrote:
> > > > hid-roccat-kone now uses new group functions for creating binary
> > > > sysfs attributes.
> > > 
> > > Looking at this, I have a problem with the way this works.
> > > You are still doing this the hard and racy way.
> > > 
> > > sysfs attributes that are only added when we initialize the hardware and
> > > are only removed when we remove the driver should use the device layer
> > > functions to create their attributes.
> > > 
> > > This achieves two things.  The code is easier to write because there
> > > is less of it.
> > > The notification to user space happens after the attributes appear so
> > > that you don't
> > > have strange hotplug races.
> > > 
> > > If there a chance you can look at implementing this in the simpler
> > > race free way?
> > 
> > Good point, just attach this attribute group to the device and the
> > driver core will automatically create the files for you.
> > 
> 
> Attribute group in device structure is normally owned and managed by
> subsystem core; without additional plumbing drivers should not be
> touching it, at least not normally.
> 
> Plus we do not have binary attribute group in device structure [yet].

In thinking about it a bit more, why do you have so many binary
attributes for this driver?  binary sysfs files are rare, so adding a
binary attribute group pointer to the device or driver would just waste
a lot of space that no one else uses.

What are these binary files for?  Who uses them?  I don't seem to be
able to find them in the Documentation/ABI directory, or am I missing
something here?

thanks,

greg k-h
