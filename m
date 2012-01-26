Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab2AZLaC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:30:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab2AZLaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:30:00 -0500
Date: Thu, 26 Jan 2012 12:29:42 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Greg KH <greg@kroah.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Francis Moreau <francis.moro@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Arend van Spriel <arend@broadcom.com>, linux-usb@vger.kernel.org
Subject: [PATCH] USB: Realtek cr: fix autopm scheduling while atomic 
Message-ID: <20120126112942.GC2451@redhat.com>
References: <CAC9WiBgpBCWZVjAQkJWSpXhC_dK1KKPfAHZvxVgaLV8BUsc41Q@mail.gmail.com>
 <4F1FBAA9.4040405@broadcom.com>
 <CAC9WiBjpsLuJhzw+vZsPC2bA73mad444Gq32DRL_gCri2MqaMw@mail.gmail.com>
 <4F1FD2AA.9020708@broadcom.com>
 <CA+5PVA73WHfnurWiyY4w9f4_mw=vUdpaNmAavHZtt+xYfo8Kcw@mail.gmail.com>
 <CAC9WiBgzg-dD5Sba9Cd_uvsfMxqQib+vsXXDyMSMSR_Y7P_CCw@mail.gmail.com>
 <CA+5PVA4Cq5BRfKEa1uckVbtCGKhKmuw1tujQ19T3wk3c5CcsAQ@mail.gmail.com>
 <4F21173A.9060405@broadcom.com>
 <CAC9WiBjmsaH2NYaCLjoihw_O4NCM1LiUVst8PJCZwP2xTE=BMA@mail.gmail.com>
 <4F2121BB.4050001@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2121BB.4050001@broadcom.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resolves:
https://bugzilla.redhat.com/show_bug.cgi?id=784345

Reported-by: Francis Moreau <francis.moro@gmail.com>
Reported-and-tested-by: Christian D <chrisudeussen@gmail.com>
Reported-and-tested-by: Jimmy Dorff <jdorff@phy.duke.edu>
Reported-and-tested-by: collura@ieee.org
Cc: stable@vger.kernel.org # 3.2+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 1f62723..d32f720 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -789,7 +789,7 @@ static void rts51x_suspend_timer_fn(unsigned long data)
 			rts51x_set_stat(chip, RTS51X_STAT_SS);
 			/* ignore mass storage interface's children */
 			pm_suspend_ignore_children(&us->pusb_intf->dev, true);
-			usb_autopm_put_interface(us->pusb_intf);
+			usb_autopm_put_interface_async(us->pusb_intf);
 			US_DEBUGP("%s: RTS51X_STAT_SS 01,"
 				"intf->pm_usage_cnt:%d, power.usage:%d\n",
 				__func__,
