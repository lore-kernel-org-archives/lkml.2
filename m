Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab1CVAB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 20:01:26 -0400
Received: from kroah.org ([198.145.64.141]:48956 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900Ab1CUXNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:13:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:51 2011
Message-Id: <20110321231051.671117050@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:09:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kamal Mostafa <kamal@canonical.com>, Yinghai Lu <yinghai@kernel.org>,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ingo Molnar <mingo@elte.hu>
Subject: [09/44] x86: Emit "mem=nopentium ignored" warning when not supported
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Kamal Mostafa <kamal@canonical.com>

commit 9a6d44b9adb777ca9549e88cd55bd8f2673c52a2 upstream.

Emit warning when "mem=nopentium" is specified on any arch other
than x86_32 (the only that arch supports it).

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
BugLink: http://bugs.launchpad.net/bugs/553464
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
LKML-Reference: <1296783486-23033-2-git-send-email-kamal@canonical.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/e820.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1236,12 +1236,15 @@ static int __init parse_memopt(char *p)
 	if (!p)
 		return -EINVAL;
 
-#ifdef CONFIG_X86_32
 	if (!strcmp(p, "nopentium")) {
+#ifdef CONFIG_X86_32
 		setup_clear_cpu_cap(X86_FEATURE_PSE);
 		return 0;
-	}
+#else
+		printk(KERN_WARNING "mem=nopentium ignored! (only supported on x86_32)\n");
+		return -EINVAL;
 #endif
+	}
 
 	userdef = 1;
 	mem_size = memparse(p, &p);


