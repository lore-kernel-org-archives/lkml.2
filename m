Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab1K3U1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 15:27:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35285 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab1K3U1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 15:27:49 -0500
MIME-Version: 1.0
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 30 Nov 2011 13:27:17 -0700
Message-ID: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>
Subject: [patch 00/25] dynamic-debug enhancements
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patchset adds
- dynamic-debug during module initialization
- multiple queries in ddebug_query, module.dyndbg

Unlike previous versions, it drops the pending-query approach in
favor of  "fake module parameters"proposed by Thomas Renninger
    https://lkml.org/lkml/2010/9/15/397

Its based upon 3.2-rc3, since that has several patches to
include/linux/dynamic_debug.h
that are not in driver-core-next, and theyd need to be handled eventually.

1 - trivial bug in kernel/module.c under DEBUGP
2 - whitespace
3-12 dyndbg cleanups
13-17 multiple queries
18-25 dynamic-debug during module initialization




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
