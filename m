Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab1BVO0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:26:41 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:56387 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab1BVO0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:26:39 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <dmitry.torokhov@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, "'Greg KH'" <greg@kroah.com>
References: <015701cbcdae$7d5f43f0$781dcbd0$@mprc.pku.edu.cn> <201102171803.15785.arnd@arndb.de> <00eb01cbcf56$9f372700$dda57500$@mprc.pku.edu.cn> <201102181133.26675.arnd@arndb.de>
In-Reply-To: <201102181133.26675.arnd@arndb.de>
Subject: RE: [PATCH 11/12] unicore32 machine related files: ps2 driver
Date: Tue, 22 Feb 2011 22:26:26 +0800
Message-ID: <019001cbd29c$7cee6340$76cb29c0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHwh2GX42xqIG1pSB6ZyMOWdcE4LgJvzZEgAUaPKUACEqlRcZOV4dSA
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Friday, February 18, 2011 6:33 PM
> To: Guan Xuetao
> Cc: dmitry.torokhov@gmail.com; linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; 'Greg KH'
> Subject: Re: [PATCH 11/12] unicore32 machine related files: ps2 driver
> 
> On Friday 18 February 2011 11:28:45 Guan Xuetao wrote:
> >   * Register numbers.
> >   */
> > -#define I8042_COMMAND_REG      ((unsigned long)&PS2_COMMAND)
> > -#define I8042_STATUS_REG       ((unsigned long)&PS2_STATUS)
> > -#define I8042_DATA_REG         ((unsigned long)&PS2_DATA)
> > +#define I8042_COMMAND_REG      ((volatile void __iomem *)&PS2_COMMAND)
> > +#define I8042_STATUS_REG       ((volatile void __iomem *)&PS2_STATUS)
> > +#define I8042_DATA_REG         ((volatile void __iomem *)&PS2_DATA)
> > +
> > +#define I8042_REGION_START     (resource_size_t)(&PS2_DATA)
> > +#define I8042_REGION_SIZE      (resource_size_t)(16)
> 
> It would be better to remove the cast and make the PS2_COMMAND
> etc macros have the correct type. Aside from this, the change
> looks good.
With the patch for __REG in unicore32, following patch could be applied:
drivers/input/serio/i8042-unicore32io.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/serio/i8042-unicore32io.h b/drivers/input/serio/i8042-unicore32io.h
index 2cdd872..9350843 100644
--- a/drivers/input/serio/i8042-unicore32io.h
+++ b/drivers/input/serio/i8042-unicore32io.h
@@ -29,11 +29,11 @@
 /*
  * Register numbers.
  */
-#define I8042_COMMAND_REG	((volatile void __iomem *)&PS2_COMMAND)
-#define I8042_STATUS_REG	((volatile void __iomem *)&PS2_STATUS)
-#define I8042_DATA_REG		((volatile void __iomem *)&PS2_DATA)
+#define I8042_COMMAND_REG	PS2_COMMAND
+#define I8042_STATUS_REG	PS2_STATUS
+#define I8042_DATA_REG		PS2_DATA
 
-#define I8042_REGION_START	(resource_size_t)(&PS2_DATA)
+#define I8042_REGION_START	(resource_size_t)(PS2_DATA)
 #define I8042_REGION_SIZE	(resource_size_t)(16)
 
 static inline int i8042_read_data(void)

> 
> 	Arnd
Thanks & Regards.

Guan Xuetao

