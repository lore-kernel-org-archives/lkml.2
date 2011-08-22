Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab1HVQfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:35:12 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:54842 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1HVQfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:35:09 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-127.messagelabs.com!1314030897!29125818!38
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.31]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 22 Aug 2011 11:35:04 -0500
Subject: RE: [PATCH] backlight: ep93xx_bl: add missing include of
 linux/module.h
Thread-Topic: [PATCH] backlight: ep93xx_bl: add missing include of
 linux/module.h
Thread-Index: AcxgD3Mycs4btxLnQieZaNzZGb3iRAA2UzuA
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F388575247@AUSP01VMBX24.collaborationhost.net>
References: <1313937209.13671.3.camel@phoenix>
In-Reply-To: <1313937209.13671.3.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7MGZIl1021687

On Sunday, August 21, 2011 7:33 AM, Axel Lin wrote:
>
> ep93xx_bl.c uses interfaces from linux/module.h,
> so it should include that file. This patch fixes below build errors.
> 
>   CC [M]  drivers/video/backlight/ep93xx_bl.o
> drivers/video/backlight/ep93xx_bl.c:138: error: 'THIS_MODULE' undeclared here (not in a function)
> drivers/video/backlight/ep93xx_bl.c:158: error: expected declaration specifiers or '...' before string constant
> drivers/video/backlight/ep93xx_bl.c:158: warning: data definition has no type or storage class
> drivers/video/backlight/ep93xx_bl.c:158: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
> drivers/video/backlight/ep93xx_bl.c:158: warning: function declaration isn't a prototype
> drivers/video/backlight/ep93xx_bl.c:159: error: expected declaration specifiers or '...' before string constant
> drivers/video/backlight/ep93xx_bl.c:159: warning: data definition has no type or storage class
> drivers/video/backlight/ep93xx_bl.c:159: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
> drivers/video/backlight/ep93xx_bl.c:159: warning: function declaration isn't a prototype
> drivers/video/backlight/ep93xx_bl.c:160: error: expected declaration specifiers or '...' before string constant
> drivers/video/backlight/ep93xx_bl.c:160: warning: data definition has no type or storage class
> drivers/video/backlight/ep93xx_bl.c:160: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
> drivers/video/backlight/ep93xx_bl.c:160: warning: function declaration isn't a prototype
> drivers/video/backlight/ep93xx_bl.c:161: error: expected declaration specifiers or '...' before string constant
> drivers/video/backlight/ep93xx_bl.c:161: warning: data definition has no type or storage class
> drivers/video/backlight/ep93xx_bl.c:161: warning: type defaults to 'int' in declaration of 'MODULE_ALIAS'
> drivers/video/backlight/ep93xx_bl.c:161: warning: function declaration isn't a prototype
> make[3]: *** [drivers/video/backlight/ep93xx_bl.o] Error 1
> make[2]: *** [drivers/video/backlight] Error 2
> make[1]: *** [drivers/video] Error 2
> make: *** [drivers] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/video/backlight/ep93xx_bl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
> index 9f1e389..b058291 100644
> --- a/drivers/video/backlight/ep93xx_bl.c
> +++ b/drivers/video/backlight/ep93xx_bl.c
> @@ -11,7 +11,7 @@
>   * BRIGHT, on the Cirrus EP9307, EP9312, and EP9315 processors.
>   */
>  
> -
> +#include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/fb.h>

Ah.. This was due to commit 089f5643ba "include: replace linux/module.h with
"struct module" wherever possible".

Before that commit, including <linux/platform_device.h> would pull in <linux/device.h>
which would then pull in <linux/module.h>.  Now any driver using the MODULE_ macros
needs to include <linux/module.h> directly.

Looks correct to me.

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
