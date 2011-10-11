Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1JKDZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:25:35 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45629 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab1JKDZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:25:34 -0400
Date: Mon, 10 Oct 2011 23:25:23 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        harald@redhat.com, david@fubar.dk, greg@kroah.com,
        Linux Containers <containers@lists.osdl.org>,
        Linux Containers <lxc-devel@lists.sourceforge.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: Detecting if you are running in a container
Message-ID: <20111011032523.GB7948@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Matt Helsley <matthltc@us.ibm.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
	harald@redhat.com, david@fubar.dk, greg@kroah.com,
	Linux Containers <containers@lists.osdl.org>,
	Linux Containers <lxc-devel@lists.sourceforge.net>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Daniel Lezcano <daniel.lezcano@free.fr>,
	Paul Menage <paul@paulmenage.org>
References: <1317943022.1095.25.camel@mop>
 <20111007074904.GC16723@count0.beaverton.ibm.com>
 <20111007160113.GB14201@tango.0pointer.de>
 <m17h4g2jqy.fsf@fess.ebiederm.org>
 <20111010163140.GA22191@tango.0pointer.de>
 <m1mxd8lg0x.fsf_-_@fess.ebiederm.org>
 <20111011013201.GA7948@thunk.org>
 <20111011020530.GG16723@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011020530.GG16723@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 07:05:30PM -0700, Matt Helsley wrote:
> Yes, it does detract from the unique advantages of using a container.
> However, I think the value here is not the effeciency of the initial
> system configuration but the fact that it gives users a better place to
> start.
> 
> Right now we're effectively asking users to start with non-working
> and/or unfamiliar systems and repair them until they work.

If things are not working with containers, I would submit to you that
we're doing something wrong(tm).  Things should just work, except that
processes in one container can't use more than their fair share (as
dictated by policy) of memory, CPU, networking, and I/O bandwidth.

Something which is baked in my world view of containers (which I
suspect is not shared by other people who are interested in using
containers) is that given that kernel is shared, trying to use
containers to provide better security isolation between mutually
suspicious users is hopeless.  That is, it's pretty much impossible to
prevent a user from finding one or more zero day local privilege
escalation bugs that will allow a user to break root.  And at that
point, they will be able to penetrate the kernel, and from there,
break security of other processes.

So if you want that kind of security isolation, you shouldn't be using
containers in the first place.  You should be using KVM or Xen, and
then only after spending a huge amount of effort fuzz testing the
KVM/Xen paravirtualization interfaces.  So at least in my mind, adding
vast amounts of complexities to try to provide security isolation via
containers is really not worth it.  And if that's the model, then it's
a lot easier to make containers to run jobs in containers that don't
require changes to the distro plus huge increase of complexity for
containers in the kernel....

						- Ted
