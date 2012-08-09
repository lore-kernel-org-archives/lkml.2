Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab2HIQ1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 12:27:47 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:37140 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab2HIQ1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 12:27:45 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-160.messagelabs.com!1344529663!7854262!2
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: =?utf-8?B?R8O8bmfDtnIgRXJzZXltZW4=?= <gelurine@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 9 Aug 2012 11:27:41 -0500
Subject: RE: [PATCH] Staging: comedi: ssv_snp: fix checkpatch.pl warnings
Thread-Topic: [PATCH] Staging: comedi: ssv_snp: fix checkpatch.pl warnings
Thread-Index: Ac12QpCz5C7wxtsHTi6htGO2Tu2skgAB6IUg
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206AAE97175@AUSP01VMBX24.collaborationhost.net>
References: <1344525614-13910-1-git-send-email-gelurine@gmail.com>
In-Reply-To: <1344525614-13910-1-git-send-email-gelurine@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q79GS078028015

On Thursday, August 09, 2012 8:20 AM, GÃ¼ngÃ¶r Erseymen wrote:
> Fix two checkpatch.pl warnings about printk issues by using
> pr_info(...) instead of printk(KERN_INFO, ...).
>
> Signed-off-by: GÃ¼ngÃ¶r Erseymen <gelurine@gmail.com>
> ---
>  drivers/staging/comedi/drivers/ssv_dnp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Hello GÃ¼ngÃ¶r,

You have a typo in the subject for this patch.
"ssv_snp" should be "ssv_dnp"

>
> diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
> index 84b9f2a..4cd0f1b 100644
> --- a/drivers/staging/comedi/drivers/ssv_dnp.c
> +++ b/drivers/staging/comedi/drivers/ssv_dnp.c
> @@ -177,7 +177,7 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  	struct comedi_subdevice *s;
>  	int ret;
>  
> -	printk(KERN_INFO "comedi%d: dnp: ", dev->minor);
> +	pr_info("comedi%d: dnp: ", dev->minor);
 
Where possible, fixes like this should use the dev_printk versions.
For instance, this one would be:

	dev_info(dev->class_dev, "dnp:");

But, there is a cleaner fix for this file. See below.

> 	dev->board_name = board->name;
>
> @@ -195,7 +195,7 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
> 	s->insn_bits = dnp_dio_insn_bits;
> 	s->insn_config = dnp_dio_insn_config;
> 
> -	printk("attached\n");
> +	pr_info("attached\n");

There are only two printk's in this file, both in the "attach" routine.

The first one does not have a "\n" and the function could exit without
ever terminating the message.

A better fix would be to merge the two messages into one "attached" message
at the end of the function. You could also use the dev->board_name instead of
the open coded string. Something like:

	dev_info(dev->class_dev, "%s: attached\n", dev->board_name);

Also, the message should be moved so that it's the last thing that happens
before the function returns.

Regards,
Hartley

> 
>  	/* We use the I/O ports 0x22,0x23 and 0xa3-0xa9, which are always
> 	 * allocated for the primary 8259, so we don't need to allocate them
-- 
1.7.11.4

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
