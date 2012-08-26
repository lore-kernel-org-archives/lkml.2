Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2HZWZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 18:25:59 -0400
Received: from bosmailout20.eigbox.net ([66.96.185.20]:40380 "EHLO
	bosmailout20.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab2HZWZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 18:25:57 -0400
X-Greylist: delayed 2393 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Aug 2012 18:25:57 EDT
X-Authority-Analysis: v=2.0 cv=aPZHX8Bm c=1 sm=1
 a=OWwsRfqG41DA94+gJvZMBg==:17 a=bc2JKO6qiGsA:10 a=kfTud4QeKxsA:10
 a=RnqgmmiJ3l0A:10 a=8nJEP1OIZ-IA:10 a=cHz4xhJ9zCEA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=GpLXe_uxwL8xOnI39DIA:9 a=wPNLvfGTeEIA:10
 a=x8qw8EAkfcRkIpZA8Q87Bg==:117
X-EN-OrigOutIP: 10.20.18.7
X-EN-IMPSID: rZmJ1j004099BUA01ZmJd7
Message-ID: <503A8B6F.3010404@yahoo.es>
Date: Mon, 27 Aug 2012 04:47:43 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@linaro.org>
CC: spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, egtvedt@samfundet.no,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: [PATCH 0/2] dw_dmac: repair driver for use with AVR32 (AP7000)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.63.241
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After some recent changes to dw_dmac, the driver got broken
for the AVR32 platform for two reasons:

The accessors to i/o memory had become little-endian.
The maximum transfer width on the memory side was increased
from 32 to 64 bits.

These patches repair the driver by:
1. making the endianness configurable through Kconfig,
for AVR32 it will become big-endian
2. making the maximum memory transfer width configurable
It can be set in the code within arch

For non-avr32 (ARM) platforms, nothing has to be changed.

Thanks to Viresh and Arnd for reviewing

Hein Tibosch (2):

  dw_dmac: make driver endianness configurable
  dw_dmac: max_mem_width limits value for SRC/DST_TR_WID register

 drivers/dma/Kconfig        |    8 ++++++++
 drivers/dma/dw_dmac.c      |    8 ++++++++
 drivers/dma/dw_dmac_regs.h |   23 +++++++++++++++++++++++
 include/linux/dw_dmac.h    |    3 +++
 4 files changed, 42 insertions(+), 0 deletions(-)

-- 

