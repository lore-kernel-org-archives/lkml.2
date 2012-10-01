Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab2JAW7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:59:49 -0400
Received: from 1wt.eu ([62.212.114.60]:35017 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab2JAW7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:47 -0400
Message-Id: <20121001225157.738708230@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 003/180] powerpc/pmac: Fix SMP kernels on pre-core99 UP machines
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 78c5c68a4cf4329d17abfa469345ddf323d4fd62 upstream.

The code for "powersurge" SMP would kick in and cause a crash
at boot due to the lack of a NULL test.

Adam Conrad reports that the 3.2 kernel, with CONFIG_SMP=y, will not
boot on an OldWorld G3; we're unconditionally writing to psurge_start,
but this is only set on powersurge machines.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Reported-by: Adam Conrad <adconrad@ubuntu.com>
Tested-by: Adam Conrad <adconrad@ubuntu.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/powerpc/platforms/powermac/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index b40c22d..7f66d0c 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -402,7 +402,7 @@ static struct irqaction psurge_irqaction = {
 
 static void __init smp_psurge_setup_cpu(int cpu_nr)
 {
-	if (cpu_nr != 0)
+	if (cpu_nr != 0 || !psurge_start)
 		return;
 
 	/* reset the entry point so if we get another intr we won't
-- 
1.7.2.1.45.g54fbc



