Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1AQOd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:33:58 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40186 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab1AQOdz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:33:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=fPUJlU2El0hnU4epMb62eUWJe8raXbvtQmn4UKyunzWnNFwwOcFo4b9E+z2xtGnT56
         BXVNSnps2GQh1gWKW8jIyAXtmEaD1Nq5zMXfNjXeFdcYZXDP5aF3mufMWCNIec0G7+gR
         b/GA6Ean6hz7geFKx3uteX/4P0uMTTWAd6bBY=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110117133741.GI22723@ZenIV.linux.org.uk>
References: <20110117133741.GI22723@ZenIV.linux.org.uk>
Date: Mon, 17 Jan 2011 15:32:41 +0100
Message-ID: <AANLkTi=wrsnK2uUmDncMhnCSVXugfGDewKyGP=F3NyB5@mail.gmail.com>
Subject: Re: [git pull] vfs misc bits
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 2:37 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        Assorted bits and pieces.  There will be one more pile, but this one
> is just sweeping the misc stuff.  Please, pull from
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus
>
> Shortlog:
[...]
> Steven Rostedt (2):
>      fs: Remove unlikely() from fput_light()
>      fs: Remove unlikely() from fget_light()
>

[ CCing Steven Rostedt, Ingo Molnar (linux-2.6-tip) and  Stephen
Rothwell (linux-next) ]

Al-elulja!

finally, more and more of Stevens unlikely/* patches went into several
trees (I have them all since 15-Dec-2010 in my patch-series, see my
script below).

After pulling Al's vfs-2.6.git#for-linus branch into todays linux-next
(next-20110117), it looks like it is only missing Stevens
unlikely/core branch [1].
I guees this will be touched by Ingo's magic hands soon.

Make these "unlikely" things "likely" :-)

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/rostedt/linux-2.6-trace.git;a=shortlog;h=refs/heads/unlikely/core

P.S.:

$ cat scripts/git-pull_srostedt-unlikely-branches.sh
#!/bin/sh

# DATE: 15-Dec-2010

branches="unlikely/core unlikely/workqueue unlikely/fs unlikely/x86
unlikely/mm unlikely/sched"

VCS_GIT="git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git"

cd linux-next

for i in $branches ; do git pull $VCS_GIT $i ; done

$ cd /mnt/sdb5/linux-kernel/

$ ./scripts/git-pull_srostedt-unlikely-branches.sh
remote: Counting objects: 67, done.
remote: Compressing objects: 100% (48/48), done.
remote: Total 49 (delta 39), reused 1 (delta 1)
Unpacking objects: 100% (49/49), done.
>From git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace
 * branch            unlikely/core -> FETCH_HEAD
warning: too many files (created: 1138 deleted: 595), skipping inexact
rename detection
Auto-merging arch/x86/kernel/process_64.c
Auto-merging kernel/sched.c
Auto-merging kernel/sched_rt.c
Merge made by recursive.
 arch/x86/kernel/process_64.c |    6 +++---
 kernel/sched.c               |    4 ++--
 kernel/sched_rt.c            |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)
remote: Counting objects: 7, done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 4 (delta 3), reused 0 (delta 0)
Unpacking objects: 100% (4/4), done.
>From git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace
 * branch            unlikely/workqueue -> FETCH_HEAD
warning: too many files (created: 1130 deleted: 579), skipping inexact
rename detection
Merge made by recursive.
remote: Counting objects: 15, done.
remote: Compressing objects: 100% (9/9), done.
remote: Total 9 (delta 7), reused 0 (delta 0)
Unpacking objects: 100% (9/9), done.
>From git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace
 * branch            unlikely/fs -> FETCH_HEAD
warning: too many files (created: 1130 deleted: 579), skipping inexact
rename detection
Merge made by recursive.
remote: Counting objects: 11, done.
remote: Compressing objects: 100% (6/6), done.
remote: Total 6 (delta 5), reused 0 (delta 0)
Unpacking objects: 100% (6/6), done.
>From git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace
 * branch            unlikely/x86 -> FETCH_HEAD
warning: too many files (created: 1130 deleted: 579), skipping inexact
rename detection
Merge made by recursive.
remote: Counting objects: 21, done.
remote: Compressing objects: 100% (13/13), done.
remote: Total 14 (delta 12), reused 1 (delta 1)
Unpacking objects: 100% (14/14), done.
>From git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace
 * branch            unlikely/mm -> FETCH_HEAD
warning: too many files (created: 1130 deleted: 579), skipping inexact
rename detection
Merge made by recursive.
remote: Counting objects: 20, done.
remote: Compressing objects: 100% (16/16), done.
remote: Total 16 (delta 12), reused 0 (delta 0)
Unpacking objects: 100% (16/16), done.
>From git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace
 * branch            unlikely/sched -> FETCH_HEAD
warning: too many files (created: 1130 deleted: 579), skipping inexact
rename detection
Merge made by recursive.

- EOT -
