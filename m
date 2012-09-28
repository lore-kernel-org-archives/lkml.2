Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032496Ab2I1U0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:26:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031326Ab2I1U0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:26:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Fengguang Wu <fengguang.wu@intel.com>,
        Alex Iannicelli <alex.iannicelli@emulex.com>,
        James Smart <james.smart@emulex.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Mike Pagano <mpagano@gentoo.org>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 095/218] SCSI: lpfc: fix problems with -Werror
Date: Fri, 28 Sep 2012 13:15:12 -0700
Message-Id: <20120928201512.451907181@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
 


