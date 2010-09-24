Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877Ab0IXQ3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:29:09 -0400
Received: from kroah.org ([198.145.64.141]:38637 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932865Ab0IXQ3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:29:05 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:21 2010
Message-Id: <20100924162621.890921297@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:25:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Cree <mcree@orcon.net.nz>, Matt Turner <mattst88@gmail.com>
Subject: [80/80] alpha: Fix printk format errors
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Cree <mcree@orcon.net.nz>

commit 3e073367a57d41e506f20aebb98e308387ce3090 upstream.

When compiling alpha generic build get errors such as:
arch/alpha/kernel/err_marvel.c: In function ‘marvel_print_err_cyc’:
arch/alpha/kernel/err_marvel.c:119: error: format ‘%ld’ expects type ‘long int’, but argument 6 has type ‘u64’

Replaced a number of %ld format specifiers with %lld since u64
is unsigned long long.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/alpha/kernel/err_marvel.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
@@ -313,7 +313,7 @@ marvel_print_po7_ugbge_sym(u64 ugbge_sym
 	}
 
 	printk("%s      Up Hose Garbage Symptom:\n"
-	       "%s        Source Port: %ld - Dest PID: %ld - OpCode: %s\n", 
+	       "%s        Source Port: %lld - Dest PID: %lld - OpCode: %s\n",
 	       err_print_prefix,
 	       err_print_prefix, 
 	       EXTRACT(ugbge_sym, IO7__PO7_UGBGE_SYM__UPH_SRC_PORT),
@@ -552,7 +552,7 @@ marvel_print_pox_spl_cmplt(u64 spl_cmplt
 #define IO7__POX_SPLCMPLT__REM_BYTE_COUNT__M	(0xfff)
 
 	printk("%s      Split Completion Error:\n"	
-	       "%s         Source (Bus:Dev:Func): %ld:%ld:%ld\n",
+	       "%s         Source (Bus:Dev:Func): %lld:%lld:%lld\n",
 	       err_print_prefix,
 	       err_print_prefix,
 	       EXTRACT(spl_cmplt, IO7__POX_SPLCMPLT__SOURCE_BUS),


