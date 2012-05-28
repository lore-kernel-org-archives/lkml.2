Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2E1Dea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:34:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52239 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753788Ab2E1D3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:48 -0400
Message-Id: <20120528031218.456862887@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "H.J. Lu" <hjl.tools@gmail.com>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [ 113/117] x86, relocs: Workaround for binutils 2.22.52.0.1 section bug
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit a3e854d95a76862cd37937e0b0438f540536771a upstream.

GNU ld 2.22.52.0.1 has a bug that it blindly changes symbols from
section-relative to absolute if they are in a section of zero length.
This turns the symbols __init_begin and __init_end into absolute
symbols.  Let the relocs program know that those should be treated as
relative symbols.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: H.J. Lu <hjl.tools@gmail.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/tools/relocs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 0291470..c3cfbb2 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -56,7 +56,11 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
  * as absolute (typically defined outside any section in the linker script.)
  */
 	[S_REL] =
-	"^_end$",
+	"^(__init_(begin|end)|"
+	"__x86_cpu_dev_(start|end)|"
+	"(__parainstructions|__alt_instructions)(|_end)|"
+	"(__iommu_table|__apicdrivers|__smp_locks)(|_end)|"
+	"_end)$"
 };
 
 


