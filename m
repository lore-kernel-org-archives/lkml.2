Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126Ab0GAVoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:44:38 -0400
Received: from kroah.org ([198.145.64.141]:32860 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759094Ab0GAVOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:18 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:55 2010
Message-Id: <20100701174255.797290920@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [111/200] ARM: VFP: Fix vfp_put_double() for d16-d31
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 138de1c44a8e0606501cd8593407e9248e84f1b7 upstream.

vfp_put_double() takes the double value in r0,r1 not r1,r2.

Reported-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/vfp/vfphw.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/vfp/vfphw.S
+++ b/arch/arm/vfp/vfphw.S
@@ -277,7 +277,7 @@ ENTRY(vfp_put_double)
 #ifdef CONFIG_VFPv3
 	@ d16 - d31 registers
 	.irp	dr,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-1:	mcrr	p11, 3, r1, r2, c\dr	@ fmdrr	r1, r2, d\dr
+1:	mcrr	p11, 3, r0, r1, c\dr	@ fmdrr	r0, r1, d\dr
 	mov	pc, lr
 	.org	1b + 8
 	.endr


