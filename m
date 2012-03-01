Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965715Ab2CAVvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:51:05 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63550 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965686Ab2CAVvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:51:02 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.240.135 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213923.522958258@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nikolaus Schulz <mail@microschulz.de>
Subject: [ 08/34] hwmon: (f75375s) Fix automatic pwm mode setting for F75373 & F75375
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolaus Schulz <schulz@macnetix.de>

commit 09e87e5c4f9af656af2a8a3afc03487c5d9287c3 upstream.

In order to enable temperature mode aka automatic mode for the F75373 and
F75375 chips, the two FANx_MODE bits in the fan configuration register
need be set to 01, not 10.

Signed-off-by: Nikolaus Schulz <mail@microschulz.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/f75375s.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -311,7 +311,7 @@ static int set_pwm_enable_direct(struct
 		fanmode  |= (3 << FAN_CTRL_MODE(nr));
 		break;
 	case 2: /* AUTOMATIC*/
-		fanmode  |= (2 << FAN_CTRL_MODE(nr));
+		fanmode  |= (1 << FAN_CTRL_MODE(nr));
 		break;
 	case 3: /* fan speed */
 		break;


