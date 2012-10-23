Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605Ab2JWUEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:04:46 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44312 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933448Ab2JWUEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:04:41 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 000/193] remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:13 -0700
Message-Id: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Thanks,

-Kees

