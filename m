Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1C3IhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 04:37:12 -0400
Received: from smtp.nokia.com ([147.243.128.24]:57995 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab1C3IhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 04:37:10 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: MTD list <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] do not select KALLSYMS_ALL
Date: Wed, 30 Mar 2011 11:40:14 +0300
Message-Id: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.2.3
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UBI and UBIFS have an option to compile-in debugging support. When we enable
debugging, compile-in various assertions, self-check functions and test modes.
We also compile in additional verbose error messages, flash dumps and stack
dumps.

When we have debugging support enabled, we want to have nice stackdumps, so
we selected KALLSYMS_ALL. But this causes various problems like unmet direct
dependencies, reported by Randy:

warning: (UBIFS_FS_DEBUG && LOCKDEP && LATENCYTOP) selects KALLSYMS_ALL which
has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)

I quickly looked at KALLSYMS_ALL and it is not immediately clear what exactly
is the difference between KALLSYMS and KALLSYMS_ALL. And there is this
CONFIG_KALLSYMS_EXTRA_PASS symbol, which is declared "temporary workaround"
in the Kconfig help. This shows that this stuff is messy.

I personally think KALLSYMS_ALL should be just merged with KALLSYMS and
disappear - we should have only one option. CONFIG_KALLSYMS_EXTRA_PASS should
die as well.

But I don't want to delve into that, I choose to just forget about KALLSYMS_ALL
and select KALLSYMS in UBI/UBIFS which seems to be enough for us.

Artem.
