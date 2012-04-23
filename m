Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab2DWWJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:09:04 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56893 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2DWWJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:09:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
References: <20120423170701.c96e402234b1387dece11dda@canb.auug.org.au>
	<4F958598.6080305@xenotime.net>
Date: Mon, 23 Apr 2012 15:13:02 -0700
In-Reply-To: <4F958598.6080305@xenotime.net> (Randy Dunlap's message of "Mon,
	23 Apr 2012 09:38:48 -0700")
Message-ID: <m1lilmt7v5.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18uWFnuy+tzupSkyfimOaOtqOCfjbuD27g=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  8.5 XMNoUri_00 BODY: domains not in uri format
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
Subject: [PATCH] net sysctl: Add place holder functions for when sysctl support is compiled out of the kernel.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Randy Dunlap <rdunlap@xenotime.net> reported:
> On 04/23/2012 12:07 AM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20120420:
>
>
>
> ERROR: "unregister_net_sysctl_table" [net/phonet/phonet.ko] undefined!
> ERROR: "register_net_sysctl" [net/phonet/phonet.ko] undefined!
>
> when CONFIG_SYSCTL is not enabled.

Add static inline stub functions to gracefully handle the case when sysctl
support is not present.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/net/net_namespace.h |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 3ee4a3d..ac9195e 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -284,11 +284,20 @@ struct ctl_table_header;
 
 #ifdef CONFIG_SYSCTL
 extern int net_sysctl_init(void);
-#else
-static inline int net_sysctl_init(void) { return 0; }
-#endif
 extern struct ctl_table_header *register_net_sysctl(struct net *net,
 	const char *path, struct ctl_table *table);
 extern void unregister_net_sysctl_table(struct ctl_table_header *header);
+#else
+static inline int net_sysctl_init(void) { return 0; }
+static inline struct ctl_table_header *register_net_sysctl(struct net *net,
+	const char *path, struct ctl_table *table)
+{
+	return NULL;
+}
+static inline void unregister_net_sysctl_table(struct ctl_table_header *header)
+{
+}
+#endif
+
 
 #endif /* __NET_NET_NAMESPACE_H */
-- 
1.7.2.5

