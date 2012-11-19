Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab2KSKul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:50:41 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:46634 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2KSKuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:50:39 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 19 Nov 2012 02:50:17 -0800
Message-Id: <1353322222-27060-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <87k3thc1h3.fsf@xmission.com>
References: <87k3thc1h3.fsf@xmission.com>
X-XM-AID: U2FsdGVkX18pa7BKDYrPEXNuKIKzU+x3vhugrI6ZSOo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0031]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 1/6] vfs: Allow chroot if you have CAP_SYS_CHROOT in your user namespace
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Once you are confined to a user namespace applications can not gain
privilege and escape the user namespace so there is no longer a reason
to restrict chroot.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/open.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 59071f5..182d866 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -435,7 +435,7 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 		goto dput_and_out;
 
 	error = -EPERM;
-	if (!capable(CAP_SYS_CHROOT))
+	if (!nsown_capable(CAP_SYS_CHROOT))
 		goto dput_and_out;
 	error = security_path_chroot(&path);
 	if (error)
-- 
1.7.5.4

