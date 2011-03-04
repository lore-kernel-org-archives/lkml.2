Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab1CDMBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 07:01:23 -0500
Received: from relay.ihostexchange.net ([66.46.182.51]:44205 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1CDMBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 07:01:22 -0500
From: Dudley Du <dudl@cypress.com>
To: Ben Dooks <ben-linux@fluff.org>, "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "micahc@google.com" <micahc@google.com>,
        "chromium-os-reviews@chromium.org" <chromium-os-reviews@chromium.org>,
        "msb@chromium.org" <msb@chromium.org>,
        "olofj@chromium.org" <olofj@chromium.org>,
        "vbendeb+kernel@chromium.org" <vbendeb+kernel@chromium.org>
Date: Fri, 4 Mar 2011 07:01:15 -0500
Subject: RE: CHROMIUM: arm: tegra: Add platfrom devices for Cypress	trackpad
 (issue6623011)
Thread-Topic: CHROMIUM: arm: tegra: Add platfrom devices for Cypress
	trackpad (issue6623011)
Thread-Index: AcvaYkXHmhaxrB0mSHayVJVccaWP9QAALsTQ
Message-ID: <B27AC323FA92C946BA36D2913DDC8E3701FD6F0B1A5C@VMBX126.ihostexchange.net>
References: <20cf3005123492db71049da6a54a@google.com>
 <20110304114936.GA9995@trinity.fluff.org>
In-Reply-To: <20110304114936.GA9995@trinity.fluff.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p24C1VfQ032218

Hi Ben,

Thanks for your question.

Yes, If sure that these aren't needed, they can remove them.
And the driver already has code to check for NULL and not call them.

Thanks.

Best Wishes,
Dudley Du
86-21-61648950


-----Original Message-----
From: Ben Dooks [mailto:ben-linux@fluff.org] 
Sent: Friday, March 04, 2011 7:50 PM
To: Dudley Du; ccross@android.com; konkers@android.com; olof@lixom.net; linux@arm.linux.org.uk; linux-tegra@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; micahc@google.com; chromium-os-reviews@chromium.org; msb@chromium.org; olofj@chromium.org; vbendeb+kernel@chromium.org
Subject: Re: CHROMIUM: arm: tegra: Add platfrom devices for Cypress trackpad (issue6623011)

On Fri, Mar 04, 2011 at 11:42:54AM +0000, dudl@cypress.com wrote:
> Reviewers: ccross_android.com, konkers_android.com, olof_lixom.net,  
> linux_arm.linux.org.uk, linux-tegra_vger.kernel.org,  
> linux-arm-kernel_lists.infradead.org, linux-kernel_vger.kernel.org, Micah 
> C, dudl,
>
> Description:
> CHROMIUM: arm: tegra: Add platfrom devices for Cypress trackpad
>
> 1. Add platfrom data strcuture cyapa_platfrom_data.
> 2. Add trackpad device into platfrom I2C bus 0.
> 3. Initialize platfrom data for cyapa_platfrom_data.
> 4. This code is merged based kernel version 2.7.37-rc5.
>
>
> Change-Id: I3591317ac9c3b7d5328a9c617d662ad6be6065a2
> Signed-off-by: Du, Dudley <dudl@cypress.com>
>
> BUG=None
> TEST=Test on arm tegra2 seaborad and kaen platform
>
> Please review this at http://codereview.chromium.org/6623011/
>
> SVN Base: http://git.chromium.org/git/kernel-next.git@chromeos-2.6.37-rc5
>
> Affected files:
>   M arch/arm/mach-tegra/board-seaboard.h
>   M arch/arm/mach-tegra/board-seaboard.c
>
>
> Index: arch/arm/mach-tegra/board-seaboard.c
> diff --git a/arch/arm/mach-tegra/board-seaboard.c  
> b/arch/arm/mach-tegra/board-seaboard.c
> index  
> 75fbab68ef61c0c117bb8dafa2aaca90947a860b..de272cc73794c6600994af3c0e834dd884f6b56b 
> 100644
> --- a/arch/arm/mach-tegra/board-seaboard.c
> +++ b/arch/arm/mach-tegra/board-seaboard.c
> @@ -303,6 +303,36 @@ static struct tegra_i2c_platform_data  
> seaboard_dvc_platform_data = {
>  	.is_dvc		= true,
>  };
>
> +/* for Cypress Trackpad. */
> +#include <linux/cyapa.h>
> +
> +static int cyapa_i2c_platform_init(void)
> +{
> +	return 0;
> +}
> +
> +static int cyapa_i2c_platform_wakeup(void)
> +{
> +	return 0;
> +}
> +
> +static struct cyapa_platform_data cyapa_i2c_platform_data = {
> +	.flag = 0,
> +	.gen = CYAPA_GEN2,
> +	.power_state = CYAPA_PWR_ACTIVE,
> +	.use_absolute_mode = false,
> +	.use_polling_mode = false,
> +	.polling_interval_time_active = CYAPA_ACTIVE_POLLING_INTVAL_TIME,
> +	.polling_interval_time_lowpower = CYAPA_LOWPOWER_POLLING_INTVAL_TIME,
> +	.active_touch_timeout = CYAPA_ACTIVE_TOUCH_TIMEOUT,
> +	.name = CYAPA_I2C_NAME,
> +	.irq_gpio = TEGRA_GPIO_CYTP_INT,
> +	.report_rate = CYAPA_REPORT_RATE,
> +
> +	.wakeup = cyapa_i2c_platform_wakeup,
> +	.init = cyapa_i2c_platform_init,

if these aren't needed, then why not get the driver to check for NULL
and not call them?

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
