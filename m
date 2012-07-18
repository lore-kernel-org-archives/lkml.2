Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab2GRADq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:03:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab2GRADa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:03:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stevie Trujillo <stevie.trujillo@gmail.com>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
Subject: [ 03/37] hwmon: (it87) Preserve configuration register bits on init
Date: Tue, 17 Jul 2012 17:02:40 -0700
Message-Id: <20120717232431.572709571@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 41002f8dd5938d5ad1d008ce5bfdbfe47fa7b4e8 upstream.

We were accidentally losing one bit in the configuration register on
device initialization. It was reported to freeze one specific system
right away. Properly preserve all bits we don't explicitly want to
change in order to prevent that.

Reported-by: Stevie Trujillo <stevie.trujillo@gmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/it87.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -2157,7 +2157,7 @@ static void __devinit it87_init_device(s
 
 	/* Start monitoring */
 	it87_write_value(data, IT87_REG_CONFIG,
-			 (it87_read_value(data, IT87_REG_CONFIG) & 0x36)
+			 (it87_read_value(data, IT87_REG_CONFIG) & 0x3e)
 			 | (update_vbat ? 0x41 : 0x01));
 }
 


