Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab2GRP10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 11:27:26 -0400
Received: from mail.ausil.us ([74.119.218.133]:56014 "EHLO mail.ausil.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab2GRP1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 11:27:23 -0400
Date: Wed, 18 Jul 2012 10:27:12 -0500
From: Dennis Gilmore <dennis@ausil.us>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Joe Perches <joe@perches.com>, Catalin Marinas <catalin.marinas@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120718102712.46b8d7ff@adria.ausil.us>
In-Reply-To: <5006207D.1010708@jonmasters.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
	<CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
	<201207071927.13135.arnd@arndb.de>
	<20120710071023.GA10456@gmail.com>
	<20120710101018.GE15120@arm.com>
	<yw1x8vekd309.fsf@unicorn.mansr.com>
	<CA+55aFxL6uEre-c=JrhPfts=7BGmhb2Js1c2ZGkTH8F=+rEWDg@mail.gmail.com>
	<20120717221839.GA4856@arm.com>
	<1342564536.1898.1.camel@joe2Laptop>
	<5006207D.1010708@jonmasters.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6IFRWX0010879

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

El Tue, 17 Jul 2012 22:33:33 -0400
Jon Masters <jonathan@jonmasters.org> escribiÃ³:
> On 07/17/2012 06:35 PM, Joe Perches wrote:
> > On Tue, 2012-07-17 at 23:18 +0100, Catalin Marinas wrote:
> > 
> >> The uname will still report
> >> "aarch64" to match the compiler triplet and also avoid confusion of
> >> existing 32-bit ARM scripts that simply check for "arm*" in the
> >> machine name.

that means that the yum base arch will need to be aarch64 and the arch
used in rpm will be aarch64 also. its throwing something weird and
confusing right in the face of users. I urge you to change it all to
arm64 just changing the directory in the kernel is pointless as it still
exposes all the weirdness of the name to users and will result in a
large amount of education and a constant stream of the same question
"Where do i find the arm64 bits?" until such time as the users learn
that arm64 is aarch64. All the tooling uses "uname -m" to determine the
package architecture.

The triplet that fedora will use will be preferred
arm64-redhat-linux-gnu or aarch64-redhat-linux-gnu

but again aarch64 will propogate to a lot of highly visible places
where it will just cause undue confusion.  adding a extra check for
arm64* before arm* if that is what people are using will not be hard to
do.

> > The compiler triplet seems trivial to change.
> > 
> > The other bit is a relatively weak argument as the 32bit arm
> > scripts can be changed or fixed likely just as easily.
> 
> There's a surprising amount of assumption out there around what arm*
> means (or doing wildcard matches liberally). I'm glad (from the point
> of view of a distribution bootstrap) that we don't have to worry
> about that aspect of getting AArch64 support up and running. The
> directory name is just that - a name - and unimportant. I like
> aarch64 from the point of view of distinguishing "this is not ARM,
> no, it's not just an extension, and no it's not just two numbers
> different or wider regs", but it seems fairly inevitable that it's
> going to be arch/arm64. The main thing is that we understand this
> isn't like i686->x86_64.

autoconf etc checks for " arm-*  | armbe-* | armle-* | armeb-* |
armv*-* "  arm64-* will not match the existing regexs in common
use. configure scripts will need rebuilding regardless of if its
aarch64 or arm64 to me the argument that  arm64 will catch existing
scripts is extremely weak. especially when the first target is really
almost completely new for arm in the server market.

Dennis
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAlAG1dMACgkQkSxm47BaWfdzRQCfUdBHeLoDDC2yJTOxdMP0k0ej
GcMAoKoRXG6d7xOvhPDbh3p4J8lKHYpb
=KXum
-----END PGP SIGNATURE-----
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
