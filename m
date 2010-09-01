Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab0IAQn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 12:43:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40764 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab0IAQn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 12:43:28 -0400
Date: Wed, 1 Sep 2010 09:41:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Robert Richter <robert.richter@amd.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH next&mainline] oprofile: fix build when CONFIG_PM is
 disabled
Message-Id: <20100901094132.e734ad94.randy.dunlap@oracle.com>
In-Reply-To: <20100901133614.2580f238.sfr@canb.auug.org.au>
References: <20100901133614.2580f238.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Using do/while for a function-returning-a-value does not
make gcc happy, so change it to a static inline function.
(happens when CONFIG_PM is not enabled)

arch/x86/oprofile/nmi_int.c:784: error: expected expression before 'do'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/oprofile/nmi_int.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-next-20100901.orig/arch/x86/oprofile/nmi_int.c
+++ linux-next-20100901/arch/x86/oprofile/nmi_int.c
@@ -585,7 +585,10 @@ static void exit_sysfs(void)
 }
 
 #else
-#define init_sysfs() do { } while (0)
+static inline int init_sysfs(void)
+{
+	return 0;
+}
 #define exit_sysfs() do { } while (0)
 #endif /* CONFIG_PM */
 
