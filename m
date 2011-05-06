Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab1EFAYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:24:07 -0400
Received: from kroah.org ([198.145.64.141]:36500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab1EFAYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:05 2011
Message-Id: <20110506002205.157571184@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:19:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [001/143] ath: add missing regdomain pair 0x5c mapping
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 drivers/net/wireless/ath/regd_common.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@ -195,6 +195,7 @@ static struct reg_dmn_pair_mapping regDo
 	{APL9_WORLD, CTL_ETSI, CTL_ETSI},
 
 	{APL3_FCCA, CTL_FCC, CTL_FCC},
+	{APL7_FCCA, CTL_FCC, CTL_FCC},
 	{APL1_ETSIC, CTL_FCC, CTL_ETSI},
 	{APL2_ETSIC, CTL_FCC, CTL_ETSI},
 	{APL2_APLD, CTL_FCC, NO_CTL},


