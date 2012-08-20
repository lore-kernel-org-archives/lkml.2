Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab2HTTwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:52:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab2HTTwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:52:38 -0400
Message-ID: <50329577.6040708@redhat.com>
Date: Mon, 20 Aug 2012 16:52:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Patrick Boettcher <patrick.boettcher@desy.de>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for Aug 20 (media: flexcop)
References: <20120820192336.1be51b225ce2883bdcad5b15@canb.auug.org.au> <503259AD.40602@xenotime.net>
In-Reply-To: <503259AD.40602@xenotime.net>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 20-08-2012 12:37, Randy Dunlap escreveu:
> On 08/20/12 02:23, Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> Changes since 20120817:
>>
>> The v4l-dvb tree lost its build failure.
>>
> 
> 
> 
> on x86_64:
> 
> flexcop-pci.c:(.text+0x19af63): undefined reference to `flexcop_device_exit'
> flexcop-pci.c:(.text+0x19af77): undefined reference to `flexcop_device_kfree'
> flexcop-pci.c:(.text+0x19b10f): undefined reference to `flexcop_pass_dmx_packets'
> flexcop-pci.c:(.text+0x19b182): undefined reference to `flexcop_pass_dmx_data'
> flexcop-pci.c:(.text+0x19b1ae): undefined reference to `flexcop_pass_dmx_data'
> flexcop-pci.c:(.text+0x19b1f8): undefined reference to `flexcop_device_kmalloc'
> flexcop-pci.c:(.text+0x19b256): undefined reference to `flexcop_i2c_request'
> flexcop-pci.c:(.text+0x19b261): undefined reference to `flexcop_eeprom_check_mac_addr'
> flexcop-pci.c:(.text+0x19b2c6): undefined reference to `flexcop_device_initialize'
> flexcop-pci.c:(.text+0x19b332): undefined reference to `flexcop_sram_set_dest'
> flexcop-pci.c:(.text+0x19b348): undefined reference to `flexcop_sram_set_dest'
> flexcop-pci.c:(.text+0x19b3f8): undefined reference to `flexcop_device_exit'
> flexcop-pci.c:(.text+0x19b408): undefined reference to `flexcop_device_kfree'
> flexcop-pci.c:(.text+0x19b4a2): undefined reference to `flexcop_pid_feed_control'
> flexcop-pci.c:(.text+0x19b4d7): undefined reference to `flexcop_pid_feed_control'
> 
> 
> 
> since it is possible to enable DVB_B2C2_FLEXCOP_PCI
> when CONFIG_I2C is not enabled, but then DVB_B2C2_FLEXCOP
> is not enabled because I2C is not enabled.
> 
> 
> Full randconfig file is attached.

Thanks!

The following patch should be fixing it.

You'll likely notice a few more things like that, as we're reorganizing
the media tree and their Kconfig files.

Thanks,
Mauro

-

[media] Kconfig: Fix b2c2 common code selection

As reported by Randy:

> flexcop-pci.c:(.text+0x19af63): undefined reference to `flexcop_device_exit'
> flexcop-pci.c:(.text+0x19af77): undefined reference to `flexcop_device_kfree'
> flexcop-pci.c:(.text+0x19b10f): undefined reference to `flexcop_pass_dmx_packets'
> flexcop-pci.c:(.text+0x19b182): undefined reference to `flexcop_pass_dmx_data'
> flexcop-pci.c:(.text+0x19b1ae): undefined reference to `flexcop_pass_dmx_data'
> flexcop-pci.c:(.text+0x19b1f8): undefined reference to `flexcop_device_kmalloc'
> flexcop-pci.c:(.text+0x19b256): undefined reference to `flexcop_i2c_request'
> flexcop-pci.c:(.text+0x19b261): undefined reference to `flexcop_eeprom_check_mac_addr'
> flexcop-pci.c:(.text+0x19b2c6): undefined reference to `flexcop_device_initialize'
> flexcop-pci.c:(.text+0x19b332): undefined reference to `flexcop_sram_set_dest'
> flexcop-pci.c:(.text+0x19b348): undefined reference to `flexcop_sram_set_dest'
> flexcop-pci.c:(.text+0x19b3f8): undefined reference to `flexcop_device_exit'
> flexcop-pci.c:(.text+0x19b408): undefined reference to `flexcop_device_kfree'
> flexcop-pci.c:(.text+0x19b4a2): undefined reference to `flexcop_pid_feed_control'
> flexcop-pci.c:(.text+0x19b4d7): undefined reference to `flexcop_pid_feed_control'
>
> since it is possible to enable DVB_B2C2_FLEXCOP_PCI
> when CONFIG_I2C is not enabled, but then DVB_B2C2_FLEXCOP
> is not enabled because I2C is not enabled.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/pci/b2c2/Kconfig b/drivers/media/pci/b2c2/Kconfig
index aaa1f30..f99e25c 100644
--- a/drivers/media/pci/b2c2/Kconfig
+++ b/drivers/media/pci/b2c2/Kconfig
@@ -1,5 +1,6 @@
 config DVB_B2C2_FLEXCOP_PCI
 	tristate "Technisat/B2C2 Air/Sky/Cable2PC PCI"
+	depends on DVB_CORE && I2C
 	help
 	  Support for the Air/Sky/CableStar2 PCI card (DVB/ATSC) by Technisat/B2C2.
 
diff --git a/drivers/media/usb/b2c2/Kconfig b/drivers/media/usb/b2c2/Kconfig
index 3af7c41..23de67c 100644
--- a/drivers/media/usb/b2c2/Kconfig
+++ b/drivers/media/usb/b2c2/Kconfig
@@ -1,5 +1,6 @@
 config DVB_B2C2_FLEXCOP_USB
 	tristate "Technisat/B2C2 Air/Sky/Cable2PC USB"
+	depends on DVB_CORE && I2C
 	help
 	  Support for the Air/Sky/Cable2PC USB1.1 box (DVB/ATSC) by Technisat/B2C2,
 

