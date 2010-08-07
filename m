Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762361Ab0HGJPe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 05:15:34 -0400
Received: from mx6.orcon.net.nz ([219.88.242.56]:46373 "EHLO mx6.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762325Ab0HGJPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 05:15:32 -0400
From: Michael Cree <mcree@orcon.net.nz>
To: linux-kernel@vger.kernel.org
Cc: Michael Cree <mcree@orcon.net.nz>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] alpha: Fix printk format errors
Date: Sat,  7 Aug 2010 21:15:07 +1200
Message-Id: <1281172507-3595-1-git-send-email-mcree@orcon.net.nz>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DSPAM-Check: by mx6.orcon.net.nz on Sat, 07 Aug 2010 21:15:30 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sat Aug  7 21:15:30 2010
X-DSPAM-Confidence: 0.6568
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling alpha generic build get errors such as:
arch/alpha/kernel/err_marvel.c: In function ‘marvel_print_err_cyc’:
arch/alpha/kernel/err_marvel.c:119: error: format ‘%ld’ expects type ‘long int’, but argument 6 has type ‘u64’

Replaced a number of %ld format specifiers with %lld since u64
is unsigned long long.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
---
 arch/alpha/kernel/err_marvel.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/kernel/err_marvel.c b/arch/alpha/kernel/err_marvel.c
index 52a79df..c7f2a62 100644
--- a/arch/alpha/kernel/err_marvel.c
+++ b/arch/alpha/kernel/err_marvel.c
@@ -109,7 +109,7 @@ marvel_print_err_cyc(u64 err_cyc)
 #define IO7__ERR_CYC__CYCLE__M	(0x7)
 
 	printk("%s        Packet In Error: %s\n"
-	       "%s        Error in %s, cycle %ld%s%s\n",
+	       "%s        Error in %s, cycle %lld%s%s\n",
 	       err_print_prefix, 
 	       packet_desc[EXTRACT(err_cyc, IO7__ERR_CYC__PACKET)],
 	       err_print_prefix,
@@ -313,7 +313,7 @@ marvel_print_po7_ugbge_sym(u64 ugbge_sym)
 	}
 
 	printk("%s      Up Hose Garbage Symptom:\n"
-	       "%s        Source Port: %ld - Dest PID: %ld - OpCode: %s\n", 
+	       "%s        Source Port: %lld - Dest PID: %lld - OpCode: %s\n", 
 	       err_print_prefix,
 	       err_print_prefix, 
 	       EXTRACT(ugbge_sym, IO7__PO7_UGBGE_SYM__UPH_SRC_PORT),
@@ -552,7 +552,7 @@ marvel_print_pox_spl_cmplt(u64 spl_cmplt)
 #define IO7__POX_SPLCMPLT__REM_BYTE_COUNT__M	(0xfff)
 
 	printk("%s      Split Completion Error:\n"	
-	       "%s         Source (Bus:Dev:Func): %ld:%ld:%ld\n",
+	       "%s         Source (Bus:Dev:Func): %lld:%lld:%lld\n",
 	       err_print_prefix,
 	       err_print_prefix,
 	       EXTRACT(spl_cmplt, IO7__POX_SPLCMPLT__SOURCE_BUS),
-- 
1.7.1

