Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab0IRT21 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:28:27 -0400
Received: from kroah.org ([198.145.64.141]:43557 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756903Ab0IRTPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:30 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:03 2010
Message-Id: <20100918191303.179306089@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robert Richter <robert.richter@amd.com>
Subject: [068/129] oprofile, x86: fix init_sysfs() function stub
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
@@ -585,8 +585,10 @@ static void exit_sysfs(void)
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


