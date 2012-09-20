Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab2ITLmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:42:44 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51876 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab2ITLmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:42:39 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 20 Sep 2012 04:41:45 -0700
Message-Id: <1348141326-23355-4-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19j2BrcakScv5rCjhqZ1nRQy2NKhSkHPUc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 04/25] userns: Convert devtmpfs to use GLOBAL_ROOT_UID and GLOBAL_ROOT_GID
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/base/devtmpfs.c |    4 ++--
 init/Kconfig            |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index deb4a45..147d1a4 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -309,8 +309,8 @@ static int handle_remove(const char *nodename, struct device *dev)
 			 * before unlinking this node, reset permissions
 			 * of possible references like hardlinks
 			 */
-			newattrs.ia_uid = 0;
-			newattrs.ia_gid = 0;
+			newattrs.ia_uid = GLOBAL_ROOT_UID;
+			newattrs.ia_gid = GLOBAL_ROOT_GID;
 			newattrs.ia_mode = stat.mode & ~0777;
 			newattrs.ia_valid =
 				ATTR_UID|ATTR_GID|ATTR_MODE;
diff --git a/init/Kconfig b/init/Kconfig
index e7e0cc1..96007af 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -932,7 +932,6 @@ config UIDGID_CONVERTED
 	depends on NET_9P = n
 
 	# Filesystems
-	depends on DEVTMPFS = n
 	depends on XENFS = n
 
 	depends on 9P_FS = n
-- 
1.7.5.4

