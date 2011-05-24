Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab1EXFlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:41:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62306 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1EXFlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:41:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YMq2hcSYIDHRTp+WZylXXgoSQ2k7ovR2LR4vYLtpp/gBOxzyyq9nNGR8XDqdrBX7Sp
         6LLodk97pp0rWfTCHh6a/kgROOY8yIPn+p4xIhBWwPqbdgj5Ye9aiJtueM1NtCG3s8Lr
         HRH1DfJFvfL97EztOHIwhpUN31CjC50yZZqRM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2]net:8021q:vlan.c Fix pr_info to just give the vlan fullname and version.
Date: Mon, 23 May 2011 22:40:47 -0700
Message-Id: <1306215647-2857-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch removes vlan_buggyright and vlan_copyright from vlan_proto_init, 
so that it prints out just the fullname of vlan and the version number.

before:

[   30.438203] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   30.441542] All bugs added by David S. Miller <davem@redhat.com>

after:

[   31.513910] 802.1Q VLAN Support v1.8

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Joe Perches <joe@perches.com>
CC: David S. Miller <davem@davemloft.net>
CC: Ben Greear <greearb@candelatech.com>
---
 net/8021q/vlan.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index b2274d1..9df3fcb 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -673,8 +673,7 @@ static int __init vlan_proto_init(void)
 {
 	int err;
 
-	pr_info("%s v%s %s\n", vlan_fullname, vlan_version, vlan_copyright);
-	pr_info("All bugs added by %s\n", vlan_buggyright);
+	pr_info("%s v%s\n", vlan_fullname, vlan_version);
 
 	err = register_pernet_subsys(&vlan_net_ops);
 	if (err < 0)
-- 
1.7.5.1

