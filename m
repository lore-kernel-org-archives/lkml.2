Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab2CaFoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 01:44:18 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:50229 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab2CaFoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 01:44:16 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv3 0/6] spi: omap2-mcspi: driver updates
To: Shubhrajyoti D <shubhrajyoti@ti.com>,
        spi-devel-general@lists.sourceforge.net
Cc: Shubhrajyoti@ponder.secretlab.ca, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, D <shubhrajyoti@ti.com>
In-Reply-To: <1333102822-17171-1-git-send-email-shubhrajyoti@ti.com>
References: <1333102822-17171-1-git-send-email-shubhrajyoti@ti.com>
Date: Fri, 30 Mar 2012 23:44:13 -0600
Message-Id: <20120331054413.0CF363E0465@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 15:50:16 +0530, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
> The patch series does the following cleanups
> - Converts the spi to module_platform_driver
> - Use the devm functions so that the freeing need not 
>   be done in the driver.
> - Makes the driver use autosuspend
> - Folds Benoit's bus_num removal patch in the series
> 
> Changes from v1
> - Makes the driver use autosuspend
> - Folds Benoit's bus_num removal patch in the series
> 
> Changes from v2
> - The tmp variable is used to write this can be optimised 
>  as it is not needed if the value is directly written.
>  Acknowledge  Tarun for the suggestion.
> 
> This is also available through
> git     : git://gitorious.org/linus-tree/linus-tree.git
> branch  : spi
> 
> This is targeted for v3.5. 

Okay, now is a good time to talk about git pull request workflow.  10
days ago you published a git tree and I replied that I had pulled it
into mine.  Now you've got a new branch with the patches from the old
branch rebased onto a new head.  Compairing your branch with mine now
looks like this:

$ git fetch git://gitorious.org/linus-tree/linus-tree.git spi
remote: Counting objects: 34, done.
remote: Compressing objects: 100% (28/28), done.
remote: Total 30 (delta 24), reused 6 (delta 2)
Unpacking objects: 100% (30/30), done.
>From git://gitorious.org/linus-tree/linus-tree
 * branch            spi        -> FETCH_HEAD
$ git show-branch --topic origin spi/next FETCH_HEAD
! [origin] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc
 ! [spi/next] Merge branch 'spi' of git://gitorious.org/linus-tree/linus-tree into spi/next
  ! [FETCH_HEAD] spi: omap2-mcspi: Trivial optimisation
---
  + [FETCH_HEAD] spi: omap2-mcspi: Trivial optimisation
  + [FETCH_HEAD^] spi: omap2-mcspi: add support for pm_runtime autosuspend
  + [FETCH_HEAD~2] spi: omap2-mcspi: use devm_* functions
  + [FETCH_HEAD~3] spi: omap2-mcspi: convert to module_platform_driver
  + [FETCH_HEAD~4] spi: omap2-mcspi: make it behave as a module
  + [FETCH_HEAD~5] spi/omap: Remove bus_num usage for instance index
 -  [spi/next] Merge branch 'spi' of git://gitorious.org/linus-tree/linus-tree into spi/next
 +  [spi/next^2] OMAP : SPI : use devm_* functions
 +  [spi/next^2^] spi: omap2-mcspi: convert to module_platform_driver
 +  [spi/next^2~2] spi: omap2-mcspi: make it behave as a module
+++ [origin~189] Linux 3.3

I cannot merge this branch.  If I did it would result in 2 commits for
each of the commits from the original branch.  You'll need go back and
rebase the new commits on top of the old base or on top of my current
spi/next branch[1]

[1] git://git.secretlab.ca/git/linux-2.6 spi/next

I've already published that branch, so I will not rebase it either to
remove the original commits.  The new commits must go on top.

Next time, *don't* rebase a branch that has been pulled.  It should be
left alone and new commits added on top of it.  If your in the
situation where mainline has commits that you need to bring into the
branch, then *merge* mainline into your branch (preferably at a tagged
release point), or ask me to merge in mainline to give you a new
baseline to work from.

One option I do have is to apply only the patches I'm missing to my
tree, but I'm not going to because I don't actually know if patches
1, 2, or 3 have changed since the version that I've posted.  It's
safer for me to get you to rebase back onto the proper base and post
only the new patches.  Your cover letter should state specifically
which branch the patches apply on top of.

g.

> 
> Benoit Cousson (1):
>   spi/omap: Remove bus_num usage for instance index
> 
> Felipe Balbi (2):
>   spi: omap2-mcspi: make it behave as a module
>   spi: omap2-mcspi: convert to module_platform_driver
> 
> Shubhrajyoti D (3):
>   spi: omap2-mcspi: use devm_* functions
>   spi: omap2-mcspi: add support for pm_runtime autosuspend
>   spi: omap2-mcspi: Trivial optimisation
> 
>  drivers/spi/spi-omap2-mcspi.c |  132 +++++++++++++++-------------------------
>  1 files changed, 50 insertions(+), 82 deletions(-)
> 
> 
> ------------------------------------------------------------------------------
> This SF email is sponsosred by:
> Try Windows Azure free for 90 days Click Here 
> http://p.sf.net/sfu/sfd2d-msazure
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
