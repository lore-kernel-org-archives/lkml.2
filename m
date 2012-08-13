Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab2HMWSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:18:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47188 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab2HMWSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:18:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arnd Bergmann <arnd@arndb.de>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Daniel Ribeiro <drwyrm@gmail.com>
Subject: [ 57/65] ARM: pxa: remove irq_to_gpio from ezx-pcap driver
Date: Mon, 13 Aug 2012 15:14:41 -0700
Message-Id: <20120813221420.012600595@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813221414.965154048@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 59ee93a528b94ef4e81a08db252b0326feff171f upstream.

The irq_to_gpio function was removed from the pxa platform
in linux-3.2, and this driver has been broken since.

There is actually no in-tree user of this driver that adds
this platform device, but the driver can and does get enabled
on some platforms.

Without this patch, building ezx_defconfig results in:

drivers/mfd/ezx-pcap.c: In function 'pcap_isr_work':
drivers/mfd/ezx-pcap.c:205:2: error: implicit declaration of function 'irq_to_gpio' [-Werror=implicit-function-declaration]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Daniel Ribeiro <drwyrm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/ezx-pcap.c       |    2 +-
 include/linux/mfd/ezx-pcap.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -202,7 +202,7 @@ static void pcap_isr_work(struct work_st
 		}
 		local_irq_enable();
 		ezx_pcap_write(pcap, PCAP_REG_MSR, pcap->msr);
-	} while (gpio_get_value(irq_to_gpio(pcap->spi->irq)));
+	} while (gpio_get_value(pdata->gpio));
 }
 
 static void pcap_irq_handler(unsigned int irq, struct irq_desc *desc)
--- a/include/linux/mfd/ezx-pcap.h
+++ b/include/linux/mfd/ezx-pcap.h
@@ -16,6 +16,7 @@ struct pcap_subdev {
 struct pcap_platform_data {
 	unsigned int irq_base;
 	unsigned int config;
+	int gpio;
 	void (*init) (void *);	/* board specific init */
 	int num_subdevs;
 	struct pcap_subdev *subdevs;


