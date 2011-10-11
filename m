Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab1JKWa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 18:30:56 -0400
Received: from mail.lang.hm ([64.81.33.126]:46917 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab1JKWaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 18:30:55 -0400
Date: Tue, 11 Oct 2011 15:30:25 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Theodore Tso <tytso@MIT.EDU>, Matt Helsley <matthltc@us.ibm.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        harald@redhat.com, david@fubar.dk, greg@kroah.com,
        Linux Containers <containers@lists.osdl.org>,
        Linux Containers <lxc-devel@lists.sourceforge.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: Detecting if you are running in a container
In-Reply-To: <m17h4bfcuv.fsf@fess.ebiederm.org>
Message-ID: <alpine.DEB.2.02.1110111525450.28233@asgard.lang.hm>
References: <1317943022.1095.25.camel@mop> <20111007074904.GC16723@count0.beaverton.ibm.com> <20111007160113.GB14201@tango.0pointer.de> <m17h4g2jqy.fsf@fess.ebiederm.org> <20111010163140.GA22191@tango.0pointer.de> <m1mxd8lg0x.fsf_-_@fess.ebiederm.org>
 <20111011013201.GA7948@thunk.org> <20111011020530.GG16723@count0.beaverton.ibm.com> <20111011032523.GB7948@thunk.org> <m1ty7ghvvn.fsf@fess.ebiederm.org> <203BBB0D-293D-4BFB-A57B-41C56F58F9B3@mit.edu> <m17h4bfcuv.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011, Eric W. Biederman wrote:

> Theodore Tso <tytso@MIT.EDU> writes:
>
>> On Oct 11, 2011, at 2:42 AM, Eric W. Biederman wrote:
>>
>>> I am totally in favor of not starting the entire world.  But just
>>> like I find it convienient to loopback mount an iso image to see
>>> what is on a disk image.  It would be handy to be able to just
>>> download a distro image and play with it, without doing anything
>>> special.
>>
>> Agreed, but what's wrong with firing up KVM to play with a distro
>> image?  Personally, I don't consider that "doing something special".
>
> Then let me flip this around and give a much more practical use case.
> Testing.  A very interesting number of cases involve how multiple
> machines interact.  You can test a lot more logical machines interacting
> with containers than you can with vms.  And you can test on all the
> aritectures and platforms linux supports not just the handful that are
> well supported by hardware virtualization.

but in containers, you are not really testing lots of machines, you are 
testing lots of processes on the same machine (they share the same kernel)

> I admit for a lot of test cases that it makes sense not to use a full
> set of userspace daemons.  At the same time there is not particularly
> good reason to have a design that doesn't allow you to run a full
> userspace.

how do you share the display between all the different containers if they 
are trying to run the X server?

how do you avoid all the containers binding to the same port on the 
default IP address?

how do you arbitrate dbus across the containers.

when a new USB device gets plugged in, which container gets control of it?

there are a LOT of hard questions when you start talking about running a 
full system inside a container that do not apply for other use of 
containers.

David Lang
