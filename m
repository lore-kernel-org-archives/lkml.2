Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992740Ab2KOEvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:51:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:48243 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933315Ab2KOEJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:09:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 02/38] rt2800: validate step value for temperature compensation
Date: Wed, 14 Nov 2012 20:09:59 -0800
Message-Id: <20121115040933.056862802@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040932.918082372@linuxfoundation.org>
References: <20121115040932.918082372@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit bf7e1abe434ba9e22e8dc04a4cba4ab504b788b8 upstream.

Some hardware has correct (!= 0xff) value of tssi_bounds[4] in the
EEPROM, but step is equal to 0xff. This results on ridiculous delta
calculations and completely broke TX power settings.

Reported-and-tested-by: Pavel Lucik <pavel.lucik@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1935,7 +1935,7 @@ static int rt2800_get_gain_calibration_d
 	/*
 	 * Check if temperature compensation is supported.
 	 */
-	if (tssi_bounds[4] == 0xff)
+	if (tssi_bounds[4] == 0xff || step == 0xff)
 		return 0;
 
 	/*


