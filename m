Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2HTR3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:29:44 -0400
Received: from mx.meyering.net ([88.168.87.75]:44784 "EHLO hx.meyering.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751692Ab2HTR3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:29:13 -0400
X-Greylist: delayed 1999 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2012 13:29:12 EDT
From: Jim Meyering <jim@meyering.net>
To: linux-kernel@vger.kernel.org
Subject: a few strncpy-related patches
Date: Mon, 20 Aug 2012 18:55:19 +0200
Message-Id: <1345481724-30108-1-git-send-email-jim@meyering.net>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've seen a few too many cases of strncpy misuse.
Looking through linux sources, I spotted/fixed these:

[PATCH] ACPI: remove unwarranted use of strncpy
[PATCH] fs/9p: avoid debug OOPS when reading a long symlink
[PATCH] kmemleak: avoid buffer overrun: NUL-terminate strncpy-copied
[PATCH] bfa: avoid buffer overrun for 12-byte model name
[PATCH] cifs: remove misleading strncpy: each name has length < 16

 drivers/acpi/sysfs.c       |    3 +--
 drivers/scsi/bfa/bfa_fcs.c |    1 +
 fs/9p/vfs_inode.c          |    8 ++++----
 fs/cifs/cifssmb.c          |    6 ++++--
 mm/kmemleak.c              |    1 +
 5 files changed, 11 insertions(+), 8 deletions(-)
