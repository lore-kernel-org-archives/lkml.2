Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab2CCKGY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 05:06:24 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3701 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2CCKGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 05:06:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6637"; a="166538997"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 0/2] Introduce simple_open()
Date: Sat,  3 Mar 2012 02:06:18 -0800
Message-Id: <1330769180-22354-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.2.315.g25a78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that if I want to tweak debugfs file ops I need to copy
the implementation of default_open() in fs/debugfs/file.c. I went
to look for an exported function that would be common across all
debugfs users but I couldn't find any.

This patchset moves default_open() to libfs so that other filesystems
can use it (although almost 99% of users are debugfs clients). I
wrote a semantic patch to find all the kernel users and ended up
with a nice diff:

 58 files changed, 150 insertions(+), 560 deletions(-)

I will send those patches as a follow up to these two once we settle
on naming and merging strategies for the patches.

Stephen Boyd (2):
  libfs: Add simple_open()
  coccinelle: semantic patch for simple_open()

 fs/libfs.c                               |    8 +++++++
 include/linux/fs.h                       |    1 +
 scripts/coccinelle/api/simple_open.cocci |   34 ++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+)
 create mode 100644 scripts/coccinelle/api/simple_open.cocci

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

