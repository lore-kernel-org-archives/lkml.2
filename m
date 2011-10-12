Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1JLPIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 11:08:39 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:54597 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753095Ab1JLPIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 11:08:38 -0400
Date: Wed, 12 Oct 2011 15:08:47 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: david@lang.hm
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Theodore Tso <tytso@MIT.EDU>,
        Matt Helsley <matthltc@us.ibm.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        harald@redhat.com, david@fubar.dk, greg@kroah.com,
        Linux Containers <containers@lists.osdl.org>,
        Linux Containers <lxc-devel@lists.sourceforge.net>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: Detecting if you are running in a container
Message-ID: <20111012150847.GA21061@hallyn.com>
References: <m1mxd8lg0x.fsf_-_@fess.ebiederm.org>
 <20111011013201.GA7948@thunk.org>
 <20111011020530.GG16723@count0.beaverton.ibm.com>
 <20111011032523.GB7948@thunk.org>
 <m1ty7ghvvn.fsf@fess.ebiederm.org>
 <203BBB0D-293D-4BFB-A57B-41C56F58F9B3@mit.edu>
 <m17h4bfcuv.fsf@fess.ebiederm.org>
 <alpine.DEB.2.02.1110111525450.28233@asgard.lang.hm>
 <m139eyg7if.fsf@fess.ebiederm.org>
 <alpine.DEB.2.02.1110112208230.12310@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1110112208230.12310@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting david@lang.hm (david@lang.hm):
> On Tue, 11 Oct 2011, Eric W. Biederman wrote:
> 
> >david@lang.hm writes:
> >
> >>On Tue, 11 Oct 2011, Eric W. Biederman wrote:
> >>
> >>>Theodore Tso <tytso@MIT.EDU> writes:
> >>>
> >>>>On Oct 11, 2011, at 2:42 AM, Eric W. Biederman wrote:
> >>>>
> >>>I admit for a lot of test cases that it makes sense not to use a full
> >>>set of userspace daemons.  At the same time there is not particularly
> >>>good reason to have a design that doesn't allow you to run a full
> >>>userspace.
> >>
> >>how do you share the display between all the different containers if they are
> >>trying to run the X server?
> >
> >Either X does not start because the hardware it needs is not present or
> >Xnest or similar gets started.
> >
> >>how do you avoid all the containers binding to the same port on the default IP
> >>address?
> >
> >Network namespaces.
> >
> >>how do you arbitrate dbus across the containers.
> >
> >Why should you?
> 
> because the containers are simulating different machines, and dbus
> doesn't work arcross different machines.

Exactly - Eric is saying dbus should not be (and is not) shared among
containers.

> >>when a new USB device gets plugged in, which container gets control of
> >>it?
> >
> >None of them.  Although today they may all get the uevent.  None of the
> >containers should have permission to call mknod to mess with it.
> 
> why would the software inside a container not have the rights to do
> a mknod inside the container?

Why shouldn't an unprivileged user be allowed to mknod on the host?

-serge
