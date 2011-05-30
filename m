Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1E3J2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 05:28:17 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39705 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1E3J2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 05:28:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=O/4EneVeS1Isy6d4FRLRsTfVF4mCd2iHoTa7lpaaFPHrhMUAmNcaRcFPNnSeKv+9iV
         ggZjbNbEaIaWb959gg3A/wKZKVOC2yb/z4QxQeK+JqYyd1EgSVkBAbLmw1j9CfxVMlWY
         rVsUufTBCKbUHIKc3VglLT+EJahHdge6/awhs=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Mon, 30 May 2011 11:28:13 +0200
Message-ID: <BANLkTinWBwjwKmiQ2zN0ao_KOzGFKE76UQ@mail.gmail.com>
Subject: Re: Linux 3.0-rc1
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Please CC me I am not subscribed to LKML ]

[QUOTE]
h, and as some people already noticed, the numbering means that the
tar-balls and patches are now in a new directory:

    /pub/linux/kernel/v3.0

(under "testing/", since that's what we do with -rc releases).
However, I did *not* rename the git tree, because that would just be a
huge inconvenience to git users, so it's still in the same old place
and yes, that means that my git tree is still called "linux-2.6.git"
on kernel.org. But it has the v3.0-rc1 tag in it.

I'll probably add a symlink or something, if people really hate being
reminded about our long history with the "2.6" numbering. But that
won't be until closer to the real release, methinks.

                            Linus
[/QUOTE]

First of all, congrats to Linux v3.0-rc1!

As you have found by yourself this new numbering forces a bit of
rethinking some of (y)our (daily) workflows.
( The new location of Linux v3.0-rc1 tarball was my 1st "problem" when
converting my kernel-buildsystem. )

[A] REPOSITORY NAMES

BUT...
...your GIT tree is still called "linux-2.6" :-).
Lots of other GIT repsoitories still use a prefix "linux-2.6-", like
linux-2.6-tip, linux-2.6-rcu, linux-2.6-acpi, or look at net-2.6 or
drm-2.6.
NOW...
...it would be a good point to rename all repos to a more general/common name.
Especially, the "linux-2.6-" can go to /dev/nirvana.
[1] lists all trees merged into linux-next and can be used as an overview.

Here some examples with proposals for change:

EXAMPLE #1: Repos containing "linux-2.6-" prefix (IMHO even "linux-"
as prefix can be dropped)

1. linux-2.6-tip -> tip
2. linux-2.6-rcu -> rcu
3. linux-2.6-acpi -> acpi

EXAMPLE #2: Repos containing "-2.6" as suffix

1. net-2.6 -> net
2. drm-2.6 -> drm
3. wireless-2.6 -> wireless
4. sound-2.6 -> sound

[ Gold medal to Ted for his ext4 GIT tree :-). ]

EXAMPLE #3: WTF trees not fitting #1 or #2

In general: Use the directory-name where your drivers are stored, see
also MAINTAINERS file.

EXAMPLE #4: Repos using a separate GIT repo with -next suffix (for linux-next)

1. net-next-2.6 -> net-next
2. wireless-next-2.6 -> wireless-next

I know people won't like the idea on 1st look and hate me for no real
benefit/new features, but...
...PLEASE...
...don't start renaming to "3.0", in a decade we have the same problem
:-( and thus do it right from the beginning.

Thoughts?

[B] MY EXPERIENCES WITH v3.0-rc1

Here my 1st impressions:
I am mostly on linux-next and working with an adopted
kernel-buildsystem from Debian kernel team.

As a quick workaround, I changed package-name from "linux-2.6" to "linux-3.0".
This also led to a new folder linux-3.0 below $HOME/src.

A two digits major version number like 3.0(-rc1) is (currently) not
accepted, so the first line of debian/changelog looks like this:

linux-3.0 (3.0.0~rc1-1~next20110530.dileks1) UNRELEASED; urgency=low

So, I used for now 3.0.0~rc1 (Note: Debian uses ~rcX in changelog files).

IIRC some READMEs, copyright files below debian-dir etc. have to be
adopted, too.
But as this work is for my personal amusement, I build 1st and enjoy...

$ cat /proc/version
Linux version 3.0.0-rc1-next20110530.1-686-small (Debian
3.0.0~rc1-1~next20110530.dileks1) (sedat.dilek@gmail.com) (gcc version
4.6.1 20110526 (prerelease) (Debian 4.6.0-10) ) #1 SMP Mon May 30
08:15:10 CEST 2011

- Sedat -


[1] http://git.us.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=Next/Trees
