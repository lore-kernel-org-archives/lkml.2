Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab2IKU5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 16:57:18 -0400
Received: from 115-188-14-127.jetstream.xtra.co.nz ([115.188.14.127]:57843
	"EHLO SERVER.prisktech.co.nz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752723Ab2IKU5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 16:57:17 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: "arnd@arndb.de" <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH 10/16] ARM: vt8500: move platform_data definitions
Thread-Topic: [PATCH 10/16] ARM: vt8500: move platform_data definitions
Thread-Index: AQHNkF+Ta5l2nxlOZk61O7Fc1NNgAg==
Date: Tue, 11 Sep 2012 20:54:03 +0000
Message-ID: <1347397033.2141.4.camel@gitbox>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-10-git-send-email-arnd@arndb.de>
In-Reply-To: <1347368390-31252-10-git-send-email-arnd@arndb.de>
Accept-Language: en-GB, en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8BKvLqj026094

On Tue, 2012-09-11 at 14:59 +0200, Arnd Bergmann wrote:
> Platform data for device drivers should be defined in
> include/linux/platform_data/*.h, not in the architecture
> and platform specific directories.
> 
> This moves such data out of the vt8500 include directories
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Tony Prisk <linux@prisktech.co.nz>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> ---
>  arch/arm/mach-vt8500/devices.c                                       |    2 +-
>  drivers/video/vt8500lcdfb.c                                          |    2 +-
>  drivers/video/wm8505fb.c                                             |    2 +-
>  .../vt8500fb.h => include/linux/platform_data/video-vt8500lcdfb.h    |    0
>  4 files changed, 3 insertions(+), 3 deletions(-)
>  rename arch/arm/mach-vt8500/include/mach/vt8500fb.h => include/linux/platform_data/video-vt8500lcdfb.h (100%)
> 
> diff --git a/arch/arm/mach-vt8500/devices.c b/arch/arm/mach-vt8500/devices.c
> index 1fcdc36..82b4bce 100644
> --- a/arch/arm/mach-vt8500/devices.c
> +++ b/arch/arm/mach-vt8500/devices.c
> @@ -23,7 +23,7 @@
>  
>  #include <asm/mach/arch.h>
>  
> -#include <mach/vt8500fb.h>
> +#include <linux/platform_data/video-vt8500lcdfb.h>
>  #include <mach/i8042.h>
>  #include "devices.h"
>  
> diff --git a/drivers/video/vt8500lcdfb.c b/drivers/video/vt8500lcdfb.c
> index 2a5fe6e..66a74f9 100644
> --- a/drivers/video/vt8500lcdfb.c
> +++ b/drivers/video/vt8500lcdfb.c
> @@ -30,7 +30,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/wait.h>
>  
> -#include <mach/vt8500fb.h>
> +#include <linux/platform_data/video-vt8500lcdfb.h>
>  
>  #include "vt8500lcdfb.h"
>  #include "wmt_ge_rops.h"
> diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
> index c8703bd..ffeff48 100644
> --- a/drivers/video/wm8505fb.c
> +++ b/drivers/video/wm8505fb.c
> @@ -29,7 +29,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/wait.h>
>  
> -#include <mach/vt8500fb.h>
> +#include <linux/platform_data/video-vt8500lcdfb.h>
>  
>  #include "wm8505fb_regs.h"
>  #include "wmt_ge_rops.h"
> diff --git a/arch/arm/mach-vt8500/include/mach/vt8500fb.h b/include/linux/platform_data/video-vt8500lcdfb.h
> similarity index 100%
> rename from arch/arm/mach-vt8500/include/mach/vt8500fb.h
> rename to include/linux/platform_data/video-vt8500lcdfb.h

Acked-by: Tony Prisk <linux@prisktech.co.nz>

Be aware that my current patch series (which has now been finalized)
drops mach-vt8500/devices.c so you might get a conflict depending on the
patch order.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
