Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab2GSTqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 15:46:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60039 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2GSTqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 15:46:44 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com, linux-kernel@vger.kernel.org
Cc: kay@vrfy.com, joe@perches.com, greg@kroah.com,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 0/3] dyndbg: dev_dbg bugfix + 2 trivials
Date: Thu, 19 Jul 2012 13:46:19 -0600
Message-Id: <1342727183-4520-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3 patches here, 1st is bugfix, others are trivial.

1- fix __dev_printk, which broke dev_dbg() prefix under CONFIG_DYNAMIC_DEBUG.

2- change dyndbg prefix interfield separator from ':' to '.'

for example (output from test-code, not submitted):
r8169 0000:02:00.0: r8169.rtl_init_one: set-drvdata pdev:ffff880223041000 dev:ffff880220d6a000
hwmon hwmon1: k10temp.k10temp_probe.180: set-drvdata pdev:ffff88022303d000 dev:ffff8801dfd2a000

This improves usability of cut -d: <logfile> for pr_debug() messages,
as field position is less volatile with various uses of dyndbg flags.
Its not perfect:
- dev_dbg on net-devices adds several more colons,
  but this doesnt vary with dyndbg flags. 
- dyndbg=+pfmlt still adds a field vs dyndbg==p (ie no prefix)
- pr_fmt() commonly adds another colon (unchanged with this patch)
  
3- trivial var name change in lib/dynamic_debug.c


Please drop or apply 2,3 as you prefer.
