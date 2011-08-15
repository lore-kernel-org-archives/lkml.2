Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab1HORSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 13:18:50 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:55644 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751259Ab1HORSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 13:18:49 -0400
Date: Mon, 15 Aug 2011 10:18:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3.1-rc2] x86: fix mm/fault.c build
Message-Id: <20110815101846.58809a89.rdunlap@xenotime.net>
In-Reply-To: <CA+55aFycTvbuNzdgbHjoiNkTeDpzgu6Yf=vx9DU+PDOtC_17zA@mail.gmail.com>
References: <CA+55aFycTvbuNzdgbHjoiNkTeDpzgu6Yf=vx9DU+PDOtC_17zA@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

arch/x86/mm/fault.c needs to include asm/vsyscall.h to fix a
build error:

arch/x86/mm/fault.c: In function '__bad_area_nosemaphore':
arch/x86/mm/fault.c:728: error: 'VSYSCALL_START' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 arch/x86/mm/fault.c |    1 +
 1 file changed, 1 insertion(+)

--- lnx-31-rc2.orig/arch/x86/mm/fault.c
+++ lnx-31-rc2/arch/x86/mm/fault.c
@@ -17,6 +17,7 @@
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
+#include <asm/vsyscall.h>
 
 /*
  * Page fault error code bits:
