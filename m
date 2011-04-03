Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1DCTkJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 15:40:09 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:56739 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752549Ab1DCTkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 15:40:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=StU3uu3sK93LtRfoL3cBRvbtmL4dyek0sTzJ8aafUBtKPGMqJBBEPCeLCuo9P7IKSyA7yCssTZfUl0pNCwRiS24SXzJ9xahbdcc8ZktL06inru6vwVIheT3xapB0cPno;
Date: Sun, 3 Apr 2011 12:40:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andreas Mohr <andi@lisas.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: [PATCH] eradicate bashisms in scripts/patch-kernel
Message-Id: <20110403124004.293c90c5.rdunlap@xenotime.net>
In-Reply-To: <20110403185828.GA4561@rhlx01.hs-esslingen.de>
References: <20071101221606.GA10116@rhlx01.hs-esslingen.de>
	<20071101160857.6e877307.rdunlap@xenotime.net>
	<20071102020118.GA13852@gondor.apana.org.au>
	<20071102200935.GA14153@rhlx01.hs-esslingen.de>
	<20071102131707.6023a5b7.rdunlap@xenotime.net>
	<20071105195827.GA24117@rhlx01.hs-esslingen.de>
	<20071114144627.8628f2dd.rdunlap@xenotime.net>
	<20071117163327.GA4296@rhlx01.hs-esslingen.de>
	<20071117172816.GC7213@uranus.ravnborg.org>
	<20071117205125.GA26425@rhlx01.hs-esslingen.de>
	<20110403185828.GA4561@rhlx01.hs-esslingen.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Apr 2011 20:58:28 +0200 Andreas Mohr wrote:

> Silence a remaining annoying (or worse, irritating - "is my entire patched tree
> broken now!?") bashism-related message that occurs when /bin/sh is configured
> to instead deploy dash, a POSIX-compliant shell, as is the pretty much
> standard case on e.g. Debian.
> 
> # linux-2.6.38.patch-kernel_test/scripts/patch-kernel linux-2.6.38.patch-kernel_test patch-2.6
> Current kernel version is 2.6.38 ( Flesh-Eating Bats with Fangs)
> ===>  linux-2.6.38.patch-kernel_test/scripts/patch-kernel: line 253: [: =: unary operator expected  <===
> cannot find patch file: patch-2.6.39

Hi,

Are you trying to update a 2.6.38 kernel directory to 2.6.39?
I'm a little confused since the command line does not say anything about 2.6.39.

> ---
> 
> Debug log of uncorrected script:
> 
> # sh -x linux-2.6.38.patch-kernel_test/scripts/patch-kernel linux-2.6.38.patch-kernel_test patch-2.6
> + PNAME=patch-kernel
> + sourcedir=linux-2.6.38.patch-kernel_test
> + patchdir=patch-2.6
> + stopvers=default
> + '[' linux-2.6.38.patch-kernel_test = -h -o linux-2.6.38.patch-kernel_test = --help -o '!' -r linux-2.6.38.patch-kernel_test/Makefile ']'
> + for PARM in '$*'
> + case $PARM in
> + for PARM in '$*'
> + case $PARM in
> ++ mktemp ./.tmpver.XXXXXX
> + TMPFILE=./.tmpver.2Yv11Y
> + grep -E '^(VERSION|PATCHLEVEL|SUBLEVEL|EXTRAVERSION)' linux-2.6.38.patch-kernel_test/Makefile
> + tr -d '[:blank:]'
> + . ./.tmpver.2Yv11Y.1
> ++ VERSION=2
> ++ PATCHLEVEL=6
> ++ SUBLEVEL=38
> ++ EXTRAVERSION=
> + rm -f ./.tmpver.2Yv11Y ./.tmpver.2Yv11Y.1
> + '[' -z 2 -o -z 6 -o -z 38 ']'
> ++ grep '^NAME' linux-2.6.38.patch-kernel_test/Makefile
> + NAME='NAME = Flesh-Eating Bats with Fangs'
> + NAME=' Flesh-Eating Bats with Fangs'
> + echo 'Current kernel version is 2.6.38 ( Flesh-Eating Bats with Fangs)'
> Current kernel version is 2.6.38 ( Flesh-Eating Bats with Fangs)
> + EXTRAVER=
> + '[' x '!=' x ']'
> + '[' default '!=' default ']'
> + STOPSUBLEVEL=9999
> + STOPEXTRA=9999
> + '[' 9999 -lt 38 ']'
> + '[' x '!=' x ']'
> + CURRENTFULLVERSION=2.6.38
> + '[' x '!=' x ']'
> + '[' 9999 -gt 38 ']'
> + :
> + CURRENTFULLVERSION=2.6.38
> + EXTRAVER=
> + '[' = 2.6.38 ']'
> linux-2.6.38.patch-kernel_test/scripts/patch-kernel: line 253: [: =: unary operator expected
> + SUBLEVEL=39
> + FULLVERSION=2.6.39
> + '[' 39 -gt 9999 ']'
> + patch=patch-2.6.39
> + findFile patch-2.6/patch-2.6.39
> + filebase=patch-2.6/patch-2.6.39
> + '[' -r patch-2.6/patch-2.6.39.gz ']'
> + '[' -r patch-2.6/patch-2.6.39.bz ']'
> + '[' -r patch-2.6/patch-2.6.39.bz2 ']'
> + '[' -r patch-2.6/patch-2.6.39.zip ']'
> + '[' -r patch-2.6/patch-2.6.39.Z ']'
> + '[' -r patch-2.6/patch-2.6.39 ']'
> + return 1
> + noFile patch-2.6.39
> + echo 'cannot find patch file: patch-2.6.39'
> cannot find patch file: patch-2.6.39
> + exit 1
> 
> 
> 
> 
> Debug log of patched script (condensed to relevant parts):
> 
> + STOPSUBLEVEL=9999
> + STOPEXTRA=9999
> + '[' 9999 -lt 38 ']'
> + '[' x '!=' x ']'
> + CURRENTFULLVERSION=2.6.38
> + '[' x '!=' x ']'
> + '[' 9999 -gt 38 ']'
> + :
> + CURRENTFULLVERSION=2.6.38
> + EXTRAVER=
> + '[' x = x2.6.38 ']'
> + SUBLEVEL=39
> + FULLVERSION=2.6.39
> 
> 
> Since my last patch (the parent mail) happened to modify the very same line,

Parent email from 2007???  wow.  :)

Why doesn't the debug/trace info show the value of STOPFULLVERSION?
Is it empty?

> I'm slightly wondering why last time it didn't exhibit this issue
> (IIRC this occurred for the first time a couple months later,
> perhaps in newer shell versions).
> 
> Patch has been created on git 2.6.39-rc1,
> run through checkpatch.pl,
> tested to work on dash and still work on bash,
> and tested to apply cleanly to 2.6.37, too.
> 
> IMHO this is a low-priority item,
> certainly not requiring service within current -rc handling,
> and neither at -stable (I assume that only point versions
> could make good use of this patch anyway).
> IOW standard patch circulation.
> I'm assuming that Sam would be the one to queue it up,
> just like last time.

Michal is the new kbuild maintainer, so he could queue it, or I can.

> Thanks!
> 
> Signed-off-by: Andreas Mohr <andi@lisas.de>
> 
> 
> diff --git a/scripts/patch-kernel b/scripts/patch-kernel
> index 46a59ca..20fb25c 100755
> --- a/scripts/patch-kernel
> +++ b/scripts/patch-kernel
> @@ -250,7 +250,7 @@ while :				# incrementing SUBLEVEL (s in v.p.s)
>  do
>      CURRENTFULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
>      EXTRAVER=
> -    if [ $STOPFULLVERSION = $CURRENTFULLVERSION ]; then
> +    if [ x$STOPFULLVERSION = x$CURRENTFULLVERSION ]; then
>          echo "Stopping at $CURRENTFULLVERSION base as requested."
>          break
>      fi

Patch is OK, but I still wonder about the value of $STOPFULLVERSION.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
