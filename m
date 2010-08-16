Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab0HPMem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:34:42 -0400
Received: from dakia3.marvell.com ([65.219.4.28]:57360 "EHLO
	dakia3.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0HPMel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:34:41 -0400
X-ASG-Debug-ID: 1281962081-6c37f8c10001-xx1T2L
X-Barracuda-Envelope-From: leiwen@marvell.com
From: Lei Wen <leiwen@marvell.com>
X-Barracuda-BBL-IP: 10.93.76.133
X-Barracuda-RBL-IP: 10.93.76.133
To: Eric Miao <eric.y.miao@gmail.com>, Axel Lin <axel.lin@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Haojian Zhuang <hzhuang1@marvell.com>
Date: Mon, 16 Aug 2010 05:34:38 -0700
X-ASG-Orig-Subj: RE: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for
 samsung2GbX8
Subject: RE: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for
 samsung2GbX8
Thread-Topic: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for
 samsung2GbX8
Thread-Index: Acs9PbCVWEnfm5oJRymOjYwfOYnbigAAS4DQ
Message-ID: <53612FE6B944314AAADB181E45A45B64133DDFC156@sc-vexch3.marvell.com>
In-Reply-To: <AANLkTi=YSS0-Nf4MWOw30YDrCdrkmtzLhv7DXfsoJTjX@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Barracuda-Connect: sc-owa02.marvell.com[10.93.76.22]
X-Barracuda-Start-Time: 1281962081
X-Barracuda-Encrypted: RC4-MD5
X-Barracuda-URL: http://dakia3.marvell.com:80/cgi-mod/mark.cgi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7GCYrpA000445

Hi Axel,

I suggest not merge your patch into mainline code. Since I have a large series of patch which reconstruct the nand flash definition, this fix would no longer be needed.

Thanks,
Lei

-----Original Message-----
From: Eric Miao [mailto:eric.y.miao@gmail.com] 
Sent: 2010å¹´8æœˆ16æ—¥ 20:22
To: Axel Lin
Cc: linux-kernel; David Woodhouse; linux-mtd@lists.infradead.org; Lei Wen; Haojian Zhuang
Subject: Re: [PATCH] [MTD] [NAND] pxa3xx: fix timing and cmdset for samsung2GbX8

Cc'ed Lei and Haojian.

On Mon, Aug 16, 2010 at 4:50 PM, Axel Lin <axel.lin@gmail.com> wrote:
> This patch adds timing settings for samsung2GbX8 and
> fixes the cmdset settings. samsung2GbX8 is large page.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Â drivers/mtd/nand/pxa3xx_nand.c | Â  16 ++++++++++++++--
> Â 1 files changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
> index 4d89f37..47c0442 100644
> --- a/drivers/mtd/nand/pxa3xx_nand.c
> +++ b/drivers/mtd/nand/pxa3xx_nand.c
> @@ -227,9 +227,21 @@ static struct pxa3xx_nand_flash samsung512MbX16 = {
> Â  Â  Â  Â .chip_id Â  Â  Â  Â = 0x46ec,
> Â };
>
> +static struct pxa3xx_nand_timing samsung2GbX8_timing = {
> + Â  Â  Â  .tCH Â  Â = 5,
> + Â  Â  Â  .tCS Â  Â = 20,
> + Â  Â  Â  .tWH Â  Â = 10,
> + Â  Â  Â  .tWP Â  Â = 12,
> + Â  Â  Â  .tRH Â  Â = 10,
> + Â  Â  Â  .tRP Â  Â = 12,
> + Â  Â  Â  .tR Â  Â  = 25000,
> + Â  Â  Â  .tWHR Â  = 60,
> + Â  Â  Â  .tAR Â  Â = 10,
> +};
> +
> Â static struct pxa3xx_nand_flash samsung2GbX8 = {
> - Â  Â  Â  .timing Â  Â  Â  Â  = &samsung512MbX16_timing,
> - Â  Â  Â  .cmdset Â  Â  Â  Â  = &smallpage_cmdset,
> + Â  Â  Â  .timing Â  Â  Â  Â  = &samsung2GbX8_timing,
> + Â  Â  Â  .cmdset Â  Â  Â  Â  = &largepage_cmdset,
> Â  Â  Â  Â .page_per_block = 64,
> Â  Â  Â  Â .page_size Â  Â  Â = 2048,
> Â  Â  Â  Â .flash_width Â  Â = 8,
> --
> 1.7.2
>
>
>
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
