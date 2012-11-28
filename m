Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2K1Cyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 21:54:43 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52122 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2K1Cym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 21:54:42 -0500
Message-ID: <50B57CE7.9090706@gmail.com>
Date: Wed, 28 Nov 2012 10:54:31 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, macpaul.from.taiwan@gmail.com
CC: benchan@chromium.org, syahn@gctsemi.com, devel@driverdev.osuosl.org,
        pstew@chromium.org, joe@perches.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        Shan Wei <shanwei88@gmail.com>
Subject: Re: [PATCH v4] drivers: staging: remove last usage of NIPQUAD and
 NIP6 in gdm72xx
References: <50B4277A.6080307@gmail.com> <20121127171938.GA17680@kroah.com>
In-Reply-To: <20121127171938.GA17680@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH said, at 2012/11/28 1:19:
> On Tue, Nov 27, 2012 at 10:37:46AM +0800, Shan Wei wrote:
>> From: Shan Wei <davidshan@tencent.com>
>>
>> commit cf4ca4874fc45 removed the definition of NIPQUAD and NIPQUAD_FMT,
>> and NIP6 also is out of date.
>>
>> Because DEBUG_SDU is not defined in gdm_wimax.h, no error message when compiling
>> this code. And remove constant condition judge.
>>
>>
>> Signed-off-by: Shan Wei <davidshan@tencent.com>
>> ---
>> V3:
>>    As suggestion of greg k-h's patch email bot, recreate this patch base on greg's staging tree,
>>    v2 is on David Miller's net-next tree.
> 
> Are you sure you got the right branch?  This does not apply to my
> staging-next branch of the staging.git tree, what did you use?

Just create the patch base on you master of the staging.git, not the staging-next branch.
(It's different from David Miller, who has individual git tree for next development. :-( )

-------------------------------------------------------------

>From 0b48de95a28f68f6d32f25b77ecc006a9d8a94b9 Mon Sep 17 00:00:00 2001
From: Shan Wei <davidshan@tencent.com>
Date: Wed, 28 Nov 2012 10:45:00 +0800
Subject: [PATCH staging-next v4] drivers: staging: use %pI4 format to print IPv4 address and remove last usage of NIP6

commit cf4ca4874fc45 removed the definition of NIPQUAD and NIPQUAD_FMT,
and NIP6 also is out of date.

commit 2874762b31d8d replace deprecated NIPQUAD marco to C code, but we can use %pI4 to
print IPv4 address more simply. And remove constant condition judge.

Because DEBUG_SDU is not defined in gdm_wimax.h, no error message when compiling. 


Signed-off-by: Shan Wei <davidshan@tencent.com>
---
 drivers/staging/gdm72xx/gdm_wimax.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index c302769..41efbee 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -168,24 +168,13 @@ static void dump_eth_packet(const char *title, u8 *data, int len)
 		get_ip_protocol_name(ip_protocol),
 		get_port_name(port));
 
-	#if 1
 	if (!(data[0] == 0xff && data[1] == 0xff)) {
 		if (protocol == ETH_P_IP) {
-			printk(KERN_DEBUG "     src=%u.%u.%u.%u\n",
-				((unsigned char *)&(ih->saddr))[0],
-				((unsigned char *)&(ih->saddr))[1],
-				((unsigned char *)&(ih->saddr))[2],
-				((unsigned char *)&(ih->saddr))[3]);
+			printk(KERN_DEBUG "     src=%pI4\n", &ih->saddr);
 		} else if (protocol == ETH_P_IPV6) {
-			#ifdef NIP6
-			printk(KERN_DEBUG "     src=%x:%x:%x:%x:%x:%x:%x:%x\n",
-				NIP6(ih->saddr));
-			#else
 			printk(KERN_DEBUG "     src=%pI6\n", &ih->saddr);
-			#endif
 		}
 	}
-	#endif
 
 	#if (DUMP_PACKET & DUMP_SDU_ALL)
 	printk_hex(data, len);
-- 
1.7.1


