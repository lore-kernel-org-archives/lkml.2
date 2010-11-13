Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0KMQfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 11:35:30 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:42010 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab0KMQf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 11:35:28 -0500
Subject: Re: [PATCH 2/2] HID: roccat: using new sysfs_create_bin_group() in
 kone driver
From: Stefan Achatz <stefan_achatz@web.de>
To: Greg KH <gregkh@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Eric Biederman <ebiederm@aristanetworks.com>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Thery <benjamin.thery@bull.net>
In-Reply-To: <20101113143908.GA29750@suse.de>
References: <1289585921.2629.13.camel@neuromancer>
	 <AANLkTik4qPyBtKgJwHVnhkTASNORoKrWms6gk8NirYeU@mail.gmail.com>
	 <20101113005232.GA20865@suse.de>
	 <20101113060634.GB1919@core.coreip.homeip.net>
	 <20101113143908.GA29750@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Nov 2010 17:34:15 +0100
Message-ID: <1289666055.2191.1.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19/J1s1YrRchtGE+PKu/k4PlMA1OxZ8ZyiWNC0c
	klS+D5oNlbXxbEiqg0pt4PHOnljhqWB9vwl2j/bH1J2LXH143D
	GKj4brZ51FKpULQu1GBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 13.11.2010, 06:39 -0800 schrieb Greg KH:
> On Fri, Nov 12, 2010 at 10:06:34PM -0800, Dmitry Torokhov wrote:
> > On Fri, Nov 12, 2010 at 04:52:32PM -0800, Greg KH wrote:
> > > On Fri, Nov 12, 2010 at 04:21:45PM -0800, Eric Biederman wrote:
> > > > On Fri, Nov 12, 2010 at 10:18 AM, Stefan Achatz <stefan_achatz@web.de> wrote:
> > > > > hid-roccat-kone now uses new group functions for creating binary
> > > > > sysfs attributes.
> > > > 
> > > > Looking at this, I have a problem with the way this works.
> > > > You are still doing this the hard and racy way.
> > > > 
> > > > sysfs attributes that are only added when we initialize the hardware and
> > > > are only removed when we remove the driver should use the device layer
> > > > functions to create their attributes.
> > > > 
> > > > This achieves two things.  The code is easier to write because there
> > > > is less of it.
> > > > The notification to user space happens after the attributes appear so
> > > > that you don't
> > > > have strange hotplug races.
> > > > 
> > > > If there a chance you can look at implementing this in the simpler
> > > > race free way?
> > > 
> > > Good point, just attach this attribute group to the device and the
> > > driver core will automatically create the files for you.
> > > 
> > 
> > Attribute group in device structure is normally owned and managed by
> > subsystem core; without additional plumbing drivers should not be
> > touching it, at least not normally.
> > 
> > Plus we do not have binary attribute group in device structure [yet].
> 
> In thinking about it a bit more, why do you have so many binary
> attributes for this driver?  binary sysfs files are rare, so adding a
> binary attribute group pointer to the device or driver would just waste
> a lot of space that no one else uses.
> 
> What are these binary files for?  Who uses them?  I don't seem to be
> able to find them in the Documentation/ABI directory, or am I missing
> something here?

Documentation/ABI/testing/sysfs-driver-hid-roccat-kone

Stefan

