Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab2JRIZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:25:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:17377 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2JRIZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:25:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="207551922"
From: dragos.tatulea@intel.com
To: ccross@android.com, keescook@chromium.org, tony.luck@intel.com,
        cbouatmailru@gmail.com, linux-kernel@vger.kernel.org
Cc: adrian.hunter@intel.com, octavian.purdila@intel.com,
        Dragos Tatulea <dragos.tatulea@intel.com>
Subject: [PATCH v2 0/8] pstore: add interface for dumpers and add task list dumper
Date: Thu, 18 Oct 2012 11:28:20 +0300
Message-Id: <1350548908-24407-1-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dragos Tatulea <dragos.tatulea@intel.com>

This patchset adds an interface for registering various clients (dumpers)
that can save info into pstore at crash time.

Such a dumper is added which does task list dumping.

v2 changes:
v1 patchset was corrupted.

Adrian Hunter (4):
  pstore: add flags
  pstore: add debugfs support for causing dumps and panics
  pstore: add support for external writers
  pstore: do not run timer while pstore is not mounted

Dragos Tatulea (4):
  pstore: allow storing different type id's in ram backend
  pstore: add task list dumper
  pstore: make sure pstore_write exists on flush error
  pstore: max out console log level during sysfs dump switch

 fs/pstore/Kconfig      |   12 ++++
 fs/pstore/Makefile     |    1 +
 fs/pstore/dump_tasks.c |  107 ++++++++++++++++++++++++++++
 fs/pstore/inode.c      |    6 ++
 fs/pstore/internal.h   |    2 +
 fs/pstore/platform.c   |  184 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/pstore/ram.c        |   18 +++--
 include/linux/pstore.h |   46 ++++++++++--
 8 files changed, 356 insertions(+), 20 deletions(-)
 create mode 100644 fs/pstore/dump_tasks.c

-- 
1.7.9.5

