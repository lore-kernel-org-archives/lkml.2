Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1K3T5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 14:57:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51698 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1K3T5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 14:57:16 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [patch 00/25] dynamic-debug during module initialization
Date: Wed, 30 Nov 2011 12:56:29 -0700
Message-Id: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds
- dynamic-debug during module initialization
- multiple queries

Unlike previous versions, this drops pending-query approach in
favor of "fake module parameter" approach proposed by Thomas Renninger.
    https://lkml.org/lkml/2010/9/15/397

Its based upon v3.2-rc3, cuz it includes a few adjustments to
dynamic_debug.h which are not in driver-core-next atm.


1	bug-fix for kernel/module.c under DEBUGP
2	whitespace cleanup
3-12	dynamic-debug cleanups, should be relatively uncontroversial
13-17	multiple queries in ddebug_query="..."

18-25	fake module parameter
20	maybe fold into 18 (kept separate since 18 is Thomas's work)
23	*.dyndbg=...
25	BUILD_BUG_DECL (likely discussion point ;-)

[jimc@groucho linux-2.6]$ git diff --stat v3.2-rc3..HEAD
 Documentation/dynamic-debug-howto.txt |   76 ++++++--
 drivers/pnp/base.h                    |    8 +-
 drivers/pnp/core.c                    |   13 ++
 include/linux/device.h                |    8 +-
 include/linux/dynamic_debug.h         |   31 +++-
 include/linux/kernel.h                |   10 +
 include/linux/moduleparam.h           |    4 +
 include/linux/netdevice.h             |    8 +-
 include/linux/printk.h                |    8 +-
 kernel/module.c                       |   47 ++---
 kernel/params.c                       |   27 ++-
 lib/dynamic_debug.c                   |  349 +++++++++++++++++++++++++--------
 12 files changed, 430 insertions(+), 159 deletions(-)


