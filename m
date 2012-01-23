Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2AWUny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:43:54 -0500
Received: from tango.0pointer.de ([85.214.72.216]:52307 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2AWUnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:43:53 -0500
Date: Mon, 23 Jan 2012 21:43:52 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123204352.GB21822@tango.0pointer.de>
References: <20120123152055.GD25986@redhat.com>
 <20120123153913.GB12652@google.com>
 <20120123155216.GF25986@redhat.com>
 <20120123155745.GD12652@google.com>
 <20120123161042.GG25986@redhat.com>
 <20120123161619.GE12652@google.com>
 <20120123162553.GI25986@redhat.com>
 <20120123171049.GH12652@google.com>
 <20120123182745.GK25986@redhat.com>
 <20120123184336.GI12652@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123184336.GI12652@google.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23.01.12 10:43, Tejun Heo (tj@kernel.org) wrote:

> 
> On Mon, Jan 23, 2012 at 01:27:45PM -0500, Vivek Goyal wrote:
> > > Why can't systemd order elevator switch before other actions?
> > 
> > Because systemd does not know. For systemd it is just launching services
> > and what services are doing is not known to systemd.
> > 
> > I think systemd does have some facilities so that services can express
> > dependency on other services and dependent service blocks on completion
> > of service it is depenent on. So may be in this case any service dealing
> > with cgroups shall have to be dependent on this service which tunes
> > the system and changes elevator.
> 
> I'm sure systemd has enough facility for expressing this dependency.
> Where this configuration belongs to is a different question tho.  I
> don't know how the tuned thing works but configurations like this are
> bound to devices and should be part of device discovery / hotplug
> sequence.  IOW, it should be something which ultimately runs off udev
> events as part of device found event.

I didn't really follow the whole discussion here, but if this is about
adjusting parameters of a block device as the block device shows up this
must necessarily happen in an udev rule (and not in a daemon watching
block devices using libudev), since you most likely need the
synchronicity: i.e. you want to avoid that normal (libudev-using)
userspace code ever sees the device before those params are written to
the device. A daemon asynchronously watching the devices with libudev
for adjusting such tunables is necessarily racy.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
