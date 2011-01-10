Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab1AJRqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:46:46 -0500
Received: from vostochny.stro.at ([78.47.22.85]:43244 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab1AJRqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:46:43 -0500
Date: Mon, 10 Jan 2011 18:46:40 +0100
From: maximilian attems <max@stro.at>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: create linux-headers package in deb-pkg
Message-ID: <20110110174640.GA619@stro.at>
References: <1293201730-1583-1-git-send-email-tytso@mit.edu>
 <20101225112026.GF20262@vostochny.stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101225112026.GF20262@vostochny.stro.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems review went unnoticed, due to using signature.

On Sat, 25 Dec 2010, maximilian attems wrote:
> > +# Build header package
> > +find . -name Makefile -o -name Kconfig\* -o -name \*.pl > /tmp/files$$
> > +find arch/x86/include include scripts -type f >> /tmp/files$$
> x86 centric?

this will break on any non x86 arch, what is the correct variable
for $ARCH?

> > +(cd $objtree; find .config Module.symvers include scripts -type f >> /tmp/objfiles$$)
> > +destdir=$hdrdir/usr/src/linux-headers-$version
> > +mkdir -p "$destdir" "$hdrdir/DEBIAN" "$hdrdir/usr/share/doc/$hdrpackagename"
> could move up to the other mkdir calls.

we did that already.

> > +tar -c -f - -T /tmp/files$$ | (cd $destdir; tar -xf -)
> > +(cd $objtree; tar -c -f - -T /tmp/objfiles$$) | (cd $destdir; tar -xf -)
> > +rm -f /tmp/files$$ /tmp/objfiles$$
> > +arch=$(dpkg --print-architecture)
> > +
> > +cat <<EOF >> debian/control
> > +
> > +Package: $hdrpackagename
> > +Provides: linux-headers, linux-headers-2.6
> > +Architecture: $arch
> not sure if that will interfere with the new crosscompile feature
> of deb-pkg in linux-next.

aboves arch call seems redundant with what we already have.

> > +Description: Linux kernel headers for $KERNELRELEASE on $arch
> > + This package provides kernel header files for $KERNELRELEASE on $arch
> > + .
> > + This is useful for people who need to build external modules
> > +EOF
> > +
> > +create_package "$hdrpackagename" "$hdrdir"
> > +
> >  # Do we have firmware? Move it out of the way and build it into a package.
> >  if [ -e "$tmpdir/lib/firmware" ]; then
> >  	mv "$tmpdir/lib/firmware" "$fwdir/lib/"

-- 
maks
