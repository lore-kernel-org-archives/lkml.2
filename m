Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab1AMOip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:38:45 -0500
Received: from vostochny.stro.at ([78.47.22.85]:41783 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab1AMOim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:38:42 -0500
Date: Thu, 13 Jan 2011 14:38:41 +0000
From: maximilian attems <max@stro.at>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org,
        Ralf =?iso-8859-1?Q?R=F6sch?= <ralf.roesch@rw-gmbh.de>,
        debian-kernel@lists.debian.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] kbuild: create linux-headers package in deb-pkg
Message-ID: <20110113143840.GN20262@vostochny.stro.at>
References: <1293201730-1583-1-git-send-email-tytso@mit.edu> <20101225112026.GF20262@vostochny.stro.at> <20110110174640.GA619@stro.at> <4D2F044E.7060607@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D2F044E.7060607@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 02:55:26PM +0100, Michal Marek wrote:
> On 10.1.2011 18:46, maximilian attems wrote:
> >>> +find . -name Makefile -o -name Kconfig\* -o -name \*.pl > /tmp/files$$
> >>> +find arch/x86/include include scripts -type f >> /tmp/files$$
> >> x86 centric?
> > 
> > this will break on any non x86 arch, what is the correct variable
> > for $ARCH?
> 
> This should be changed to arch/$SRCARCH/include.

thanks for the pointer, sent patch, that was the easy part.
 
 
> >>> +tar -c -f - -T /tmp/files$$ | (cd $destdir; tar -xf -)
> >>> +(cd $objtree; tar -c -f - -T /tmp/objfiles$$) | (cd $destdir; tar -xf -)
> >>> +rm -f /tmp/files$$ /tmp/objfiles$$
> >>> +arch=$(dpkg --print-architecture)
> >>> +
> >>> +cat <<EOF >> debian/control
> >>> +
> >>> +Package: $hdrpackagename
> >>> +Provides: linux-headers, linux-headers-2.6
> >>> +Architecture: $arch
> >> not sure if that will interfere with the new crosscompile feature
> >> of deb-pkg in linux-next.
> > 
> > aboves arch call seems redundant with what we already have.
> 
> Yes, please remove it. 

will look at it again in a calmer moment.

> BTW, here is a bugreport I got privately about
> the very same issue:
> On 12.1.2011 10:02, Ralf Rösch wrote:
> | [...]
> | Attached you will find a patch to complete the build successfully for my
> | mipsel target.
> | The dpkg --print-architecture shows i386 which results in error:
> | dpkg-gencontrol: Fehler: aktuelle Host-Architektur »mipsel« erscheint
> | nicht in der Architekturliste (i386) des Pakets
> | (current host architecture 'mipsel' does not appear in package's list
> i386)
> | so I changed "arch" temporary to "any".
> |
> | It would be nice if it would be possible to make the kernel-headers
> | installable on any host.
> | They are needed very frequently for cross-compiling. (I already possible
> | with dpkg force).

Added Ben Hutchings and d-kernel on Cc. I do not use OOT modules, so
I don't have a strong word on that, but from what I see in Debian
they are arch specific.

-- 
maks
