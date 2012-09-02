Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2IBSvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 14:51:09 -0400
Received: from bosmailout18.eigbox.net ([66.96.185.18]:55195 "EHLO
	bosmailout18.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab2IBSvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 14:51:07 -0400
X-Greylist: delayed 2541 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Sep 2012 14:51:07 EDT
X-Authority-Analysis: v=2.0 cv=KtT6LxqN c=1 sm=1
 a=buXPRa+6dbOeiNUh9yipmw==:17 a=bc2JKO6qiGsA:10 a=tW0haWE2Y5YA:10
 a=p0uCM_2ckjMA:10 a=8nJEP1OIZ-IA:10 a=gNdSV9H6-vIA:10 a=Ktm5S4mlv7YA:10
 a=0SoDHIHkKdgA:10 a=7E8NXZI3oggA:10 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19
 a=HDMV31SwfDG0Q99VZ8wA:9 a=wPNLvfGTeEIA:10 a=6thTdk0GfRoQwv0zj4iWMg==:117
X-EN-OrigOutIP: 10.20.18.15
X-EN-IMPSID: uJ8j1j0030KWaAJ01J8jiX
Message-ID: <50439CD2.5090205@yahoo.es>
Date: Mon, 03 Sep 2012 01:52:18 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        viresh kumar <viresh.kumar@linaro.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: Arnd Bergmann <arnd.bergmann@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        spear-devel <spear-devel@list.st.com>
Subject: [PATCH v4 0/3] dw_dmac: repair driver for use with AVR32 (AP7000)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.57.6
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3 was based and tested on 3.5.2. the patches didn't apply
to the latest kernel because dw_dmac.c has had some changes since then.
Now it is based and tested on linux-3.6-rc4


From: Hein Tibosch <hein_tibosch@yahoo.es>

v4: now based and tested on 3.6-rc4

After some recent changes to dw_dmac, the driver got broken for the
AVR32 platform for several reasons:

The accessors to i/o memory had become little-endian.
The maximum transfer width on the memory side was increased from 32 to 64 bits.
This led to undefined behavior on the avr32 platform.

These patches will repair the driver so it can be used again on avr32. For
other users of dw_dmac (ARM platform), nothing will change and no code has
to be adapted.

The small patch for Atmel (at32ap700x.c) is included here because of its
dependency on the second dw_dmac patch.

Thanks to all for reviewing, both people from Atmel and Linaro

Hein Tibosch (3):
  dw_dmac: make driver endianness configurable
  dw_dmac: max_mem_width limits value for SRC/DST_TR_WID register
  avr32: at32ap700x: set DMA slave properties for MCI dw_dmac

 arch/avr32/mach-at32ap/at32ap700x.c |    4 ++++
 drivers/dma/Kconfig                 |   11 +++++++++++
 drivers/dma/dw_dmac.c               |   13 +++++++------
 drivers/dma/dw_dmac_regs.h          |   14 ++++++++++++++
 include/linux/dw_dmac.h             |    3 +++
 5 files changed, 39 insertions(+), 6 deletions(-)

-- 

