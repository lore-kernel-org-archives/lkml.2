Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab2F1KjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:39:10 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:3035 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163Ab2F1KjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:39:07 -0400
Message-ID: <1340879945.1911.49.camel@x61.thuisdomein>
Subject: [PATCH] ARM: mxs/tx28: fix odd include
From: Paul Bolle <pebolle@tiscali.nl>
To: Shawn Guo <shawn.guo@linaro.org>, Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 28 Jun 2012 12:39:05 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 28 Jun 2012 10:39:06.0150 (UTC) FILETIME=[3E02E460:01CD551A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-mxs/module-tx28.c includes "../devices-mx28.h". That's a
bit odd, because that header can be found in the same directory. This
only works because arch/arm/mach-mxs/include should be in the header
search path for this file. Nevertheless, this file can simply include
"device-mx28.h" (just as the four other files including that header do).

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested, but obviously correct.

 arch/arm/mach-mxs/module-tx28.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mxs/module-tx28.c b/arch/arm/mach-mxs/module-tx28.c
index 9a7b08b..0f71f82 100644
--- a/arch/arm/mach-mxs/module-tx28.c
+++ b/arch/arm/mach-mxs/module-tx28.c
@@ -11,7 +11,7 @@
 #include <linux/gpio.h>
 
 #include <mach/iomux-mx28.h>
-#include "../devices-mx28.h"
+#include "devices-mx28.h"
 
 #include "module-tx28.h"
 
-- 
1.7.7.6

