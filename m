Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab2DHFMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:12:19 -0400
Received: from out08.mta.xmission.com ([166.70.13.238]:56890 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751507Ab2DHFMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:14 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:00 -0700
Message-Id: <1333862139-31737-4-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19PcH6QXDDwr7N7CbFHb6CamljP9a/9Olo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 04/43] userns: Remove unnecessary cast to struct user_struct when copying cred->user.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

In struct cred the user member is and has always been declared struct user_struct *user.
At most a constant struct cred will have a constant pointer to non-constant user_struct
so remove this unnecessary cast.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/sys.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index e7006eb..f7a4351 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -209,7 +209,7 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
-			user = (struct user_struct *) cred->user;
+			user = cred->user;
 			if (!who)
 				who = cred->uid;
 			else if ((who != cred->uid) &&
@@ -274,7 +274,7 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
 			break;
 		case PRIO_USER:
-			user = (struct user_struct *) cred->user;
+			user = cred->user;
 			if (!who)
 				who = cred->uid;
 			else if ((who != cred->uid) &&
-- 
1.7.2.5

