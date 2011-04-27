Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943Ab1D0TVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:21:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60864 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759921Ab1D0TVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:21:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=L0e+B6X7DBNFNaV329Z5K6qXcx4cqcAPDR7o0dU4U5whZ/SIvLd1nClt+6ftYDSUtP
         ZjLKdWjWD/h1ujicIjjE7uLtOoUKFU0JuhAWfssTyDdZjawIgFpvrlOl6JjCuxYsbj7C
         1EoHGBD9wibZ77JZlFlyPP6lK08DHA8xtVR70=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH 2/2] hwrnd: enable AMD hw rnd driver for Maple PPC boards
Date: Wed, 27 Apr 2011 23:21:16 +0400
Message-Id: <1303932076-7428-2-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303932076-7428-1-git-send-email-dbaryshkov@gmail.com>
References: <1303932076-7428-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PPC 970FX Evaluation kit (Maple) boards bear AMD8111 southbridge.
Allow this driver to be compiled in if PPC_MAPLE is selected.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/char/hw_random/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index beecd1c..a60043b 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -49,7 +49,7 @@ config HW_RANDOM_INTEL
 
 config HW_RANDOM_AMD
 	tristate "AMD HW Random Number Generator support"
-	depends on HW_RANDOM && X86 && PCI
+	depends on HW_RANDOM && (X86 || PPC_MAPLE) && PCI
 	default HW_RANDOM
 	---help---
 	  This driver provides kernel-side support for the Random Number
-- 
1.7.4.4

