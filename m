Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab2HTL0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:26:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37804 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab2HTL0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:26:48 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <8326.1345459098@jrobl>
References: <20120816204440.GA8808@ymail.com>
	<CA+icZUX+4mMYqNn5_5EKXTdqbZ25K1HFbsRR5TrToaGJaSPttw@mail.gmail.com>
	<20120817010519.GA2440@ymail.com>
	<CA+icZUU6KS_8T5uhQZw6QKDD4iLp76xphr2N9KJ6Dvj_ib_sig@mail.gmail.com>
	<8326.1345459098@jrobl>
Date: Mon, 20 Aug 2012 13:26:46 +0200
Message-ID: <CA+icZUW5tmGca8oVRjxqHVw6KTnCR+8vg5UCqhwrRbAoStEd=A@mail.gmail.com>
Subject: Re: [overlayfs/port] overlayfs: v13 port attempt to kernel 3.5
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Andrew Watts <akwatts@ymail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Daniel Baumann <daniel@debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 12:38 PM, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>
> Sedat Dilek:
>> The other part to run a Linux live-system is a "Union FileSystem" -
>> this part is missing (speaking of upstream).
>>
>> Since years AUFS seems to be the choice #1 in a lot of distros to
>> workaround the problem.
>> NOTE: AUFS was rejected from upstream (to say not accepted).
>
> Exactly.
> The reason was that linux rejects all union-type filesystems but
> UnionMount (which is union-type mount).
> Later, the development of UnionMount seems to be almost stopped. The
> essential design of overlayfs is based upon UnionMount, and I have
> pointed out several issues such as
> - for users, the inode number may change silently. eg. copy-up.
> - hardlinks may break by copy-up.
> - read(2) may get an obsoleted filedata (fstat(2) for metadata too).
> - fcntl(F_SETLK) may be broken by copy-up.
> - unnecessary copy-up may happen, for example mmap(MAP_PRIVATE) after
>   open(O_RDWR).
> - Later I noticed one more thing. /proc/PID/{fd/,exe} may not work
>   correctly for overlayfs ...
> - etc...
> They are called "unPOSIXy behavior", and unforunately many of them are
> NOT seem to be addressed in recent patches either.
>
> Also I have posted
>         If the development of UnionMount is really stopped, then I'd ask people
>         to consider merging aufs as well as overlayfs.
> but I am not sure whether LKML people are still waiting for UnionMount
> and rejecting aufs.
>

Okajima san /o\,

thanks for the short summary of history, quick overview of AUFS
features and OverlayFS design.
I can't say much about AUFS, I just simply used it for so long.

But it looks like you agree with me that something should happen in
case of Union Filesystem's.
Anyway, as said I would like to see an upstream solution in the near future.
If this will be AUFS, I am OK with that decision.

Regards,
- Sedat -

> J. R. Okajima
