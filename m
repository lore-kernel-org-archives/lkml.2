Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab2HGH2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 03:28:10 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:46466
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498Ab2HGH2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 03:28:07 -0400
X-Forefront-Antispam-Report: CIP:157.56.234.117;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0510HT002.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: PS0(zz98dIc89bh1432Izz1202hzz8275ch8275bh8275dhz2fh2a8h668h839hd24hf0ah107ah17ej)
From: Dongjin Kim <Dongjin.Kim@agreeyamobility.net>
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dongjin Kim <tobetter@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] ARM: EXYNOS: Add HDMIPHY I2C adaptor
Thread-Topic: [PATCH] ARM: EXYNOS: Add HDMIPHY I2C adaptor
Thread-Index: AQHNc9uIoQeukVOAnkKgxs32pAqKQ5dN6/SAgAAIsHk=
Date: Tue, 7 Aug 2012 07:28:02 +0000
Message-ID: <b937n0skj9tqmbg6tctdu48x.1344324481459@email.android.com>
References: <1344261462-14183-1-git-send-email-dongjin.kim@agreeyamobility.net>
	<1344261462-14183-2-git-send-email-dongjin.kim@agreeyamobility.net>,<CAK9yfHz_q22JgkULR9V8bR5W_TXVRn5qs5u2MiJJpa-Br_YQUQ@mail.gmail.com>
In-Reply-To: <CAK9yfHz_q22JgkULR9V8bR5W_TXVRn5qs5u2MiJJpa-Br_YQUQ@mail.gmail.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [::]
Content-Type: text/plain; charset="ks_c_5601-1987"
MIME-Version: 1.0
X-OriginatorOrg: agreeyamobility.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q777SGqO010975

Hi Sachin,

Thanks for your feedback, I couldnt find the patch series eariler. ;)

Regards,
Dongjin.

Sent from Moxier Mail
(http://www.moxier.com)


----- ¿øº» ¸Ş½ÃÁö -----
º¸³½ »ç¶÷:Sachin Kamat <sachin.kamat@linaro.org>
¹Ş´Â »ç¶÷:Dongjin Kim <tobetter@gmail.com>
ÂüÁ¶:Dongjin Kim <Dongjin.Kim@agreeyamobility.net>, Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-samsung-soc@vger.kernel.org" <linux-samsung-soc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
º¸³½ ½Ã°£:2012. 8. 7. 3:57 ¿ÀÈÄ
Á¦¸ñ:Re: [PATCH] ARM: EXYNOS: Add HDMIPHY I2C adaptor



Hi Dongjin,

A patch series to add HDMI platform data support is already under consideration.

http://comments.gmane.org/gmane.linux.kernel.samsung-soc/11352



On 6 August 2012 19:27, Dongjin Kim <tobetter@gmail.com> wrote:
> This patch assign the I2C channel for HDMIPHY for Exynos4x12
> in s5p_i2c_hdmiphy_set_platdata() and s5p_hdmi_set_platdata()
>
> Change-Id: I7e66c8f9327e2f7dce7440efb8583b506d65831a
> Signed-off-by: Dongjin Kim <dongjin.kim@agreeyamobility.net>
> ---
>  arch/arm/plat-samsung/devs.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
> index a199e55..54614d0 100644
> --- a/arch/arm/plat-samsung/devs.c
> +++ b/arch/arm/plat-samsung/devs.c
> @@ -752,6 +752,8 @@ void __init s5p_i2c_hdmiphy_set_platdata(struct s3c2410_platform_i2c *pd)
>
>                 if (soc_is_exynos4210())
>                         pd->bus_num = 8;
> +               else if (soc_is_exynos4212() || soc_is_exynos4412())
> +                       pd->bus_num = 8;
>                 else if (soc_is_s5pv210())
>                         pd->bus_num = 3;
>                 else
> @@ -771,6 +773,8 @@ void __init s5p_hdmi_set_platdata(struct i2c_board_info *hdmiphy_info,
>
>         if (soc_is_exynos4210())
>                 pd->hdmiphy_bus = 8;
> +       else if (soc_is_exynos4212() || soc_is_exynos4412())
> +               pd->hdmiphy_bus = 8;
>         else if (soc_is_s5pv210())
>                 pd->hdmiphy_bus = 3;
>         else
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--
With warm regards,
Sachin

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
