Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997Ab2EQOrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 10:47:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43860 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759873Ab2EQOra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 10:47:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120516175515.GX30400@pengutronix.de>
References: <1337135616-8988-1-git-send-email-rob.lee@linaro.org>
 <1337135616-8988-6-git-send-email-rob.lee@linaro.org> <20120516175515.GX30400@pengutronix.de>
From: Rob Lee <rob.lee@linaro.org>
Date: Thu, 17 May 2012 09:47:08 -0500
Message-ID: <CAMXH7KEj8LGZdPm_MsQif4RrsrnDJExYTJY4k9SCz7zzmgpAbw@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] ARM: imx: Add common imx cpuidle init functionality.
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org,
        u.kleine-koenig@pengutronix.de, richard.zhao@freescale.com,
        amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 12:55 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Tue, May 15, 2012 at 09:33:34PM -0500, Robert Lee wrote:
>> Add common cpuidle init functionality that can be used by various
>> imx platforms.
>>
>> Signed-off-by: Robert Lee <rob.lee@linaro.org>
>> ---
>> +
>> +#ifdef CONFIG_CPU_IDLE
>> +extern int imx_cpuidle_init(struct cpuidle_driver *drv);
>> +#else
>> +static inline int imx_cpuidle_init(struct cpuidle_driver *drv)
>> +{
>> +     return -ENODEV;
>> +}
>> +#endif
>
> You should return succesfully here. Think about it, if imx_cpuidle_init
> fails you basically do nothing except maybe printing an error message
> which will be irritating when it appears on a kernel with cpuidle
> disabled.

Oops, yeah, I missed that.  Will fix in v5.

Thanks,
Rob

>
> Sascha
>
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
