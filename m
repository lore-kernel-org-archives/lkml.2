Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031535Ab2I1TmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:42:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965278Ab2I1S7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:59:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Fengguang Wu <fengguang.wu@intel.com>,
        Alex Iannicelli <alex.iannicelli@emulex.com>,
        James Smart <james.smart@emulex.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Mike Pagano <mpagano@gentoo.org>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 121/262] SCSI: lpfc: fix problems with -Werror
Date: Fri, 28 Sep 2012 11:50:50 -0700
Message-Id: <20120928183012.385810367@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <jbottomley@parallels.com>

commit 4bdd03e61b7a5c4c6bc2b25d46fcd491788fdfb3 upstream.

Commit d38bd3aef ("Add -Werror compilation flag") is causing build breakage
with random gcc incarnations.  These look like gcc problems, but we shouldn't
break the build because of a bad gcc.  Fix this by adding a make flag

WARNINGS_BECOME_ERRORS=1

which is the same as aic7xxx uses so ordinarily the build doesn't use -Werror

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Alex Iannicelli <alex.iannicelli@emulex.com>
Cc: James Smart <james.smart@emulex.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Cc: Mike Pagano <mpagano@gentoo.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>

---
 drivers/scsi/lpfc/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/lpfc/Makefile
+++ b/drivers/scsi/lpfc/Makefile
@@ -22,7 +22,9 @@
 ccflags-$(GCOV) := -fprofile-arcs -ftest-coverage
 ccflags-$(GCOV) += -O0
 
+ifdef WARNINGS_BECOME_ERRORS
 ccflags-y += -Werror
+endif
 
 obj-$(CONFIG_SCSI_LPFC) := lpfc.o
 


