Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab2HPXYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 19:24:53 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:41075 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756961Ab2HPXYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 19:24:51 -0400
Message-ID: <502D80E8.3080008@xenotime.net>
Date: Thu, 16 Aug 2012 16:23:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
CC: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: [PATCH] scripts/kernel-doc: fix fatal script error
References: <CA+55aFzDpQmE1n__kaW4unfuzhPstKzp41GseL_AwuE-8_bAig@mail.gmail.com>
In-Reply-To: <CA+55aFzDpQmE1n__kaW4unfuzhPstKzp41GseL_AwuE-8_bAig@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix fatal error in scripts/kernel-doc by ignoring the "__weak" attribute:

Error(drivers/pci/pci.c:2820): cannot understand prototype: 'char * __weak pcibios_setup(char *str) '

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 scripts/kernel-doc |    1 +
 1 file changed, 1 insertion(+)

--- lnx-36-rc2.orig/scripts/kernel-doc
+++ lnx-36-rc2/scripts/kernel-doc
@@ -1786,6 +1786,7 @@ sub dump_function($$) {
     $prototype =~ s/__init +//;
     $prototype =~ s/__init_or_module +//;
     $prototype =~ s/__must_check +//;
+    $prototype =~ s/__weak +//;
     $prototype =~ s/^#\s*define\s+//; #ak added
     $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
 
