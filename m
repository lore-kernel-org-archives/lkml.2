Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161960Ab2GLWlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:41:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161931Ab2GLWli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:41:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrew Bird <ajb@spheresystems.co.uk>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?y?q?=5B=20106/187=5D=20USB=3A=20qmi=5Fwwan=3A=20Make=20forced=20int=204=20whitelist=20generic?=
Date: Thu, 12 Jul 2012 15:34:22 -0700
Message-Id: <20120712191532.220550976@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Andrew Bird (Sphere Systems)" <ajb@spheresystems.co.uk>

commit 00001880cd8faaa349fe2ebb158f7e0cd8026048 upstream.

Change the forced interface 4 whitelist to use the generic shared
binder instead of the Gobi specific one. Certain ZTE devices
(K3520-Z & K3765-Z) don't work with the Gobi version, but function
quite happily with the generic. This has been tested with the following
devices:
K3520-Z
K3565-Z
K3765-Z
K4505-Z
It hasn't been tested with the ZTE MF820D, which is the only other
device that uses this whitelist at present. Although Bjorn doesn't
expect any problems, any testing with that device would be appreciated.

Signed-off-by: Andrew Bird <ajb@spheresystems.co.uk>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/qmi_wwan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -357,9 +357,9 @@ static const struct driver_info	qmi_wwan
 
 /* ZTE suck at making USB descriptors */
 static const struct driver_info	qmi_wwan_force_int4 = {
-	.description	= "Qualcomm Gobi wwan/QMI device",
+	.description	= "Qualcomm WWAN/QMI device",
 	.flags		= FLAG_WWAN,
-	.bind		= qmi_wwan_bind_gobi,
+	.bind		= qmi_wwan_bind_shared,
 	.unbind		= qmi_wwan_unbind_shared,
 	.manage_power	= qmi_wwan_manage_power,
 	.data		= BIT(4), /* interface whitelist bitmap */


