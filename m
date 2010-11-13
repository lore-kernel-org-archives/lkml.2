Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab0KMQqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 11:46:25 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33392 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab0KMQqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 11:46:22 -0500
Date: Sat, 13 Nov 2010 08:44:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        bluesmoke-devel@lists.sourceforge.net
Subject: [PATCH -next] edac: use BIT_64() to eliminate warnings
Message-Id: <20101113084426.b26f1d88.randy.dunlap@oracle.com>
In-Reply-To: <20101112130547.c2a3c2c1.sfr@canb.auug.org.au>
References: <20101112130547.c2a3c2c1.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Building for X86_32 produces shift count warnings, so use
BIT_64() to eliminate the warnings.

drivers/edac/mce_amd.c:778: warning: left shift count >= width of type
drivers/edac/mce_amd.c:778: warning: left shift count >= width of type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: bluesmoke-devel@lists.sourceforge.net
---
 drivers/edac/mce_amd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20101112.orig/drivers/edac/mce_amd.c
+++ linux-next-20101112/drivers/edac/mce_amd.c
@@ -776,8 +776,8 @@ int amd_decode_mce(struct notifier_block
 
 	if (c->x86 == 0x15)
 		pr_cont("|%s|%s",
-			((m->status & BIT(44))	? "Deferred" : "-"),
-			((m->status & BIT(43))	? "Poison"   : "-"));
+			((m->status & BIT_64(44)) ? "Deferred" : "-"),
+			((m->status & BIT_64(43)) ? "Poison"   : "-"));
 
 	/* do the two bits[14:13] together */
 	ecc = (m->status >> 45) & 0x3;
