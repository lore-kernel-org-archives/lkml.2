Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760381Ab2CUVTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:19:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41497 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760285Ab2CUVS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:18:58 -0400
Message-Id: <20120321211533.557011479@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 21 Mar 2012 14:15:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Adam Conrad <adconrad@ubuntu.com>
Subject: [ 9/9] powerpc/pmac: Fix SMP kernels on pre-core99 UP machines
In-Reply-To: <20120321211539.GA28899@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 78c5c68a4cf4329d17abfa469345ddf323d4fd62 upstream.

The code for "powersurge" SMP would kick in and cause a crash
at boot due to the lack of a NULL test.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Reported-by: Adam Conrad <adconrad@ubuntu.com>
Tested-by: Adam Conrad <adconrad@ubuntu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powermac/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -414,7 +414,7 @@ static struct irqaction psurge_irqaction
 
 static void __init smp_psurge_setup_cpu(int cpu_nr)
 {
-	if (cpu_nr != 0)
+	if (cpu_nr != 0 || !psurge_start)
 		return;
 
 	/* reset the entry point so if we get another intr we won't


