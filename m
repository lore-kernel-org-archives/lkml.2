Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab1ABHqv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:46:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:36184 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab1ABHYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:14 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Michael Cree <mcree@orcon.net.nz>,
        Matt Turner <mattst88@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 158/260] alpha: Fix printk format errors
Date: Sun,  2 Jan 2011 02:17:34 -0500
Message-Id: <1293952756-15010-159-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jan 2011 07:23:03.0838 (UTC) FILETIME=[E4D243E0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Cree <mcree@orcon.net.nz>

commit 3e073367a57d41e506f20aebb98e308387ce3090 upstream.

When compiling alpha generic build get errors such as:
arch/alpha/kernel/err_marvel.c: In function ‘marvel_print_err_cyc’:
arch/alpha/kernel/err_marvel.c:119: error: format ‘%ld’ expects type ‘long int’, but argument 6 has type ‘u64’

Replaced a number of %ld format specifiers with %lld since u64
is unsigned long long.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/alpha/kernel/err_marvel.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/kernel/err_marvel.c b/arch/alpha/kernel/err_marvel.c
index 52a79df..5c905aa 100644
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
1.7.3.3

