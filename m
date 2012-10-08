Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab2JHUGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:06:36 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:4774 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753345Ab2JHUGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:06:34 -0400
Message-ID: <1349726790.1397.13.camel@x61.thuisdomein>
Subject: [PATCH v2] regmap: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Valdis.Kletnieks@vt.edu, Jakub Jelinek <jakub@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Oct 2012 22:06:30 +0200
In-Reply-To: <20121008011429.GA19748@opensource.wolfsonmicro.com>
References: <1349000155.1553.27.camel@x61.thuisdomein>
	 <20121001100321.GB4360@opensource.wolfsonmicro.com>
	 <64681.1349223065@turing-police.cc.vt.edu>
	 <1349249016.1414.55.camel@x61.thuisdomein>
	 <59004.1349475644@turing-police.cc.vt.edu>
	 <20121006085306.GB8590@opensource.wolfsonmicro.com>
	 <1349517456.1491.33.camel@x61.thuisdomein>
	 <20121008011429.GA19748@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Oct 2012 20:06:30.0794 (UTC) FILETIME=[6855CEA0:01CDA590]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building regmap.o triggers this GCC warning:
    drivers/base/regmap/regmap.c: In function ‘regmap_raw_read’:
    drivers/base/regmap/regmap.c:1172:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]

Long story short: Jakub Jelinek pointed out that there is a type
mismatch between 'num' in regmap_volatile_range() and 'val_count' in
regmap_raw_read(). And indeed, converting 'num' to the type of
'val_count' (ie, size_t) makes this warning go away.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/base/regmap/regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c241ae2..b99d5d3 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -82,7 +82,7 @@ bool regmap_precious(struct regmap *map, unsigned int reg)
 }
 
 static bool regmap_volatile_range(struct regmap *map, unsigned int reg,
-	unsigned int num)
+	size_t num)
 {
 	unsigned int i;
 
-- 
1.7.11.4

