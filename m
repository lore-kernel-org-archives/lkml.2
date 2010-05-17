Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab0EQQnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:43:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39338 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab0EQQn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:43:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=oqlYO5Q4pFA6/fh7bFwQcxuGRNWtsGA9wYxnv/X4fVP+9N7QvXs7QMWVFGIrSVWnca
         xV0NaXNyqie1KEq4ALVq3WRcGruf3IWm1xCpvNRVuH/ZVa6cI1z/fN+q9+Pj9xinWakE
         +136+yAeHoKjE2+ZsICybvDtvPYPqLmFX9M+s=
Date: Mon, 17 May 2010 18:43:24 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] x86, hpet: Add reference to chipset erratum documentation
 for disable-hpet-msi-quirk
Message-ID: <20100517164324.GB10254@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

(At the moment the "SB700 Family Product Errata" document is available
at http://support.amd.com/us/Embedded_TechDocs/46837.pdf)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/quirks.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

Linus recommended to add a pointer to that erratum to the source.  See

  http://marc.info/?i=alpine.LFD.2.00.1005170811400.4195@i5.linux-foundation.org

Please apply.


Thanks,

Andreas


diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index cd2c336..e72d3fc 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -495,6 +495,9 @@ void force_hpet_resume(void)
 /*
  * HPET MSI on some boards (ATI SB700/SB800) has side effect on
  * floppy DMA. Disable HPET MSI on such platforms.
+ * See erratum #27 (Misinterpreted MSI Requests May Result in
+ * Corrupted LPC DMA Data) in AMD Publication #46837,
+ * "SB700 Family Product Errata", Rev. 1.0, March 2010.
  *
  * Also force the read back of the CMP register in hpet_next_event()
  * to work around the problem that the CMP register write seems to be
-- 
1.6.4.4

