Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0HXQL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:11:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291Ab0HXQL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:11:26 -0400
Message-ID: <4C73EF2A.1030201@suse.com>
Date: Tue, 24 Aug 2010 12:11:22 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Sjur Braendeland <sjur.brandeland@stericsson.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] caif: Use asm/unaligned.h
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

caif does not build on ia64 starting with 2.6.32-rc1. Using asm/unaligned.h
instead of linux/unaligned/le_byteshift.h fixes the issue.

include/linux/unaligned/le_byteshift.h:40:50: error: redefinition of 'get_unaligned_le16'
include/linux/unaligned/le_byteshift.h:45:50: error: redefinition of 'get_unaligned_le32'
include/linux/unaligned/le_byteshift.h:50:50: error: redefinition of 'get_unaligned_le64'
include/linux/unaligned/le_byteshift.h:55:51: error: redefinition of 'put_unaligned_le16'
include/linux/unaligned/le_byteshift.h:60:51: error: redefinition of 'put_unaligned_le32'
include/linux/unaligned/le_byteshift.h:65:51: error: redefinition of 'put_unaligned_le64'
include/linux/unaligned/le_struct.h:31:51: note: previous definition of 'put_unaligned_le64' was here

---
 net/caif/cfrfml.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/caif/cfrfml.c
+++ b/net/caif/cfrfml.c
@@ -7,7 +7,7 @@
 #include <linux/stddef.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
-#include <linux/unaligned/le_byteshift.h>
+#include <asm/unaligned.h>
 #include <net/caif/caif_layer.h>
 #include <net/caif/cfsrvl.h>
 #include <net/caif/cfpkt.h>
-- 
Jeff Mahoney
SUSE Labs
