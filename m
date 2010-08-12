Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084Ab0HLAZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:25:50 -0400
Received: from kroah.org ([198.145.64.141]:60188 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759507Ab0HLAEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:14 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:25 2010
Message-Id: <20100812000125.564950145@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Igor Grinberg <grinberg@compulab.co.il>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [25/54] [ARM] pxa/cm-x300: fix ffuart registration
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Igor Grinberg <grinberg@compulab.co.il>

commit a6cd7eb374647b572ae9e7dbfe49871e6996e8e0 upstream.

ffuart is available on cm-x300 only with pxa300.

Signed-off-by: Igor Grinberg <grinberg@compulab.co.il>
Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-pxa/cm-x300.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-pxa/cm-x300.c
+++ b/arch/arm/mach-pxa/cm-x300.c
@@ -667,9 +667,10 @@ static void __init cm_x300_init(void)
 {
 	cm_x300_init_mfp();
 
-	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
+	if (cpu_is_pxa300())
+		pxa_set_ffuart_info(NULL);
 
 	cm_x300_init_da9030();
 	cm_x300_init_dm9000();


