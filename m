Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab1LVMUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 07:20:45 -0500
Received: from edison.jonmasters.org ([173.255.233.168]:37838 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab1LVMU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 07:20:26 -0500
Message-ID: <1324556423.15180.9.camel@constitution.bos.jonmasters.org>
From: Jon Masters <jonathan@jonmasters.org>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: linux-modules <linux-modules@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Martin Sivak <msivak@redhat.com>
Date: Thu, 22 Dec 2011 07:20:23 -0500
In-Reply-To: <CAMOw1v6_19WNnRw-vZdypfoJQT0wTjDVDLAfiWL=cnaNhTffAw@mail.gmail.com>
References: <CAMOw1v5r8CqO3zWdw9YzhjJVcU7QntwLEeJECbgcU-f3ATWUSQ@mail.gmail.com>
	 <CAMOw1v6_19WNnRw-vZdypfoJQT0wTjDVDLAfiWL=cnaNhTffAw@mail.gmail.com>
Organization: World Organi{s,z}ation of Broken Dreams
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Fedora package for kmod [WAS: Re: [ANNOUNCE] kmod 2]
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 00:35 -0200, Lucas De Marchi wrote:

> http://packages.profusion.mobi/kmod/kmod-2.tar.xz

> I'm glad to announce the second version of kmod. I'm sorry for not
> sending the announcement on this mailing list for the first version.
> For those who didn't see the first announcement can check at
> http://lwn.net/Articles/472354/.

Hello everyone,

I have taken the liberty of packaging kmod for use with Fedora. I have
not yet done a lot of testing, so the usual disclaimers apply, etc. If
you don't want to read the below and just want to try it, consider
placing the following content into /etc/yum.repos.d/kmod.repo:

[kmod]
name=kmod test packages
failovermethod=priority
baseurl=http://jcm.fedorapeople.org/kmod/packages/$releasever/
enabled=1
gpgcheck=0

(currently works for F16 and rawhide on x86_64, more coming)

Then you just need to do:

$ yum install kmod

After that, you will find new binaries with kmod- prefixes:

$ kmod-lsmod
$ kmod-modprobe
$ ...

That's enough if you just want to try it out. I'll keep these packages
up to date in collaboration with Martin when new kmod releases are done,
so you can leave that repo installed and get updates if you like, etc. 

More detailed stuff
-------------------

I have tried to generally follow the latest and greatest Fedora
packaging guidelines, but this is not ready for official review, there
are things I need to fix, and I need to test the pkgconfig and make sure
the devel package actually works (did not get there yet tonight - but
that stuff is next on the list). If you want to help with that, an
interim repo for the SPEC used to stash this packaging stuff is in the
following location just for the moment, and fixes are very welcome:

$ git clone git://fedorapeople.org/~jcm/kmod/kmod-rpm.git

(look for "TODO" lines in the SPEC to see things that need poking at)

The goal with this packaging is to work with Martin Sivak and a few
others on the Fedora end to get the kmod package into a shape and tested
to a level in which it can relatively soon and transparently replace the
existing module-init-tools package. Initially, the binaries have the
kmod- prefix for easy parallel testing (just link or copy the files,
etc.) but we will of course rename them later. At that time, the old
package can be obsoleted and replaced with three new (sub)packages.

As far as testing goes, I'm going to be poking further at x86_64 and
ARM, and I will also kick off some RHEL6 builds for ppc64 and s390x for
fun, because I don't yet have an up-to-date Fedora install on my POWER
box at home. I will ping other secondary arch folks and ask them to also
take a look because I am keen that some good Big Endian testing be done
to offset all that x86. Obviously, the weirder the setup, the better.

NOTE: For now, I have caused the binaries to be installed into /sbin,
and the library into /lib(64) in the spirit of the existing locations. I
am aware of the general intentions in Fedora around changing filesystem
layouts but just in the first cut, I'm keeping life simple(ish).

Thanks everyone! (and Happy Holidays!)

Jon.


