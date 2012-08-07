Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab2HGDkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:40:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59877 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964852Ab2HGDjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:39:02 -0400
Message-Id: <20120807032800.662729482@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 31/70] x86, nops: Missing break resulting in incorrect selection on Intel
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit d6250a3f12edb3a86db9598ffeca3de8b4a219e9 upstream.

The Intel case falls through into the generic case which then changes
the values.  For cases like the P6 it doesn't do the right thing so
this seems to be a screwup.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-lww2uirad4skzjlmrm0vru8o@git.kernel.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/alternative.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 1f84794..73ef56c 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -219,7 +219,7 @@ void __init arch_init_ideal_nops(void)
 			ideal_nops = intel_nops;
 #endif
 		}
-
+		break;
 	default:
 #ifdef CONFIG_X86_64
 		ideal_nops = k8_nops;


