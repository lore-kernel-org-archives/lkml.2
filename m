Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1LVIz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:55:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:56043 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab1LVIzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:55:53 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: [PATCH v2 0/2] vfs: truncate bug fixes
Date: Thu, 22 Dec 2011 10:55:24 +0200
Message-Id: <cover.1324543719.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a file is opened with O_TRUNC or truncated with truncate()/ftruncate(),
and then closed, iversion is not updated. This patch uses ATTR_OPEN flag,
which is currently used to identify files opened with O_TRUNC,
as an indication to increment iversion.
Also it adds passing of this flag from do_sys_truncate and do_sys_ftruncate.
To reflect real meaning, ATTR_OPEN is suggested to be renamed to ATTR_TRUNC.

Dmitry Kasatkin (2):
  vfs: iversion truncate bug fix
  vfs: ATTR_OPEN rename

 fs/attr.c          |    3 +++
 fs/fuse/dir.c      |    4 ++--
 fs/namei.c         |    2 +-
 fs/open.c          |    5 +++--
 include/linux/fs.h |    2 +-
 5 files changed, 10 insertions(+), 6 deletions(-)

-- 
1.7.4.1

