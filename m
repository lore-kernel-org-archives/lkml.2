Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab1AMNza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:55:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:57805 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab1AMNz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:55:28 -0500
Message-ID: <4D2F044E.7060607@suse.cz>
Date: Thu, 13 Jan 2011 14:55:26 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: maximilian attems <max@stro.at>
Cc: linux-kbuild@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Ralf_R=F6sch?= <ralf.roesch@rw-gmbh.de>
Subject: Re: [PATCH] kbuild: create linux-headers package in deb-pkg
References: <1293201730-1583-1-git-send-email-tytso@mit.edu> <20101225112026.GF20262@vostochny.stro.at> <20110110174640.GA619@stro.at>
In-Reply-To: <20110110174640.GA619@stro.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.1.2011 18:46, maximilian attems wrote:
> Seems review went unnoticed, due to using signature.

Oh, indeed, I thought that was just full-quote in your email, sorry.

> On Sat, 25 Dec 2010, maximilian attems wrote:
>>> +# Build header package
>>> +find . -name Makefile -o -name Kconfig\* -o -name \*.pl > /tmp/files$$
>>> +find arch/x86/include include scripts -type f >> /tmp/files$$
>> x86 centric?
> 
> this will break on any non x86 arch, what is the correct variable
> for $ARCH?

This should be changed to arch/$SRCARCH/include.


>>> +(cd $objtree; find .config Module.symvers include scripts -type f >> /tmp/objfiles$$)
>>> +destdir=$hdrdir/usr/src/linux-headers-$version
>>> +mkdir -p "$destdir" "$hdrdir/DEBIAN" "$hdrdir/usr/share/doc/$hdrpackagename"
>> could move up to the other mkdir calls.
> 
> we did that already.
> 
>>> +tar -c -f - -T /tmp/files$$ | (cd $destdir; tar -xf -)
>>> +(cd $objtree; tar -c -f - -T /tmp/objfiles$$) | (cd $destdir; tar -xf -)
>>> +rm -f /tmp/files$$ /tmp/objfiles$$
>>> +arch=$(dpkg --print-architecture)
>>> +
>>> +cat <<EOF >> debian/control
>>> +
>>> +Package: $hdrpackagename
>>> +Provides: linux-headers, linux-headers-2.6
>>> +Architecture: $arch
>> not sure if that will interfere with the new crosscompile feature
>> of deb-pkg in linux-next.
> 
> aboves arch call seems redundant with what we already have.

Yes, please remove it. BTW, here is a bugreport I got privately about
the very same issue:
On 12.1.2011 10:02, Ralf Rösch wrote:
| [...]
| Attached you will find a patch to complete the build successfully for my
| mipsel target.
| The dpkg --print-architecture shows i386 which results in error:
| dpkg-gencontrol: Fehler: aktuelle Host-Architektur »mipsel« erscheint
| nicht in der Architekturliste (i386) des Pakets
| (current host architecture 'mipsel' does not appear in package's list
i386)
| so I changed "arch" temporary to "any".
|
| It would be nice if it would be possible to make the kernel-headers
| installable on any host.
| They are needed very frequently for cross-compiling. (I already possible
| with dpkg force).

Michal
