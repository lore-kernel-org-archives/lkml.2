Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965404Ab2E0BMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:12:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab2E0BMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:12:35 -0400
Message-Id: <20120527010434.607564102@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:40 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [ 77/94] x86, relocs: Workaround for binutils 2.22.52.0.1 section bug
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/tools/relocs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -56,7 +56,11 @@ static const char * const sym_regex_kern
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
 
 


