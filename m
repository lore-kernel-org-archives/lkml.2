Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934415Ab1ESScv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:32:51 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52825 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934356Ab1ESScs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:32:48 -0400
X-Sasl-enc: w1YW1uchhcoDE8UDoWaduoPEjdVApMFWLC4Dnz10PdUq 1305829967
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:31:27 2011
Message-Id: <20110519183127.312798579@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:30:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>
Subject: [17/24] Revert "x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors"
In-Reply-To: <20110519182446.GA23751@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1302
Lines: 43

From: Borislav Petkov <borislav.petkov@amd.com>

commit 328935e6348c6a7cb34798a68c326f4b8372e68a upstream.

This reverts commit e20a2d205c05cef6b5783df339a7d54adeb50962, as it crashes
certain boxes with specific AMD CPU models.

Moving the lower endpoint of the Erratum 400 check to accomodate
earlier K8 revisions (A-E) opens a can of worms which is simply
not worth to fix properly by tweaking the errata checking
framework:

* missing IntPenging MSR on revisions < CG cause #GP:

http://marc.info/?l=linux-kernel&m=130541471818831

* makes earlier revisions use the LAPIC timer instead of the C1E
idle routine which switches to HPET, thus not waking up in
deeper C-states:

http://lkml.org/lkml/2011/4/24/20

Therefore, leave the original boundary starting with K8-revF.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -651,7 +651,7 @@ cpu_dev_register(amd_cpu_dev);
  */
 
 const int amd_erratum_400[] =
-	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0x0f, 0x4, 0x2, 0xff, 0xf),
+	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
 			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
 
 


