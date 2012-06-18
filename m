Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab2FRCZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 22:25:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48478 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752228Ab2FRCZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 22:25:19 -0400
From: Joe Perches <joe@perches.com>
To: platform-driver-x86@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        linux-usb@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] printk: Add eliminated_printk
Date: Sun, 17 Jun 2012 19:25:07 -0700
Message-Id: <cover.1339985626.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no_printk keeps side-effects.
eliminated_printk removes all side effects yet still keeps
gcc format and argument verificatino.
By definition, pr_devel should have no side-effects if not enabled.
Convert pr_devel from no_printk to eliminated_printk.

Joe Perches (5):
  printk: Add eliminated_printk macro
  printk: Convert pr_devel to use eliminated_printk
  usb: Convert dbg to pr_eliminated and pr_debug
  fujitsu-laptop: Convert dbg_printk and vdbg_printk to fuj_dbg
  thinkpad_acpi: Convert dbg_printk to tp_dbg and tp_vdbg

 drivers/platform/x86/fujitsu-laptop.c |  103 +++++-----
 drivers/platform/x86/thinkpad_acpi.c  |  358 +++++++++++++++------------------
 include/linux/printk.h                |   12 +-
 include/linux/usb.h                   |   12 +-
 4 files changed, 228 insertions(+), 257 deletions(-)

-- 
1.7.8.111.gad25c.dirty

