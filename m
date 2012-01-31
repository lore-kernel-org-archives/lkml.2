Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2AaKi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:38:28 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:54616 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab2AaKi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:38:27 -0500
X-Greylist: delayed 2260 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jan 2012 05:38:27 EST
From: Barry Song <Barry.Song@csr.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <workgroup.linux@csr.com>, <linux-mtd@lists.infradead.org>,
        Barry Song <Barry.Song@csr.com>
Subject: [PATCH 0/3] platform: add platform_devm_request_and_ioremap() common API
Date: Tue, 31 Jan 2012 17:59:59 +0800
Message-ID: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.125.36.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

these patches move the common pattern from

"
res = platform_get_resource(pdev, IORESOURCE_MEM, 0); 
if (!res) {
	        ret = -ENODEV;
		        goto err;
}

base = devm_request_and_ioremap(&dev->dev, mem_res);
if (!base) {
	        ret = -ENODEV;
		        goto err;
}
"

to

"
base = platform_devm_request_and_ioremap(pdev, 0); 
if (!base) {
	        ret = -ENODEV;
		        goto err;
}
"


Barry Song (3):
  platform: add common resource requesting and mapping helper
  GPIO: TEGRA: move to use platform_devm_request_and_ioremap() helper
  MTD: NAND: txx9ndfmc: move to use platform_devm_request_and_ioremap()
    helper

 drivers/base/platform.c         |   19 +++++++++++++++++++
 drivers/gpio/gpio-tegra.c       |    8 +-------
 drivers/mtd/nand/txx9ndfmc.c    |    6 +-----
 include/linux/platform_device.h |    1 +
 4 files changed, 22 insertions(+), 12 deletions(-)



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
