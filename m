Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab2H3SeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:34:23 -0400
Received: from bosmailout06.eigbox.net ([66.96.189.6]:35901 "EHLO
	bosmailout06.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2H3SeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:34:22 -0400
X-Greylist: delayed 2676 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2012 14:34:22 EDT
X-Authority-Analysis: v=2.0 cv=LI/Rtuq9 c=1 sm=1
 a=EVDLJLhrg0sUKeqAW2r0xw==:17 a=bc2JKO6qiGsA:10 a=tW0haWE2Y5YA:10
 a=uaSN-30Wp1AA:10 a=8nJEP1OIZ-IA:10 a=U-KOib2bZE0A:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=GpLXe_uxwL8xOnI39DIA:9 a=wPNLvfGTeEIA:10
 a=BF10AaGwQl41phDg7WSPyA==:117
X-EN-OrigOutIP: 10.20.18.8
X-EN-IMPSID: t5pj1j0010ASroS015pjjz
Message-ID: <503F9F72.9020301@yahoo.es>
Date: Fri, 31 Aug 2012 01:14:26 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@linaro.org>
CC: spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, egtvedt@samfundet.no,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: [PATCH v2 0/2] dw_dmac: repair driver for use with AVR32 (AP7000)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.60.254
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After some recent changes to dw_dmac, the driver got broken
for the AVR32 platform for two reasons:

The accessors to i/o memory had become little-endian.
The maximum transfer width on the memory side was increased
from 32 to 64 bits. This led to undefined behavior on the
avr32 platform.

These patches repair the driver by:
1. making the endianness configurable through Kconfig,
for AVR32 it will become big-endian
2. making the maximum memory transfer width configurable
It can be set in the code within arch

For non-avr32 (ARM) platforms, nothing has to be changed.

Thanks to all for reviewing

Hein Tibosch (2):

 drivers/dma/Kconfig        |   11 +++++++++++
 drivers/dma/dw_dmac.c      |   10 +++++++---
 drivers/dma/dw_dmac_regs.h |   14 ++++++++++++++
 include/linux/dw_dmac.h    |    3 +++
 4 files changed, 35 insertions(+), 3 deletions(-)

-- 

