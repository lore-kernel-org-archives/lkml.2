Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276Ab0LFFoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 00:44:25 -0500
Received: from mail.perches.com ([173.55.12.10]:2264 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab0LFFoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 00:44:24 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Matt Mackall <mpm@selenic.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] printk: add pr_<level>_once, guard print_hex_dump
Date: Sun,  5 Dec 2010 21:44:14 -0800
Message-Id: <cover.1291611190.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many uses of printk_once(KERN_<level>.
Add pr_<level>_once macros to avoid printk_once(KERN_<level> pr_fmt(fmt).
Add an #ifdef CONFIG_PRINTK for print_hex_dump and static inline void
functions for the #else cases to reduce embedded code size.
Neaten and organize the rest of the code.

Joe Perches (7):
  include/linux/printk.h: Move console functions and variables together
  include/linux/printk.h: Use space after #define
  include/linux/printk.h: Use and neaten no_printk
  include/linux/printk.h: Add pr_<level>_once macros
  include/linux/printk.h lib/hexdump.c: Neatening and add CONFIG_PRINTK guard
  include/linux/printk.h: Organize printk_ratelimited macros
  include/linux/printk.h: Use tab not spaces for indent

 include/linux/printk.h |  247 +++++++++++++++++++++++++++++-------------------
 lib/hexdump.c          |    2 +
 2 files changed, 152 insertions(+), 97 deletions(-)

-- 
1.7.3.2.245.g03276.dirty

