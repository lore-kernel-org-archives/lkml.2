Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab0HBRwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:52:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62334 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab0HBRwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:52:35 -0400
Date: Mon, 2 Aug 2010 10:52:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        John Johansen <john.johansen@canonical.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH -next] apparmor: depends on NET
Message-Id: <20100802105218.c2050fff.randy.dunlap@oracle.com>
In-Reply-To: <20100802144432.70293bda.sfr@canb.auug.org.au>
References: <20100802144432.70293bda.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C5705D9.00FA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

SECURITY_APPARMOR should depend on NET since AUDIT needs
(depends on) NET.

Fixes 70-80 errors that occur when CONFIG_NET is not enabled,
but APPARMOR selects AUDIT without qualification.  E.g.:

audit.c:(.text+0x33361): undefined reference to `netlink_unicast'
(.text+0x333df): undefined reference to `netlink_unicast'
audit.c:(.text+0x3341d): undefined reference to `skb_queue_tail'
audit.c:(.text+0x33424): undefined reference to `kfree_skb'
audit.c:(.text+0x334cb): undefined reference to `kfree_skb'
audit.c:(.text+0x33597): undefined reference to `skb_put'
audit.c:(.text+0x3369b): undefined reference to `__alloc_skb'
audit.c:(.text+0x336d7): undefined reference to `kfree_skb'
(.text+0x3374c): undefined reference to `__alloc_skb'
auditfilter.c:(.text+0x35305): undefined reference to `skb_queue_tail'
lsm_audit.c:(.text+0x2873): undefined reference to `init_net'
lsm_audit.c:(.text+0x2878): undefined reference to `dev_get_by_index'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: John Johansen <john.johansen@canonical.com>
---
 security/apparmor/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100802.orig/security/apparmor/Kconfig
+++ linux-next-20100802/security/apparmor/Kconfig
@@ -1,6 +1,6 @@
 config SECURITY_APPARMOR
 	bool "AppArmor support"
-	depends on SECURITY
+	depends on SECURITY && NET
 	select AUDIT
 	select SECURITY_PATH
 	select SECURITYFS
