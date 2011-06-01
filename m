Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162597Ab1FAIWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:22:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:44675 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161492Ab1FAIV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:21:56 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:36 2011
Message-Id: <20110601081135.638644393@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:47 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Boris Ostrovsky <ostr@amd64.org>,
        Hans Rosenfeld <Hans.Rosenfeld@amd.com>,
        Andreas Herrmann <Andreas.Herrmann3@amd.com>,
        Chuck Ebbert <cebbert@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [077/165] x86, amd: Do not enable ARAT feature on AMD processors below
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 family 0x12
Content-Length: 1634
Lines: 46

From: Boris Ostrovsky <ostr@amd64.org>

commit e9cdd343a5e42c43bcda01e609fa23089e026470 upstream.

Commit b87cf80af3ba4b4c008b4face3c68d604e1715c6 added support for
ARAT (Always Running APIC timer) on AMD processors that are not
affected by erratum 400. This erratum is present on certain processor
families and prevents APIC timer from waking up the CPU when it
is in a deep C state, including C1E state.

Determining whether a processor is affected by this erratum may
have some corner cases and handling these cases is somewhat
complicated. In the interest of simplicity we won't claim ARAT
support on processor families below 0x12 and will go back to
broadcasting timer when going idle.

Signed-off-by: Boris Ostrovsky <ostr@amd64.org>
Link: http://lkml.kernel.org/r/1306423192-19774-1-git-send-email-ostr@amd64.org
Tested-by: Boris Petkov <borislav.petkov@amd.com>
Cc: Hans Rosenfeld <Hans.Rosenfeld@amd.com>
Cc: Andreas Herrmann <Andreas.Herrmann3@amd.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/amd.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -612,8 +612,11 @@ static void __cpuinit init_amd(struct cp
 	}
 #endif
 
-	/* As a rule processors have APIC timer running in deep C states */
-	if (c->x86 > 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+	/*
+	 * Family 0x12 and above processors have APIC timer
+	 * running in deep C states.
+	 */
+	if (c->x86 > 0x11)
 		set_cpu_cap(c, X86_FEATURE_ARAT);
 
 	/*


