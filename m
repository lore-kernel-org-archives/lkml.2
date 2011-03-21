Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab1CUXUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:20:50 -0400
Received: from kroah.org ([198.145.64.141]:52856 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932474Ab1CUXSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:29 2011
Message-Id: <20110321230329.711796743@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:02:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [78/78] hwmon: (sht15) Fix integer overflow in humidity calculation
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

commit ccd32e735de7a941906e093f8dca924bb05c5794 upstream.

An integer overflow occurs in the calculation of RHlinear when the
relative humidity is greater than around 30%. The consequence is a subtle
(but noticeable) error in the resulting humidity measurement.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/sht15.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -333,11 +333,11 @@ static inline int sht15_calc_humid(struc
 
 	const int c1 = -4;
 	const int c2 = 40500; /* x 10 ^ -6 */
-	const int c3 = -2800; /* x10 ^ -9 */
+	const int c3 = -28; /* x 10 ^ -7 */
 
 	RHlinear = c1*1000
 		+ c2 * data->val_humid/1000
-		+ (data->val_humid * data->val_humid * c3)/1000000;
+		+ (data->val_humid * data->val_humid * c3) / 10000;
 	return (temp - 25000) * (10000 + 80 * data->val_humid)
 		/ 1000000 + RHlinear;
 }


