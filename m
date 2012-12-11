Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab2LKREw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:04:52 -0500
Received: from mga03.intel.com ([143.182.124.21]:7481 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab2LKREv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:04:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,260,1355126400"; 
   d="scan'208";a="229995075"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] pstore fixes for 3.8 merge window
Date: Tue, 11 Dec 2012 09:04:50 -0800
Message-Id: <50c767b243957db9@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9489e9dcae718d5fde988e4a684a0f55b5f94d17:

  Linux 3.7-rc7 (2012-11-25 17:59:19 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git tags/please-pull-pstore_mevent

for you to fetch changes up to f94ec0c0594ef73ab3a2f1f32735aca8ddaf65e2:

  efi_pstore: Add a format check for an existing variable name at erasing time (2012-11-26 16:08:37 -0800)

----------------------------------------------------------------
Patch series to allow EFI variable backend to pstore
to hold multiple records.

----------------------------------------------------------------
Seiji Aguchi (7):
      efi_pstore: Check remaining space with QueryVariableInfo() before writing data
      efi_pstore: Add a logic erasing entries to an erase callback
      efi_pstore: Remove a logic erasing entries from a write callback to hold multiple logs
      efi_pstore: Add ctime to argument of erase callback
      efi_pstore: Add a sequence counter to a variable name
      efi_pstore: Add a format check for an existing variable name at reading time
      efi_pstore: Add a format check for an existing variable name at erasing time

 drivers/acpi/apei/erst.c   |   16 ++---
 drivers/firmware/efivars.c |  163 +++++++++++++++++++++++++++++++-------------
 fs/pstore/inode.c          |    7 +-
 fs/pstore/internal.h       |    2 +-
 fs/pstore/platform.c       |   13 ++--
 fs/pstore/ram.c            |    9 ++-
 include/linux/efi.h        |    1 +
 include/linux/pstore.h     |    6 +-
 8 files changed, 144 insertions(+), 73 deletions(-)
