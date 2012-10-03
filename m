Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab2JCXED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:04:03 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59444 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265Ab2JCXEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:04:02 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 03 Oct 2012 16:03:54 -0700
Message-ID: <87626r17l1.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX191OfLRJWzmbrZyoQb7d+dPw5Z6MjwPkN0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [GIT PULL] user namespace compile fix for 3.7
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the for-linus git tree from:

   git://git.kernel.org:/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus

   HEAD: 702e490211b2b7e448ebe1b3a07d97ad2fc07e03 userns: Fix build of drivers/staging/dgrp

This tree contains a trivial build fix for one of the staging drivers
when user namespace support is enabled.

---
Subject: [PATCH] userns: Fix build of drivers/staging/dgrp

Explicitly test for GLOBAL_ROOT_UID and GLOBAL_ROOT_GID
instead of using 0, allowing dgrp to compile and work
properly when user namespace support is enabled.

Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/staging/dgrp/dgrp_common.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_common.c b/drivers/staging/dgrp/dgrp_common.c
index fce74e7..3553998 100644
--- a/drivers/staging/dgrp/dgrp_common.c
+++ b/drivers/staging/dgrp/dgrp_common.c
@@ -179,9 +179,9 @@ void dgrp_carrier(struct ch_struct *ch)
  */
 int dgrp_chk_perm(int mode, int op)
 {
-	if (!current_euid())
+	if (!uid_eq(GLOBAL_ROOT_UID, current_euid()))
 		mode >>= 6;
-	else if (in_egroup_p(0))
+	else if (in_egroup_p(GLOBAL_ROOT_GID))
 		mode >>= 3;
 
 	if ((mode & op & 0007) == op)
-- 
1.7.5.4

