Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab2ITBxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:53:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46203 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab2ITBxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:53:13 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 19 Sep 2012 18:52:09 -0700
Message-Id: <1348105949-25454-7-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19WUmM2R7fbXs3RZwcdfxi6yRHYVCn7ghg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 07/27] audit: Properly set the origin port id of audit messages.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

For user generated audit messages set the portid field in the netlink
header to the netlink port where the user generated audit message came
from.  Reporting the process id in a port id field was just nonsense.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/audit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 2a8728f..9dd4d09 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -751,7 +751,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 					size--;
 				audit_log_n_untrustedstring(ab, data, size);
 			}
-			audit_set_pid(ab, pid);
+			audit_set_pid(ab, NETLINK_CB(skb).pid);
 			audit_log_end(ab);
 		}
 		break;
-- 
1.7.5.4

