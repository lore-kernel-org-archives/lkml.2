Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab1FPHjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:39:20 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:50935 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754106Ab1FPHAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:35 -0400
X-Sasl-enc: NtQazWYqCkni5ZRRFdudKm1ZqnubwSHpU09B8L8f0KOl 1308207633
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:31 2011
Message-Id: <20110616000231.232541036@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [23/89] iwl4965: correctly validate temperature value
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit dfe21582ac5ebc460dda98c67e8589dd506d02cd upstream.

In some cases we can read wrong temperature value. If after that
temperature value will not be updated to good one, we badly configure
tx power parameters and device is unable to send a data.

Resolves:
https://bugzilla.kernel.org/show_bug.cgi?id=35932

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlegacy/iwl-4965.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1543,7 +1543,7 @@ static void iwl4965_temperature_calib(st
 	s32 temp;
 
 	temp = iwl4965_hw_get_temperature(priv);
-	if (temp < 0)
+	if (IWL_TX_POWER_TEMPERATURE_OUT_OF_RANGE(temp))
 		return;
 
 	if (priv->temperature != temp) {


