Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab2HTKqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 06:46:04 -0400
Received: from mfb01-md.ns.itscom.net ([175.177.155.109]:49985 "EHLO
	mfb01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab2HTKp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 06:45:58 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [overlayfs/port] overlayfs: v13 port attempt to kernel 3.5
To: sedat.dilek@gmail.com
Cc: Andrew Watts <akwatts@ymail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Daniel Baumann <daniel@debian.org>
In-Reply-To: <CA+icZUU6KS_8T5uhQZw6QKDD4iLp76xphr2N9KJ6Dvj_ib_sig@mail.gmail.com>
References: <20120816204440.GA8808@ymail.com> <CA+icZUX+4mMYqNn5_5EKXTdqbZ25K1HFbsRR5TrToaGJaSPttw@mail.gmail.com> <20120817010519.GA2440@ymail.com> <CA+icZUU6KS_8T5uhQZw6QKDD4iLp76xphr2N9KJ6Dvj_ib_sig@mail.gmail.com>
Date: Mon, 20 Aug 2012 19:38:18 +0900
Message-ID: <8326.1345459098@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sedat Dilek:
> The other part to run a Linux live-system is a "Union FileSystem" -
> this part is missing (speaking of upstream).
>
> Since years AUFS seems to be the choice #1 in a lot of distros to
> workaround the problem.
> NOTE: AUFS was rejected from upstream (to say not accepted).

Exactly.
The reason was that linux rejects all union-type filesystems but
UnionMount (which is union-type mount).
Later, the development of UnionMount seems to be almost stopped. The
essential design of overlayfs is based upon UnionMount, and I have
pointed out several issues such as
- for users, the inode number may change silently. eg. copy-up.
- hardlinks may break by copy-up.
- read(2) may get an obsoleted filedata (fstat(2) for metadata too).
- fcntl(F_SETLK) may be broken by copy-up.
- unnecessary copy-up may happen, for example mmap(MAP_PRIVATE) after
  open(O_RDWR).
- Later I noticed one more thing. /proc/PID/{fd/,exe} may not work
  correctly for overlayfs ...
- etc...
They are called "unPOSIXy behavior", and unforunately many of them are
NOT seem to be addressed in recent patches either.

Also I have posted
	If the development of UnionMount is really stopped, then I'd ask people
	to consider merging aufs as well as overlayfs.
but I am not sure whether LKML people are still waiting for UnionMount
and rejecting aufs.


J. R. Okajima
