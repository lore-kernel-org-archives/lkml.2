Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1CBRP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:15:57 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:48421 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab1CBRP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:15:56 -0500
Date: Wed, 2 Mar 2011 18:15:44 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Nathan Lynch <ntl@pobox.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] bloat-o-meter: Include read-only data section in report
Message-ID: <20110302181544.2f1b3be9@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure why the read-only data section is excluded from the
report, it seems as relevant as the other data sections (b and d).

I've stripped the symbols starting with __mod_ as they can have their
names dynamically generated and thus comparison between binaries is
not possible.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
Disclaimer: I don't know anything about python.

 scripts/bloat-o-meter |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.38-rc6.orig/scripts/bloat-o-meter	2011-03-02 17:55:46.000000000 +0100
+++ linux-2.6.38-rc6/scripts/bloat-o-meter	2011-03-02 17:57:05.000000000 +0100
@@ -17,7 +17,9 @@ def getsizes(file):
     sym = {}
     for l in os.popen("nm --size-sort " + file).readlines():
         size, type, name = l[:-1].split()
-        if type in "tTdDbB":
+        if type in "tTdDbBrR":
+            # strip generated symbols
+            if name[:6] == "__mod_": continue
             # function names begin with '.' on 64-bit powerpc
             if "." in name[1:]: name = "static." + name.split(".")[0]
             sym[name] = sym.get(name, 0) + int(size, 16)


-- 
Jean Delvare
