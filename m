Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab1HQFXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 01:23:31 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:53204 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1HQFX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 01:23:28 -0400
Subject: Re: [PATCH] mtd/physmap: Fix set_vpp signature in physmap_configure
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 17 Aug 2011 08:25:08 +0300
In-Reply-To: <1312498433-17950-1-git-send-email-grant.likely@secretlab.ca>
References: <1312498433-17950-1-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313558713.2679.7.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 23:53 +0100, Grant Likely wrote:
> physmap_configure() has the wrong signature for the set_vpp callback.
> struct physmap_flash_data expects it to accpet a platform_device
> pointer.
> 
> However, I can't find any users of physmap_configure(), so maybe the
> hook should simply be removed.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

We have the following patch in l2-mtd-2.6.git waiting for being merged:

commit a0b50813e689760de9ccd85e1b29906c2540a7e0
Author: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Date:   Thu Jun 2 18:51:14 2011 +0400

    mtd: drop physmap_configure
    
    physmap_configure() and physmap_set_partitions() have no users in kernel.
    Out of kernel users should have been converted to regular platform device
    long ago. Drop support for this obsolete API.
    
    Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index f64cee4..2174d10 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -245,21 +245,6 @@ static struct platform_device physmap_flash = {
        .num_resources  = 1,
        .resource       = &physmap_flash_resource,
 };
-
-void physmap_configure(unsigned long addr, unsigned long size,
-               int bankwidth, void (*set_vpp)(struct map_info *, int))
-{
-       physmap_flash_resource.start = addr;
-       physmap_flash_resource.end = addr + size - 1;
-       physmap_flash_data.width = bankwidth;
-       physmap_flash_data.set_vpp = set_vpp;
-}
-
-void physmap_set_partitions(struct mtd_partition *parts, int num_parts)
-{
-       physmap_flash_data.nr_parts = num_parts;
-       physmap_flash_data.parts = parts;
-}
 #endif
 
 static int __init physmap_init(void)

-- 
Best Regards,
Artem Bityutskiy

