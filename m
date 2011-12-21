Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab1LUHU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 02:20:56 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:58202 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1LUHUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 02:20:53 -0500
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Subject: [PATCH] [boot] Change the WARN to INFO for boot wrapper overlap
 message
To: Josh Boyer <jwboyer@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org
Date: Wed, 21 Dec 2011 12:50:38 +0530
Message-ID: <20111221072034.12043.62801.stgit@suzukikp.in.ibm.com>
In-Reply-To: <CA+5PVA7NhzxwxR5WGDmUQ432NehNnzRT+y05wve+FBXHyGaiwA@mail.gmail.com>
References: <CA+5PVA7NhzxwxR5WGDmUQ432NehNnzRT+y05wve+FBXHyGaiwA@mail.gmail.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11122107-9574-0000-0000-0000009BF4DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c55aef0e5bc6 ("powerpc/boot: Change the load address
for the wrapper to fit the kernel") introduced a WARNING to
inform the user that the uncompressed kernel would overlap
the boot uncompressing wrapper code. Change it to an INFO.

I initially thought, this would be a 'WARNING' for the those
boards, where the link_address should be fixed, so that the
user can take actions accordingly.

Changing the same to INFO.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---

 arch/powerpc/boot/wrapper |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/boot/wrapper b/arch/powerpc/boot/wrapper
index c8d6aaf..2b171cd 100755
--- a/arch/powerpc/boot/wrapper
+++ b/arch/powerpc/boot/wrapper
@@ -282,9 +282,9 @@ round_size=0x$(printf "%x" $round_size)
 link_addr=$(printf "%d" $link_address)
 
 if [ $link_addr -lt $strip_size ]; then
-    echo "WARN: Uncompressed kernel (size 0x$(printf "%x\n" $strip_size))" \
+    echo "INFO: Uncompressed kernel (size 0x$(printf "%x\n" $strip_size))" \
 		"overlaps the address of the wrapper($link_address)"
-    echo "WARN: Fixing the link_address of wrapper to ($round_size)"
+    echo "INFO: Fixing the link_address of wrapper to ($round_size)"
     link_address=$round_size
 fi
 

