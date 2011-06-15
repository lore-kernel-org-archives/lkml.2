Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab1FPHAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:00:40 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54006 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755316Ab1FPHAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:31 -0400
X-Sasl-enc: DujbS+Dsyw74X32xGafhZWrxM7HBa/6xWS8sZ8PU6p+Z 1308207630
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:31 2011
Message-Id: <20110616000231.058619346@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>, Carsten Emde <C.Emde@osadl.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [21/89] hwmon: (coretemp) Relax target temperature range check
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 4c6e0f8101e62d8b2d01dc94b835a98b191a1454 upstream.

The current temperature range check of MSR_IA32_TEMPERATURE_TARGET
seems too strict to me, some TjMax values documented in
Documentation/hwmon/coretemp wouldn't pass. Relax the check so that
all the documented values pass.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Carsten Emde <C.Emde@osadl.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/hwmon/coretemp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -263,7 +263,7 @@ static int __devinit get_tjmax(struct cp
 		 * If the TjMax is not plausible, an assumption
 		 * will be used
 		 */
-		if ((val > 80) && (val < 120)) {
+		if (val >= 70 && val <= 125) {
 			dev_info(dev, "TjMax is %d C.\n", val);
 			return val * 1000;
 		}


