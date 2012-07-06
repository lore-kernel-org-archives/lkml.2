Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab2GFVX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:23:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab2GFVX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:23:56 -0400
Message-ID: <4FF7575C.8030808@redhat.com>
Date: Fri, 06 Jul 2012 18:23:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: =?UTF-8?B?QmVub8OudCBUaMOpYmF1ZGVhdQ==?= 
	<benoit.thebaudeau@advansee.com>
CC: Changbin Du <changbin.du@gmail.com>, tsoni@codeaurora.org,
        dan carpenter <dan.carpenter@oracle.com>, kumarrav@codeaurora.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@infradead.org
Subject: Re: [PATCH] media: gpio-ir-recv: add allowed_protos and map_name
 for platform data
References: <539669167.615856.1341314356547.JavaMail.root@advansee.com>
In-Reply-To: <539669167.615856.1341314356547.JavaMail.root@advansee.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 03-07-2012 08:19, Benoît Thébaudeau escreveu:
> Hi Changbin,
> 
> On Tue, Jul 3, 2012 at 12:27:19PM +0200, Changbin Du wrote:
>> It's better to give platform code a chance to specify the allowed
>> protocols and which keymap to use.
> 
> Already half done here:
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=2bd237b

OK. Applied just the other half of the change.

Regards,
Mauro

-

[media] media: gpio-ir-recv: add allowed_protos for platform data

From: Du, Changbin <changbin.du@gmail.com>

It's better to give platform code a chance to specify the allowed
protocols to use.

[mchehab@redhat.com: fix merge conflict with a patch that made
 half of this change]
Signed-off-by: Du, Changbin <changbin.du@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 59fe60c..04cb272 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -84,7 +84,6 @@ static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
 
 	rcdev->priv = gpio_dev;
 	rcdev->driver_type = RC_DRIVER_IR_RAW;
-	rcdev->allowed_protos = RC_TYPE_ALL;
 	rcdev->input_name = GPIO_IR_DEVICE_NAME;
 	rcdev->input_phys = GPIO_IR_DEVICE_NAME "/input0";
 	rcdev->input_id.bustype = BUS_HOST;
@@ -93,6 +92,10 @@ static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
 	rcdev->input_id.version = 0x0100;
 	rcdev->dev.parent = &pdev->dev;
 	rcdev->driver_name = GPIO_IR_DRIVER_NAME;
+	if (pdata->allowed_protos)
+		rcdev->allowed_protos = pdata->allowed_protos;
+	else
+		rcdev->allowed_protos = RC_TYPE_ALL;
 	rcdev->map_name = pdata->map_name ?: RC_MAP_EMPTY;
 
 	gpio_dev->rcdev = rcdev;
diff --git a/include/media/gpio-ir-recv.h b/include/media/gpio-ir-recv.h
index 91546f3..0142736 100644
--- a/include/media/gpio-ir-recv.h
+++ b/include/media/gpio-ir-recv.h
@@ -14,9 +14,10 @@
 #define __GPIO_IR_RECV_H__
 
 struct gpio_ir_recv_platform_data {
-	int gpio_nr;
-	bool active_low;
-	const char *map_name;
+	int		gpio_nr;
+	bool		active_low;
+	u64		allowed_protos;
+	const char	*map_name;
 };
 
 #endif /* __GPIO_IR_RECV_H__ */
