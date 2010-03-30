Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab0CaAXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:23:16 -0400
Received: from kroah.org ([198.145.64.141]:49088 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563Ab0C3XMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:41 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:42 2010
Message-Id: <20100330225842.069357249@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ray Copeland <ray.copeland@aprius.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [54/89] hwmon: (adt7462) Wrong ADT7462_VOLT_COUNT
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

commit 85f8d3e5faea8bd36c3e5196f8334f7db45e19b2 upstream.

The #define ADT7462_VOLT_COUNT is wrong, it should be 13 not 12. All the 
for loops that use this as a limit count are of the typical form, "for 
(n = 0; n < ADT7462_VOLT_COUNT; n++)", so to loop through all voltages 
w/o missing the last one it is necessary for the count to be one greater 
than it is.  (Specifically, you will miss the +1.5V 3GPIO input with count 
= 12 vs. 13.)

Signed-off-by: Ray Copeland <ray.copeland@aprius.com>
Acked-by: "Darrick J. Wong" <djwong@us.ibm.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/hwmon/adt7462.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/adt7462.c
+++ b/drivers/hwmon/adt7462.c
@@ -182,7 +182,7 @@ I2C_CLIENT_INSMOD_1(adt7462);
  *
  * Some, but not all, of these voltages have low/high limits.
  */
-#define ADT7462_VOLT_COUNT	12
+#define ADT7462_VOLT_COUNT	13
 
 #define ADT7462_VENDOR		0x41
 #define ADT7462_DEVICE		0x62


