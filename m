Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab2HQJSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:18:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38108 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932970Ab2HQJSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:18:30 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20120817010519.GA2440@ymail.com>
References: <20120816204440.GA8808@ymail.com>
	<CA+icZUX+4mMYqNn5_5EKXTdqbZ25K1HFbsRR5TrToaGJaSPttw@mail.gmail.com>
	<20120817010519.GA2440@ymail.com>
Date: Fri, 17 Aug 2012 11:18:28 +0200
Message-ID: <CA+icZUU6KS_8T5uhQZw6QKDD4iLp76xphr2N9KJ6Dvj_ib_sig@mail.gmail.com>
Subject: Re: [overlayfs/port] overlayfs: v13 port attempt to kernel 3.5
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Andrew Watts <akwatts@ymail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Daniel Baumann <daniel@debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 3:05 AM, Andrew Watts <akwatts@ymail.com> wrote:
>> Might be easier to collect/extract commits listed in [1]?
>>
>> If you are on Ubuntu: Check mainline kernels in [2] (quantal) and [3] (precise).
>>
>> - Sedat -
>>
>
> That indeed was much easier and I have it working great on 3.5.2. Many
> thanks for the link to the git repo.
>
> It would be nice to see overlayfs ack'd into mainline at some point. Is
> there any chance of this?
>

[ TO Linus and CC LKML and Daniel (maintainer of debian-live project) ]
( I could or should CC even more folks... )

Hi,

There exists a lot of threads on LKML and here on linux-fsdevel ML
about the topic "Union FileSystems".
In some of these discussions you will read about pros and cons about
"OverlayFS".
More precisely: Endless or even fruitless(?) discussions as after so
many years there is no upstream solution in sight.

Unfortunately, some kernel developers still didn't realize that
***Linux live-systems*** and ***Embedded Linux*** are IMHO two
examples for great "success stories" of Linux!

To run both successfully, you need this fundamental filesystem components:

(1) a "Compressed Read-Only File System" (like SquashFS)
(2) a "Union FileSystem" (like AUFS, OverlayFS, "Union Mounts", etc.)

Someday we got all happy with SquashFS accepted in upstream - this was
the first success!

The other part to run a Linux live-system is a "Union FileSystem" -
this part is missing (speaking of upstream).

Since years AUFS seems to be the choice #1 in a lot of distros to
workaround the problem.
NOTE: AUFS was rejected from upstream (to say not accepted).

I talked with so many distro kernel-teams and especially with Daniel
Baumann (maintainer of debian-live project):
The responsibles say if OverlayFS is upstreamed we will take it else
NOPE followed by an "OkThxBye" from impolite people!
[Q] So, why the hell do you include AUFS (not upstreamed) but not
OverlayFS (also not upstreamed) :-)?

As a sidenote, Linux-v3.6-rc1 got some first bits of "Union Mounts"
which was chosen as the ***preferred*** (longterm!) upstream solution.
But this special topic seems to me to get a ***never-ending story***.
Maintainers changed - new developers carried (or not?) - patchsets
were sent to MLs but got never really reviewed or finished.
YES, ***finished***!
I remember the "nVidia, F*** you!" video, not because of the famous(?)
F-word, but the part where Linus talks about "visions" VS. "I like to
see/get stuff finished".

One thing is a bit strange to me: Where does the development of "Union
Mounts" happen?
Normally, someone would assume - as this is gonna be a part of the
Linux kernel - this happens in the public.
I don't know of a repository - do you know?

Personally, I would like to see OverlayFS as a or the "small" solution
besides $union-filesystem-preferred-by-upstream.
OverlayFS is pretty small - a very good choice for embedded Linux systems.

After looking into the pile #1 of VFS pull-request for Linux-v3.6-rc1,
I noticed this...

     "* preparatory bits from unionmount series (from dhowells)."

So, I talked with some responsibles on #ubuntu-kernel and this was
appreciated (and lead to some adaptation of the OverlayFS code and
resulted in v14).
On the one hand it is nice to see that something happens in upstream,
on the other no one knows when "Union Mounts" will get a "working"
solution (to say "finished").

Just to name two projects:
Ubuntu (Linux distribution) and OpenWrt (Linux embedded system) use
OverlayFS in their live-system and build-system environments.

But... I am a person which is *not* in charge or responsible for the
development in the (near) future - nor in the position to decide.

I did some early testing (against linux-next) and contributed a few lines.
After that I am regularly testing OverlayFS since v11 till present.

Anyway, I would be really happy to see any working ***upstream solution***!

It might be worth to escalate this topic to Linus directly (Oops, I did?).

I hope people rest calm and do NOT throw me S*** and F*** words - be
always a Gentleman :-)!

My 0.02EUR.

- Sedat -

> ~ Andy
