Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab1DZVWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:22:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:61258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446Ab1DZVOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483759"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: chunkeey@googlemail.com, lrodriguez@atheros.com, linville@tuxdriver.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [82/106] ath: add missing regdomain pair 0x5c mapping
Message-Id: <20110426211404.0C8933E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Christian Lamparter <chunkeey@googlemail.com>

commit bd39a274fb7b43374c797bafdb7f506598f36f77 upstream.

Joe Culler reported a problem with his AR9170 device:

> ath: EEPROM regdomain: 0x5c
> ath: EEPROM indicates we should expect a direct regpair map
> ath: invalid regulatory domain/country code 0x5c
> ath: Invalid EEPROM contents

It turned out that the regdomain 'APL7_FCCA' was not mapped yet.
According to Luis R. Rodriguez [Atheros' engineer] APL7 maps to
FCC_CTL and FCCA maps to FCC_CTL as well, so the attached patch
should be correct.

Reported-by: Joe Culler <joe.culler@gmail.com>
Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/ath/regd_common.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/net/wireless/ath/regd_common.h
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/ath/regd_common.h
+++ linux-2.6.35.y/drivers/net/wireless/ath/regd_common.h
@@ -195,6 +195,7 @@ static struct reg_dmn_pair_mapping regDo
 	{APL9_WORLD, CTL_ETSI, CTL_ETSI},
 
 	{APL3_FCCA, CTL_FCC, CTL_FCC},
+	{APL7_FCCA, CTL_FCC, CTL_FCC},
 	{APL1_ETSIC, CTL_FCC, CTL_ETSI},
 	{APL2_ETSIC, CTL_FCC, CTL_ETSI},
 	{APL2_APLD, CTL_FCC, NO_CTL},
