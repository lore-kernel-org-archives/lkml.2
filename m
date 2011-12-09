Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1LIA4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:56:41 -0500
Received: from blackhole.sdinet.de ([176.9.52.58]:38259 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab1LIA4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:56:39 -0500
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Dec 2011 19:56:39 EST
Date: Fri, 9 Dec 2011 01:49:35 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Colin Walters <walters@verbum.org>
cc: John Stoffel <john@stoffel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: chroot(2) and bind mounts as non-root
In-Reply-To: <1323368800.10724.73.camel@lenny>
Message-ID: <alpine.DEB.2.02.1112090143210.5366@aurora.sdinet.de>
References: <1323280461.10724.13.camel@lenny>  <20191.49202.793643.397028@quad.stoffel.home>  <1323360655.10724.35.camel@lenny>  <20192.65168.140290.462594@quad.stoffel.home> <1323368800.10724.73.camel@lenny>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Dec 2011, Colin Walters wrote:

> On Thu, 2011-12-08 at 13:14 -0500, John Stoffel wrote:
> 
> > Or is it because you're trying to edit on one OS, such a fedora 14,
> > then build and debug inside an Debian 5.0 setup?  But without running
> > a completely seperate system, but just doing a chroot into a new
> > filesystem tree?  
> 
> Yes, something like that; basically it's about ensuring that the libfoo
> we're building binaries against is /home/walters/build/libfoo.so and
> not /usr/lib/libfoo.so.
> 
> I'm actually intending for the core build system of my OS to work in
> *both* cross and native compilation.  That means it's important to keep
> them as close as possible.
> 
> What you were talking about above (i.e. "just don't chroot") is what
> http://buildroot.net does (and others, I also semi-maintain GNOME's
> jhbuild).  It works if you're very careful in your build scripts, know
> and carefully propagate the large set of magic environment variables,
> etc., then yes, you can do it.
> 
> But chroot is just so nice a hammer for this nail.

For Debian there is schroot ("securely enter a chroot environment"), 
which nicely encapsulates entering pre-prepared chroots as a user (with 
a suid root program), setting up bind mounts, etc etc, and in the end 
landing inside the chroot as the calling user (if you have the 
permissions).

I use this to have build environments for a couple old older Debian 
releases and both 32+64 bit available on a single 64bit machine.

Source is available at git://git.debian.org/git/buildd-tools/schroot.git

Can't think of it only working on a Debian - maybe give it a try.

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
