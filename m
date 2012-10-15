Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab2JOLoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:44:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab2JOLoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:44:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/4] FRV: Fix const sections change
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, David Howells <dhowells@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 15 Oct 2012 12:43:57 +0100
Message-ID: <20121015114357.1042.62017.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121015114343.1042.81528.stgit@warthog.procyon.org.uk>
References: <20121015114343.1042.81528.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

Add __pminitconst to fix the build, otherwise the following error can occur:

	arch/frv/kernel/setup.c:187:47: error: expected '=', ',', ';', 'asm' or '__attribute__' before '*' token
	arch/frv/kernel/setup.c:386:2: error: 'clock_cmodes' undeclared (first use in this function)
	arch/frv/kernel/setup.c:571:6: error: 'clock_cmodes' undeclared (first use in this function)
	make[2]: *** [arch/frv/kernel/setup.o] Error 1

http://kisskb.ellerman.id.au/kisskb/buildresult/7344691/

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>
---

 arch/frv/kernel/setup.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
index 1f1e5ef..b8993c8 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -112,9 +112,11 @@ char __initdata redboot_command_line[COMMAND_LINE_SIZE];
 #ifdef CONFIG_PM
 #define __pminit
 #define __pminitdata
+#define __pminitconst
 #else
 #define __pminit __init
 #define __pminitdata __initdata
+#define __pminitconst __initconst
 #endif
 
 struct clock_cmode {

