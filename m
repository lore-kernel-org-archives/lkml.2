Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab2AXOnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 09:43:18 -0500
Received: from lnx503.hrz.tu-darmstadt.de ([130.83.156.232]:59740 "EHLO
	lnx503.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755925Ab2AXOnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 09:43:17 -0500
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jan 2012 09:43:16 EST
From: Tim Sander <tim01@iss.tu-darmstadt.de>
Organization: Integrierte Schaltungen und Systeme
To: netdev@vger.kernel.org
Subject: newbie: phy platform interrupt config
Date: Tue, 24 Jan 2012 15:37:10 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-amd64; KDE/4.4.5; x86_64; ; )
Cc: Andy Fleming <afleming@freescale.com>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richard.cochran@omicron.at>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Decotigny <decot@google.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201241537.17194.tim01@iss.tu-darmstadt.de>
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.1.24.142715
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I would like to set the interrupt for the phy on the i.mx35 pcm43 in the file 
arch/arm/mach-imx/mach-pcm043.c. Unfortunatly i didn't find a way to specify 
it. So i want to set the field (struct phy_device*)->irq.

What i managed so far is to request the gpio for the interrupt:
#define IMX_PHY_IRQ IMX_GPIO_NR(2,7)
gpio_request(IMX_PHY_IRQ, "FEC PHY irq");
gpio_direction_input(IMX_PHY_IRQ);

Now i guess the result of "gpio_to_irq(IMX_PHY_IRQ)" should go into some kind 
of argument to imx35_add_fec(pdata) which is a macro 
imx_add_fec(&imx35_fec_data, pdata).
pdata is of type (?) struct fec_platform_data which contains phy_interface_t 
and unsigned char array. So i don't see a way to set the phy interrupt there.

I tried search for a driver which set the phy irq but i didn't find any and 
setting the phy in the phy_fixup function is also not working since the 
interrupt seems not get registered when opening the device.

So how do i set the phy interrupt line in the platform file?

Best regards
Tim

PS:
The cc list is from scripts/get_maintainer.pl -f drivers/net/phy/ which are 
hopefully the right maintainers plus Andy Fleming which commited the 
documentation for libphy.
