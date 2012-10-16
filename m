Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab2JPOxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:53:00 -0400
Received: from mail.x86-64.org ([217.9.48.20]:45231 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab2JPOw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:52:57 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH -v2 0/6] AMD MCE injection improvs
Date: Tue, 16 Oct 2012 16:52:49 +0200
Message-Id: <1350399175-14477-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0.rc2.4.g42e55a5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

v2: Address all comments from last round.

v1:

So this basically moves the mce-inject module to arch/x86/ras/ and adds
a bunch of features to it.

More importantly, though, it creates all the glue to add the
arch/x86/ras/ directory to Kconfig. The idea is to gradually collect
RAS-related stuff there.

Tony, please take a look and let me know how do you find the general
layout, etc.

Thanks.

Borislav Petkov (6):
  x86, RAS: Add a barebones RAS subtree
  x86, RAS: Move AMD MCE injection code into ras/
  x86, RAS: Convert mce-inject module to debugfs
  x86, RAS: Add function enabling direct writes to MCE MSRs
  x86, RAS: Add attributes needed for HW injection
  x86, RAS: Add an injector function

 arch/x86/Kconfig              |   8 ++
 arch/x86/Makefile             |   3 +
 arch/x86/ras/Kconfig          |  14 +++
 arch/x86/ras/Makefile         |   1 +
 arch/x86/ras/amd/Makefile     |   3 +
 arch/x86/ras/amd/mce-inject.c | 274 ++++++++++++++++++++++++++++++++++++++++++
 drivers/edac/Kconfig          |  10 --
 drivers/edac/mce_amd_inj.c    | 173 --------------------------
 8 files changed, 303 insertions(+), 183 deletions(-)
 create mode 100644 arch/x86/ras/Kconfig
 create mode 100644 arch/x86/ras/Makefile
 create mode 100644 arch/x86/ras/amd/Makefile
 create mode 100644 arch/x86/ras/amd/mce-inject.c
 delete mode 100644 drivers/edac/mce_amd_inj.c

-- 
1.8.0.rc2.4.g42e55a5
