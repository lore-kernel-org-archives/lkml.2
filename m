Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2DZJPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 05:15:06 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:19619 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab2DZJPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 05:15:04 -0400
Message-ID: <4F991210.8060409@atmel.com>
Date: Thu, 26 Apr 2012 11:14:56 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Andrew Victor <avictor.za@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [GIT PULL] net/at91: at91_ether fixes for 3.4-rc
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.159.245.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Can you please pull those fixes for 3.4-rc? The ARM/AT91 part
of modifications is pretty small and bounded to a single SoC so
it will not mess with arm-soc git tree.

Tell me if you need other information on this signed tag...

The following changes since commit 66f75a5d028beaf67c931435fdc3e7823125730c:

  Linux 3.4-rc4 (2012-04-21 14:47:52 -0700)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-3.4-net-fixes

for you to fetch changes up to cfc991548b5b73c8038f41877da1cd0104945cf5:

  net/at91_ether: use gpio_to_irq for phy IRQ line (2012-04-26 10:22:40 +0200)

----------------------------------------------------------------
Both fixes are about at91_ether.c driver: It is only used in a single
Atmel AT91 SoC: AT91RM9200.
The removal of fixed mapping is a long standing refinement which will
convert this driver to a more typical resources management.
The gpio fix is needed now that we have moved AT91 to irqdomains.

----------------------------------------------------------------
Andrew Victor (1):
      AT91: Remove fixed mapping for AT91RM9200 ethernet

Nicolas Ferre (1):
      net/at91_ether: use gpio_to_irq for phy IRQ line

 arch/arm/mach-at91/at91rm9200.c            |   10 --
 arch/arm/mach-at91/at91rm9200_devices.c    |    4 +-
 arch/arm/mach-at91/include/mach/hardware.h |    1 -
 drivers/net/ethernet/cadence/at91_ether.c  |  535 ++++++++++++++++++++++++++++++++++++++++++++-------------------------------------
 drivers/net/ethernet/cadence/at91_ether.h  |    1 +
 5 files changed, 291 insertions(+), 260 deletions(-)

Best regards,
-- 
Nicolas Ferre
