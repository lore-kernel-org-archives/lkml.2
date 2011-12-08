Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab1LHSOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 13:14:43 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:48088 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1LHSOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 13:14:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20192.65168.140290.462594@quad.stoffel.home>
Date: Thu, 8 Dec 2011 13:14:40 -0500
From: "John Stoffel" <john@stoffel.org>
To: Colin Walters <walters@verbum.org>
Cc: John Stoffel <john@stoffel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: chroot(2) and bind mounts as non-root
In-Reply-To: <1323360655.10724.35.camel@lenny>
References: <1323280461.10724.13.camel@lenny>
	<20191.49202.793643.397028@quad.stoffel.home>
	<1323360655.10724.35.camel@lenny>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Colin" == Colin Walters <walters@verbum.org> writes:

Colin> On Wed, 2011-12-07 at 14:36 -0500, John Stoffel wrote:
>> >>>>> "Colin" == Colin Walters <walters@verbum.org> writes:
>> 
Colin> I've recently been doing some work in software compilation, and it'd be
Colin> really handy if I could call chroot(2) as a non-root user.  The reason
Colin> to chroot is to help avoid "host contamination" - I can set up a build
Colin> root and then chroot in.  The reason to do it as non-root is, well,
Colin> requiring root to build software sucks for multiple obvious reasons.
>> 
>> What's wrong with using 'fakeroot' or tools like that instead? 

Colin> I assume you mean
Colin> "fakechroot" ( https://github.com/fakechroot/fakechroot/wiki )

Nah, I'm a doofus and mis-remembered about how fakeroot works to just
fake 'root' access for installers and such.  

Colin> The answer is twofold:

Colin> 1) It's a pile of gross hacks that can easily be buggy, and will be
Colin> permanently trying to keep up with newer system calls.
Colin> 2) It's slower.  My edit-compile-debug cycle REALLY matters to me.  If
Colin> you're a developer, it should matter to you - it directly impacts your
Colin> productivity.

Sure I can understand that, but why does your compiler need to be in a
chroot'd area?  If you're doing a cross compile, then just change the
tool chain.

Colin> How much slower?  Okay, well I tried "fakechroot" from Fedora 15.  It
Colin> appears to break parallel make.  Which obviously already disqualifies it
Colin> from being a core part of my edit-compile-debug cycle.

Find.

Colin> But here's an example of a small autotools (~6000 significant lines of
Colin> C) project, of which running configure is by far the slowest part.  Note
Colin> 'metabuild' is a trivial script which wraps the
Colin> 'autogen.sh;configure;make' dance:

Colin> $ metabuild   # to prime the caches
Colin> ...
Colin> $ git clean -dfx
Colin> ...
Colin> $ time ostbuild-user-chroot --unshare-ipc --unshare-pid --unshare-net
Colin> --mount-bind /src /src --mount-proc /proc
Colin> --mount-bind /dev /dev / /bin/sh -c 'cd /src/test-project; metabuild'

So what does 'ostbuild-user-chroot' that a simple makefile into a
seperate build area (with source just where it is now) doesn't do for
you?  

Or is it because you're trying to edit on one OS, such a fedora 14,
then build and debug inside an Debian 5.0 setup?  But without running
a completely seperate system, but just doing a chroot into a new
filesystem tree?  

Colin> So it almost exactly doubles...Oh, crap, I just remembered I
Colin> have ccache, so we're really only timing configure runs here.
Colin> Anyways, you get the point.  Doubling my compile time is bad.
Colin> And this is a relatively small project.

I guess I still don't understand why your compile setup requires/wants
a chroot'd area.  Just setup your toolchain without all that hassle.  

Colin> One of the best parts of Linux is the filesystem and VFS - it's
Colin> really amazingly fast compared to other OSes, especially if you
Colin> know how to use it.  Adding in layers of emulation and crap in
Colin> between the program and the filesystem takes that away.

I'm just pushing back because I think you're using a hammer to try and
drive staples or screws.  It sorta works but....

Feel free to ignore my objections, I'm not a core developer by any
means.  

John
