Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab2CMAxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:53:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:47946 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758799Ab2CMAW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:56 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 085/196] ath: add missing regdomain pair 0x5c mapping
Date: Mon, 12 Mar 2012 20:19:58 -0400
Message-Id: <1331598109-31424-40-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Lamparter <chunkeey@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/ath/regd_common.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/regd_common.h b/drivers/net/wireless/ath/regd_common.h
index 248c670..5c2cfe6 100644
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -195,6 +195,7 @@ static struct reg_dmn_pair_mapping regDomainPairs[] = {
 	{APL9_WORLD, CTL_ETSI, CTL_ETSI},
 
 	{APL3_FCCA, CTL_FCC, CTL_FCC},
+	{APL7_FCCA, CTL_FCC, CTL_FCC},
 	{APL1_ETSIC, CTL_FCC, CTL_ETSI},
 	{APL2_ETSIC, CTL_FCC, CTL_ETSI},
 	{APL2_APLD, CTL_FCC, NO_CTL},
-- 
1.7.9.3

