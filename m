Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2ITByK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:54:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49349 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab2ITBxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:53:17 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 19 Sep 2012 18:52:10 -0700
Message-Id: <1348105949-25454-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/X+DUSkLXi4ghY2a58ukSun8tZ5UCE/iE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 08/27] audit: Remove the unused uid parameter from audit_receive_filter
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/audit.h |    2 +-
 kernel/audit.c        |    4 ++--
 kernel/auditfilter.c  |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 9c9af0e..b9c5b22 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -702,7 +702,7 @@ extern int		    audit_update_lsm_rules(void);
 				/* Private API (for audit.c only) */
 extern int audit_filter_user(void);
 extern int audit_filter_type(int type);
-extern int  audit_receive_filter(int type, int pid, int uid, int seq,
+extern int  audit_receive_filter(int type, int pid, int seq,
 				void *data, size_t datasz, uid_t loginuid,
 				u32 sessionid, u32 sid);
 extern int audit_enabled;
diff --git a/kernel/audit.c b/kernel/audit.c
index 9dd4d09..a31e31b 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -771,7 +771,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		/* fallthrough */
 	case AUDIT_LIST:
 		err = audit_receive_filter(msg_type, NETLINK_CB(skb).pid,
-					   uid, seq, data, nlmsg_len(nlh),
+					   seq, data, nlmsg_len(nlh),
 					   loginuid, sessionid, sid);
 		break;
 	case AUDIT_ADD_RULE:
@@ -790,7 +790,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		/* fallthrough */
 	case AUDIT_LIST_RULES:
 		err = audit_receive_filter(msg_type, NETLINK_CB(skb).pid,
-					   uid, seq, data, nlmsg_len(nlh),
+					   seq, data, nlmsg_len(nlh),
 					   loginuid, sessionid, sid);
 		break;
 	case AUDIT_TRIM:
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index b754f43..e242dd9 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1098,7 +1098,7 @@ static void audit_log_rule_change(uid_t loginuid, u32 sessionid, u32 sid,
  * @sessionid: sessionid for netlink audit message
  * @sid: SE Linux Security ID of sender
  */
-int audit_receive_filter(int type, int pid, int uid, int seq, void *data,
+int audit_receive_filter(int type, int pid, int seq, void *data,
 			 size_t datasz, uid_t loginuid, u32 sessionid, u32 sid)
 {
 	struct task_struct *tsk;
-- 
1.7.5.4

