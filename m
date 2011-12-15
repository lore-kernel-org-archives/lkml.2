Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597Ab1LOWTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:19:19 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60692 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab1LOWTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:19:18 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] Added some addition debug prints for pb_keys
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Date: Thu, 15 Dec 2011 22:31:23 +0000
Message-ID: <20111215223116.10166.50803.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Demeter <michael.demeter@intel.com>

Added additional debug output that we always seem to add
during power ons to validate firmware operation.

Signed-off-by: Michael Demeter <michael.demeter@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/platform/mrst/mrst.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index a9a4732..3002cc86 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -1035,6 +1035,8 @@ static int __init pb_keys_init(void)
 	num = sizeof(gpio_button) / sizeof(struct gpio_keys_button);
 	for (i = 0; i < num; i++) {
 		gb[i].gpio = get_gpio_by_name(gb[i].desc);
+		pr_debug("info[%2d]: name = %s,"
+				"gpio = %d\n", i, gb[i].desc, gb[i].gpio);
 		if (gb[i].gpio == -1)
 			continue;
 

