Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2KEXFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:05:10 -0500
Received: from smtp.outflux.net ([198.145.64.163]:56162 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313Ab2KEXFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:07 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2 000/104] remove CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:03:17 -0800
Message-Id: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a refreshed send of the "remove CONFIG_EXPERIMENTAL" patch series.
It include the patches that haven't been pulled into a maintainer's tree
(or I missed when it happened), and haven't been Acked already to be
carried in my tree:

http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/linux-next

This update includes mainly additional CCs for patches that were missing
CCs, as well as improvements to the commit template. As before, if you
want me to carry the patch in my tree, just let me know. If you're going
to take them into your tree, also please let me know so I can drop them
from this series, which lives here:

http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/experimental

And as a reminder, here's the text from the original series header:


This config item has not carried much meaning for a while now and is
almost always enabled by default (especially in distro builds). As agreed
during the Linux kernel summit, it should be removed.

As such, this is the patch series for removing CONFIG_EXPERIMENTAL, 
with the hopes of all the various maintainers pulling these changes into
their trees.  I'm carrying the first patch (that makes CONFIG_EXPERIMENTAL
"default y") in my linux-next tree, so builds there will see the impact
immediately. 

Some patches remove "(EXPERIMENTAL)" from Kconfig titles when there was
no "depends on EXPERIMENTAL". I've removed the cases of these where I
know the maintainer intended it that way. I've left the others in case a
"depends on EXPERIMENTAL" had been removed in the past and it had been
accidentally forgotten in the title. If the title is correct as-is, 
just let me know, and I'll drop the patch from my series.

Here is an outline of how to handle things going forward, from the first
patch's commit message, based on earlier lkml discussions:

  For items that really are experimental, maintainers should use "default
  n", optionally include "(EXPERIMENTAL)" in the title, and add language to
  the help text indicating why the item should be considered experimental.

  For items that are dangerously experimental, the maintainer is encouraged
  to follow the above title recommendation, add stronger language to the
  help text, and optionally use (depending on the extent of the danger,
  from least to most dangerous): printk(), add_taint(TAINT_WARN),
  add_taint(TAINT_CRAP), WARN_ON(1), and CONFIG_BROKEN.

