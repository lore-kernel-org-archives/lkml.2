Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab1COIiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:38:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab1COIix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:38:53 -0400
Message-ID: <4D7F2609.3080508@redhat.com>
Date: Tue, 15 Mar 2011 09:40:41 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Jean Delvare <khali@linux-fr.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (jdelvare-hwmon
 tree related)
References: <20110315192428.ce74a177.sfr@canb.auug.org.au>
In-Reply-To: <20110315192428.ce74a177.sfr@canb.auug.org.au>
Content-Type: multipart/mixed;
 boundary="------------020301000309030604090703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020301000309030604090703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 03/15/2011 09:24 AM, Stephen Rothwell wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> drivers/hwmon/sch5627.c: In function 'sch5627_read_virtual_reg':
> drivers/hwmon/sch5627.c:179: error: implicit declaration of function 'msleep'
>
> Caused by commit 19803daeb145 ("hwmon: New driver for SMSC SCH5627").
> See Rule 1 in Documentation/SubmitChecklist.
>
> I have reverted that commit for today.

The attached patch should fix this, Jean can you please add this to your
tree? Note feel free to merge it into the initial patch adding the sch5627 driver
if you prefer.

Thanks & Regards,

Hans

--------------020301000309030604090703
Content-Type: text/plain;
 name="0001-hwmon-sch5627-include-linux-delay.h-for-msleep-proto.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-hwmon-sch5627-include-linux-delay.h-for-msleep-proto.pa";
 filename*1="tch"

>From a5ffc5ddcdb230fcb10fe6c80ebe043c25763416 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Tue, 15 Mar 2011 09:37:47 +0100
Subject: [PATCH] hwmon/sch5627: include linux/delay.h for msleep prototype

This should fix sch5627 breaking the building of linux-next

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/hwmon/sch5627.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/sch5627.c b/drivers/hwmon/sch5627.c
index 0001331..9a51dcc 100644
--- a/drivers/hwmon/sch5627.c
+++ b/drivers/hwmon/sch5627.c
@@ -30,6 +30,7 @@
 #include <linux/mutex.h>
 #include <linux/io.h>
 #include <linux/acpi.h>
+#include <linux/delay.h>
 
 #define DRVNAME "sch5627"
 #define DEVNAME DRVNAME /* We only support one model */
-- 
1.7.3.2


--------------020301000309030604090703--
