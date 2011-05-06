Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab1EFAaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:30:20 -0400
Received: from kroah.org ([198.145.64.141]:37635 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932726Ab1EFA1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:27:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:26:10 2011
Message-Id: <20110506002610.486565457@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:25:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Borislav Petkov <borislav.petkov@amd.com>,
        Boris Ostrovsky <Boris.Ostrovsky@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: [33/43] x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors
In-Reply-To: <20110506002625.GA20426@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Boris Ostrovsky <ostr@amd64.org>

commit e20a2d205c05cef6b5783df339a7d54adeb50962 upstream.

Older AMD K8 processors (Revisions A-E) are affected by erratum
400 (APIC timer interrupts don't occur in C states greater than
C1). This, for example, means that X86_FEATURE_ARAT flag should
not be set for these parts.

This addresses regression introduced by commit
b87cf80af3ba4b4c008b4face3c68d604e1715c6 ("x86, AMD: Set ARAT
feature on AMD processors") where the system may become
unresponsive until external interrupt (such as keyboard input)
occurs. This results, for example, in time not being reported
correctly, lack of progress on the system and other lockups.

Reported-by: Joerg-Volker Peetz <jvpeetz@web.de>
Tested-by: Joerg-Volker Peetz <jvpeetz@web.de>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Boris Ostrovsky <Boris.Ostrovsky@amd.com>
Link: http://lkml.kernel.org/r/1304113663-6586-1-git-send-email-ostr@amd64.org
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
-	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
+	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0x0f, 0x4, 0x2, 0xff, 0xf),
 			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
 
 


