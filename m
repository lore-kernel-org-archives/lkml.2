Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab2AYTDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 14:03:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43893 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2AYTDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 14:03:45 -0500
MIME-Version: 1.0
In-Reply-To: <201201242356.04244.rjw@sisk.pl>
References: <201201242356.04244.rjw@sisk.pl>
Date: Wed, 25 Jan 2012 14:03:44 -0500
X-Google-Sender-Auth: P37cUpNPSF725zeU_7xB1UDGbBY
Message-ID: <CAP=VYLo90FANL8tX5VPvL+3wKB0CDF3Ryz1Lsw6ECVpcT9nesQ@mail.gmail.com>
Subject: Re: [Announce] linux-pm tree changes
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 5:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> I'd like you to know some workflow changes regarding the linux-pm tree.
>
> Since it's now possible to create signed tags for Linus to pull from, I won't
> need the 'pm-for-linus' branch any more and it's gone.  The 'pm-fixes' branch
> is gone too and replaced by the 'fixes' branch (which currently contains the
> same material as master).
>
> The idea is that the main development is going to happen in the 'master'
> branch, which is not going to be rebased and the Linus' tree will be merged
> into it from time to time (most of the time when the 'master' branch can be
> fast-forwarded to it).  The 'fixes' branch will be used for pushing urgent

Not sure what you have in mind for "from time to time", but random merges
without a clear reason (i.e. "merge Linus to get access to new files X Y Z")
are probably going to get you in hot water.

Also, once you stack on your 1st PM commit onto your master, none of
your future merges of Linus' tree will be fast forward.  Here is an
example, where I simulate a local change, followed by "time to time"
merges of Linus tree.  Note each creates a merge, not just the 1st one.

-----------------------------
linux-head$git checkout -b crap v3.1
Checking out files: 100% (17551/17551), done.
Switched to a new branch 'crap'
linux-head$echo foo > foo ; git add foo ; git commit -m '1st pm commit'
[crap 1675da3] 1st pm commit
 1 files changed, 1 insertions(+), 0 deletions(-)
 create mode 100644 foo
linux-head$git merge v3.2-rc1 2>&1 |grep 'Merge\|Fast'
Merge made by recursive.
linux-head$git merge v3.2-rc2 2>&1 |grep 'Merge\|Fast'
Merge made by recursive.
linux-head$git merge v3.2-rc3 2>&1 |grep 'Merge\|Fast'
Merge made by recursive.
linux-head$git show -m |head -n5
commit 3cbd041875960361ffde72612afadc6c68e94654 (from
6f6028bdbbc63dc71b408da8976f154a2e6a70ee)
Merge: 6f6028b caca6a0
Author: Paul Gortmaker <paul.gortmaker@windriver.com>
Date:   Wed Jan 25 13:45:55 2012 -0500
linux-head$
----------------

Having lots of these kinds of pointless merge commits are
what will most likely get you in hot water when you ask for
it to be pulled.

Maybe I'm just misinterpreting what your plan is.

Paul.
---

> stuff that must go in before the new material in the 'master' branch.
>
> The linux-next branch is going to be based on top of the master branch
> with the 'fixes' branch merged into it and will contain additional new
> material that hasn't been added to the master branch yet.  Every patch
> going through linux-pm has to spend some time in the linux-next branch
> alone before it is added to the master (or 'fixes') branch (some super-urgent
> fixes may go directly to the 'fixes' branch, though).
>
> Topic branches are all gone now and they will be re-created as needed.
>
> If you have any questions, please ask.
>
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
