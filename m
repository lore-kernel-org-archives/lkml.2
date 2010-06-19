Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab0FSFx6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 01:53:58 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48084 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab0FSFx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 01:53:56 -0400
Date: Fri, 18 Jun 2010 22:53:35 -0700
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       Alexander Potashev <aspotashev@gmail.com>,
       Tim Abbott <tabbott@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
       Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] x86: only CPU features determine NX capabilities
Message-ID: <20100619055335.GV24749@outflux.net>
References: <20100619055010.GR24749@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100619055010.GR24749@outflux.net>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the NX feature boot warning when NX is missing to correctly
reflect that BIOSes cannot disable NX now.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 arch/x86/mm/setup_nx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/setup_nx.c b/arch/x86/mm/setup_nx.c
index a3250aa..410531d 100644
--- a/arch/x86/mm/setup_nx.c
+++ b/arch/x86/mm/setup_nx.c
@@ -41,7 +41,7 @@ void __init x86_report_nx(void)
 {
 	if (!cpu_has_nx) {
 		printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
-		       "missing in CPU or disabled in BIOS!\n");
+		       "missing in CPU!\n");
 	} else {
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 		if (disable_nx) {
-- 
1.7.1


-- 
Kees Cook
Ubuntu Security Team
