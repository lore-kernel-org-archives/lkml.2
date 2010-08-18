Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab0HRGd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 02:33:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59373 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab0HRGdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 02:33:15 -0400
From: "Gopinath, Thara" <thara@ti.com>
To: "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 18 Aug 2010 12:02:57 +0530
Subject: RE: [PATCH 2/4] mfd: twl-core: switch over to defines in twl.h
Thread-Topic: [PATCH 2/4] mfd: twl-core: switch over to defines in twl.h
Thread-Index: Acs+nXqJ8hHRYDofRhWBchGE0xLBgQAAUTKQ
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB032422229C@dbde02.ent.ti.com>
References: <1282112377-1335-1-git-send-email-felipe.balbi@nokia.com>
 <1282112377-1335-3-git-send-email-felipe.balbi@nokia.com>
In-Reply-To: <1282112377-1335-3-git-send-email-felipe.balbi@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>>-----Original Message-----
>>From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of
>>felipe.balbi@nokia.com
>>Sent: Wednesday, August 18, 2010 11:50 AM
>>To: Samuel Ortiz
>>Cc: linux-kernel@vger.kernel.org; linux-omap@vger.kernel.org; Tony Lindgren; Andrew Morton; Felipe
>>Balbi
>>Subject: [PATCH 2/4] mfd: twl-core: switch over to defines in twl.h
>>
>>From: Felipe Balbi <felipe.balbi@nokia.com>
>>
>>use the new definitions on twl header for code
>>consistency.
>>
>>Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
>>---
>> drivers/mfd/twl-core.c |   21 +++++++++------------
>> 1 files changed, 9 insertions(+), 12 deletions(-)
>>
>>diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
>>index 720e099..9689ecf 100644
>>--- a/drivers/mfd/twl-core.c
>>+++ b/drivers/mfd/twl-core.c
>>@@ -202,12 +202,6 @@
>>
>> /* Few power values */
>> #define R_CFG_BOOT			0x05
>>-#define R_PROTECT_KEY			0x0E
>>-
>>-/* access control values for R_PROTECT_KEY */
>>-#define KEY_UNLOCK1			0xce
>>-#define KEY_UNLOCK2			0xec
>>-#define KEY_LOCK			0x00
>>
>> /* some fields in R_CFG_BOOT */
>> #define HFCLK_FREQ_19p2_MHZ		(1 << 0)
>>@@ -846,8 +840,8 @@ static inline int __init protect_pm_master(void)
>> {
>> 	int e = 0;
>>
>>-	e = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, KEY_LOCK,
>>-			R_PROTECT_KEY);
>>+	e = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0,
>>+			TWL4030_PM_MASTER_PROTECT_KEY);

Hello Felipe,

R_PROTECT_KEY offset is 0xE where as the new TWL4030_PM_MASTER_PROTECT_KEY
is defined as 0xd. I have not checked the trm to see which is correct. But
I hope this is a conscious change. Else we will end up breaking the functionality.
Also if this is a conscious change may be you should mention it in the patch
description. This comment applies to all other places where R_PROTECT_KEY has
been replaced with TWL4030_PM_MASTER_PROTECT_KEY in this patch as well as in
patch 3/4 and patch 4/4.

Regards
Thara

>> 	return e;
>> }
>>
>>@@ -855,10 +849,13 @@ static inline int __init unprotect_pm_master(void)
>> {
>> 	int e = 0;
>>
>>-	e |= twl_i2c_write_u8(TWL_MODULE_PM_MASTER, KEY_UNLOCK1,
>>-			R_PROTECT_KEY);
>>-	e |= twl_i2c_write_u8(TWL_MODULE_PM_MASTER, KEY_UNLOCK2,
>>-			R_PROTECT_KEY);
>>+	e |= twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
>>+			TWL4030_PM_MASTER_KEY_CFG1,
>>+			TWL4030_PM_MASTER_PROTECT_KEY);
>>+	e |= twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
>>+			TWL4030_PM_MASTER_KEY_CFG2,
>>+			TWL4030_PM_MASTER_PROTECT_KEY);
>>+
>> 	return e;
>> }
>>
>>--
>>1.7.2.1.6.g61bf12
>>
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
