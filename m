Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab2KSKvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:51:12 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49376 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2KSKu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:50:57 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 19 Nov 2012 02:50:22 -0800
Message-Id: <1353322222-27060-6-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353322222-27060-1-git-send-email-ebiederm@xmission.com>
References: <87k3thc1h3.fsf@xmission.com>
 <1353322222-27060-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX186pvFz/eXSxBHKMj2MJgjfgdSzvZTK0SE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 6/6] userns: fix return value on mntns_install() failure
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Hongjiang <zhaohongjiang@huawei.com>

Change return value from -EINVAL to -EPERM when the permission check fails.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/namespace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 9ddc86f..cab78a7 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2775,7 +2775,7 @@ static int mntns_install(struct nsproxy *nsproxy, void *ns)
 
 	if (!ns_capable(mnt_ns->user_ns, CAP_SYS_ADMIN) ||
 	    !nsown_capable(CAP_SYS_CHROOT))
-		return -EINVAL;
+		return -EPERM;
 
 	if (fs->users != 1)
 		return -EINVAL;
-- 
1.7.5.4

