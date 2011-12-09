Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab1LID3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 22:29:08 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56398 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1LID3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 22:29:02 -0500
Message-ID: <1323401336.25140.1.camel@phoenix>
Subject: [PATCH 2/2] mfd: jz4740-adc: Don't declare jz4740_adc_cells const
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Samuel Ortiz <sameo@linux.intel.com>
Date: Fri, 09 Dec 2011 11:28:56 +0800
In-Reply-To: <1323401275.25140.0.camel@phoenix>
References: <1323401275.25140.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the const keyword to fix below warning:

  CC      drivers/mfd/jz4740-adc.o
drivers/mfd/jz4740-adc.c: In function 'jz4740_adc_probe':
drivers/mfd/jz4740-adc.c:290: warning: passing argument 3 of 'mfd_add_devices' discards qualifiers from pointer target type
include/linux/mfd/core.h:93: note: expected 'struct mfd_cell *' but argument is of type 'const struct mfd_cell *'

Also make jz4740_adc_cells static, is not used outside
this driver so no need to make the symbol global.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/jz4740-adc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index ef39528..18ed805 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -181,7 +181,7 @@ static struct resource jz4740_battery_resources[] = {
 	},
 };
 
-const struct mfd_cell jz4740_adc_cells[] = {
+static struct mfd_cell jz4740_adc_cells[] = {
 	{
 		.id = 0,
 		.name = "jz4740-hwmon",
-- 
1.7.5.4



