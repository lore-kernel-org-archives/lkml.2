Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab0DFXk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:40:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39626 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757814Ab0DFXkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:40:09 -0400
Message-ID: <4BBBC628.9030207@ti.com>
Date: Tue, 6 Apr 2010 18:39:20 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>
CC: "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>,
       "me@felipebalbi.com" <me@felipebalbi.com>,
       "'kishore kadiyala'" <kishorek.kadiyala@gmail.com>,
       "'Vimal Singh'" <vimal.newwork@gmail.com>,
       "tony@atomide.com" <tony@atomide.com>,
       "S, Venkatraman" <svenkatr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "'Lavinen Jarkko (Nokia-D/Helsinki)'" <jarkko.lavinen@nokia.com>
Subject: Re: [PATCH v3] OMAP: Fix for bus width which improves SD card's peformance.
References: <003b01cad0f0$6ea78040$544ff780@am.dhcp.ti.com> <g2s7f9d1ffb1003312331o149df218g651c3e4349ac9a77@mail.gmail.com> <003c01cad1b1$da2cdbf0$544ff780@am.dhcp.ti.com> <m2n7f9d1ffb1004050556o1ed2eec8ief66d60fc85f96de@mail.gmail.com> <20100405164839.GB17388@gandalf> <007c01cad4e4$26c5a700$544ff780@am.dhcp.ti.com> <20100406050035.GA32537@gandalf> <003901cad5a4$730264d0$544ff780@am.dhcp.ti.com> <20100406163211.GA29117@nokia.com> <4BBB6767.7010202@ti.com> <20100406165720.GA17916@nokia.com> <00b401cad5e0$1d1868d0$544ff780@am.dhcp.ti.com>
In-Reply-To: <00b401cad5e0$1d1868d0$544ff780@am.dhcp.ti.com>
Content-Type: multipart/mixed;
	boundary="------------030702010901030705060409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------030702010901030705060409
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

Chikkature Rajashekar, Madhusudhan had written, on 04/06/2010 06:23 PM, 
the following:
> 
>> -----Original Message-----
>> From: Felipe Balbi [mailto:felipe.balbi@nokia.com]
>> Sent: Tuesday, April 06, 2010 11:57 AM
>> To: ext Nishanth Menon
>> Cc: Balbi Felipe (Nokia-D/Helsinki); Chikkature Rajashekar, Madhusudhan;
>> me@felipebalbi.com; 'kishore kadiyala'; 'Vimal Singh'; tony@atomide.com;
>> S, Venkatraman; linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org;
>> Lavinen Jarkko (Nokia-D/Helsinki)
>> Subject: Re: [PATCH v3] OMAP: Fix for bus width which improves SD card's
>> peformance.
>>
>> On Tue, Apr 06, 2010 at 06:55:03PM +0200, ext Nishanth Menon wrote:
>>> some reasons why i love switch statements ;) since I dont expect other
>>> than precisely 4 and 8 (do we expect 5,6,7 - i might be wrong).. but if
>>> it is so, wont the following be better?
>>>
>>> switch (mmc_slot(host).wires)
>>> {
>>> case 8:
>>> 	mmc->caps |= MMC_CAP_8_BIT_DATA;
>>> 	/* fall thru*/
>>> case 4:
>>> 	mmc->caps |= MMC_CAP_4_BIT_DATA;
>>> 		break;
>>> default:
>>> 	WARN("bad width");
>>> }
>> I like that, but I remember Madhu (or someone else) saying he thinks
>> it's less readable this way. Go figure...
>>
> Well, I did not comment on the usage of switch here. Note we only need to
> handle 8-bit and 4-bit.The board files need not setup 8-bit or 4-bit if the
> configuration of that board is 1-bit. The driver will still work in 1-bit
> mode which would mean there is nothing to do in default case and should not
> err out.
check the attachment out.. hope that takes care of it.. just as a 
reference alone ofcourse..
-- 
Regards,
Nishanth Menon

--------------030702010901030705060409
Content-Type: text/x-patch;
	name="0001-OMAP-Fix-for-bus-width-which-improves-SD-card-s-pefo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename*0="0001-OMAP-Fix-for-bus-width-which-improves-SD-card-s-pefo.pa";
	filename*1="tch"

>From 09b55eb33749d308586c19485bf1e1723009fc9a Mon Sep 17 00:00:00 2001
From: kishore kadiyala <kishorek.kadiyala@gmail.com>
Date: Wed, 31 Mar 2010 07:03:01 +0000
Subject: [PATCH Vn] OMAP: Fix for bus width which improves SD card's peformance.

This patch improves low speeds for SD cards.
OMAP-MMC controller's can support maximum bus width of '8'.
when bus width is mentioned as "8" in controller data,the SD
stack will check whether bus width is "4" and if not it will
set bus width to "1" and there by degrading performance.
This patch fixes the issue and improves the performance of
SD cards.

Signed-off-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
Signed-off-by: Venkatraman S <svenkatr@ti.com>
Acked-by: Madhusudhan Chikkature <madhu.cr@ti.com>
Tested-by: Jarkko Nikula <jhnikula@gmail.com>
---
NM Note:
	Completely untested/unreviewed.. just holding on to
	what was in https://patchwork.kernel.org/patch/89898/
	with my suggested mods
 drivers/mmc/host/omap_hsmmc.c |   32 +++++++++++++++++++++++++++++---
 1 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 83f0aff..89e26bc 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2091,10 +2091,36 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
 	mmc->caps |= MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED |
 		     MMC_CAP_WAIT_WHILE_BUSY;
 
-	if (mmc_slot(host).wires >= 8)
+	switch(mmc_slot(host).wires) {
+	case 8:
 		mmc->caps |= MMC_CAP_8_BIT_DATA;
-	else if (mmc_slot(host).wires >= 4)
-		mmc->caps |= MMC_CAP_4_BIT_DATA;
+		/* Fall through */
+	case 4:
+		mmc->caps |= MMC_CAP_8_BIT_DATA;
+		break;
+	case 1:
+		/*
+		 * I will still survive with this config.. but warn
+		 * if the board file was goofed up
+		 */
+		dev_warn(mmc_dev(host->mmc), "Using potentially"
+				"unoptimal 1bit config\n");
+		break;
+	default:
+		/* Completely unexpected.. dont wanna croak and die */
+		dev_crit(mmc_dev(host->mmc), "Unknown width %d"
+				"used!\n",mmc_slot(host).wires);
+		mmc_host_disable(host->mmc);
+		if (host->got_dbclk) {
+			 clk_disable(host->dbclk);
+			 clk_put(host->dbclk);
+		}
+		clk_disable(host->iclk);
+		clk_put(host->iclk);
+		clk_put(host->fclk);
+		goto err1;
+
+	}
 
 	if (mmc_slot(host).nonremovable)
 		mmc->caps |= MMC_CAP_NONREMOVABLE;
-- 
1.6.3.3


--------------030702010901030705060409--
