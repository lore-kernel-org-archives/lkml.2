Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab2GSSNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:13:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32471 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2GSSNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:13:42 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=BHldU6QlfDUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=Goo5scKxAdzUFsmDMooA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342721620.12353.75.camel@gandalf.stny.rr.com>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Date: Thu, 19 Jul 2012 14:13:40 -0400
In-Reply-To: <20120719175649.GF8469@zod.bos.redhat.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
	 <20120713210240.GG1707@redhat.com>
	 <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
	 <20120719152618.GD16873@home.goodmis.org>
	 <20120719154521.GC8469@zod.bos.redhat.com>
	 <1342714088.12353.33.camel@gandalf.stny.rr.com>
	 <20120719171918.GD8469@zod.bos.redhat.com>
	 <1342719222.12353.58.camel@gandalf.stny.rr.com>
	 <20120719175649.GF8469@zod.bos.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 13:56 -0400, Josh Boyer wrote:

> Distros aren't stationary things.

Exactly my point.

>   I mean, some of them certainly aim
> for that goal, but userspace and kernels get upgraded all the time.  So
> if this distro-Kconfig file is provided by some package _other_ than the
> kernel the distros are going to have a bit of a hassle keeping track of
> it.

How about a directory called /usr/share/Linux/Kconfig.d/

Then have anything installed that needs to work correctly put in its
minimum (must have) requirement configs of the kernel.

Say you are running Debian, and decide to try out systemd. If you set up
your system to run that it would add a file called:

/usr/share/Linux/Kconfig.d/systemd.conf

or something, and this would select things like CGROUPS and the like. We
could make the kernel build select all, or individual files in this
directory. All for the 'make my distro work' or individual for a 'I want
part of my distro to work' option.



> Upgraded the kernel within the confines of that distro, right?  So you
> go back to what was already installed and working.  You don't go back
> arbitrarily far just to see what happens.  I would think a reasonably
> crafted distro config would work in those scenarios.

A reasonable one, but still not the minimum.

One issue with Linus's proposal is that he's asking us to focus on the
99%. But the 99% of who? Because 99% of Linux users do not compile their
own kernels, so he must be asking about the 99% of Linux users that
compile their own kernels. This 99% does not just simply compile their
kernels, but only want to compile the absolutely necessary stuff. That
is, they want their kernels not to include anything they are not using.

A reasonable config would probably need to include a lot that's not
used.

-- Steve


