Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab0IRTCk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:40 -0400
Received: from kroah.org ([198.145.64.141]:51303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab0IRTBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:35 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:56 2010
Message-Id: <20100918185956.259536722@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robert Richter <robert.richter@amd.com>
Subject: [040/123] oprofile, x86: fix init_sysfs() function stub
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=oprofile-x86-fix-init_sysfs-function-stub.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

commit 269f45c25028c75fe10e6d9be86e7202ab461fbc upstream.

The use of the return value of init_sysfs() with commit

 10f0412 oprofile, x86: fix init_sysfs error handling

discovered the following build error for !CONFIG_PM:

 .../linux/arch/x86/oprofile/nmi_int.c: In function ‘op_nmi_init’:
 .../linux/arch/x86/oprofile/nmi_int.c:784: error: expected expression before ‘do’
 make[2]: *** [arch/x86/oprofile/nmi_int.o] Error 1
 make[1]: *** [arch/x86/oprofile] Error 2

This patch fixes this.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/oprofile/nmi_int.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -535,8 +535,10 @@ static void exit_sysfs(void)
 }
 
 #else
-#define init_sysfs() do { } while (0)
-#define exit_sysfs() do { } while (0)
+
+static inline int  init_sysfs(void) { return 0; }
+static inline void exit_sysfs(void) { }
+
 #endif /* CONFIG_PM */
 
 static int __init p4_init(char **cpu_type)


