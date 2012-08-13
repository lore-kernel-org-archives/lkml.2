Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2HMUUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:20:11 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:54585 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab2HMUTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:19:53 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 13 Aug 2012 13:18:17 -0700
Message-Id: <1344889115-21610-3-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18Iodxf/O0j7pNormgBMZ4oAUXrl5HadgY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 03/21] userns: Convert sock_i_uid to return a kuid_t
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/net/sock.h |    2 +-
 net/core/sock.c    |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index b373023..65c3d62 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1668,7 +1668,7 @@ static inline void sock_graft(struct sock *sk, struct socket *parent)
 	write_unlock_bh(&sk->sk_callback_lock);
 }
 
-extern int sock_i_uid(struct sock *sk);
+extern kuid_t sock_i_uid(struct sock *sk);
 extern unsigned long sock_i_ino(struct sock *sk);
 
 static inline struct dst_entry *
diff --git a/net/core/sock.c b/net/core/sock.c
index 9c7fe4f..5c6a435 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1526,12 +1526,12 @@ void sock_edemux(struct sk_buff *skb)
 }
 EXPORT_SYMBOL(sock_edemux);
 
-int sock_i_uid(struct sock *sk)
+kuid_t sock_i_uid(struct sock *sk)
 {
-	int uid;
+	kuid_t uid;
 
 	read_lock_bh(&sk->sk_callback_lock);
-	uid = sk->sk_socket ? SOCK_INODE(sk->sk_socket)->i_uid : 0;
+	uid = sk->sk_socket ? SOCK_INODE(sk->sk_socket)->i_uid : GLOBAL_ROOT_UID;
 	read_unlock_bh(&sk->sk_callback_lock);
 	return uid;
 }
-- 
1.7.5.4

