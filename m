Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab2EJIfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:35:39 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:39180 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757401Ab2EJIff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:35:35 -0400
Message-ID: <4FAB7DC1.5060503@stericsson.com>
Date: Thu, 10 May 2012 10:35:13 +0200
From: Ola Lilja <ola.o.lilja@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
References: <20120510143329.4cef3cd78ce5ea55416b1d93@canb.auug.org.au> <CACRpkdYsHXnWHvBw6Pt1atvwKP6KYjfu-PwQnL_L7-yW1-4_FA@mail.gmail.com>
In-Reply-To: <CACRpkdYsHXnWHvBw6Pt1atvwKP6KYjfu-PwQnL_L7-yW1-4_FA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 10:30 AM, Linus Walleij wrote:

> On Thu, May 10, 2012 at 6:33 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> After merging the sound-asoc tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> In file included from sound/soc/ux500/ux500_msp_dai.c:21:0:
>> include/linux/mfd/dbx500-prcmu.h:614:19: error: redefinition of 'prcmu_abb_read'
>> include/linux/mfd/db8500-prcmu.h:673:19: note: previous definition of 'prcmu_abb_read' was here
>> include/linux/mfd/dbx500-prcmu.h:619:19: error: redefinition of 'prcmu_abb_write'
>> include/linux/mfd/db8500-prcmu.h:678:19: note: previous definition of 'prcmu_abb_write' was here
>> include/linux/mfd/dbx500-prcmu.h:630:19: error: redefinition of 'prcmu_config_clkout'
>> include/linux/mfd/db8500-prcmu.h:643:19: note: previous definition of 'prcmu_config_clkout' was here
>> include/linux/mfd/dbx500-prcmu.h:692:20: error: redefinition of 'prcmu_ac_wake_req'
>> include/linux/mfd/db8500-prcmu.h:683:20: note: previous definition of 'prcmu_ac_wake_req' was here
>> include/linux/mfd/dbx500-prcmu.h:694:20: error: redefinition of 'prcmu_ac_sleep_req'
>> include/linux/mfd/db8500-prcmu.h:685:20: note: previous definition of 'prcmu_ac_sleep_req' was here
>> sound/soc/ux500/ux500_msp_dai.c:23:27: fatal error: mach/hardware.h: No such file or directory
>> sound/soc/ux500/ux500_msp_i2s.c:21:27: fatal error: mach/hardware.h: No such file or directory
>>
>> Possibly caused by commit 3592b7f69a54 ("ASoC: Ux500: Add MSP I2S-driver").
>>
>> I have used the version of the sound-asoc tree from next-20120508 for today.
> 
> The PRCMU driver is only available on the UX500 platforms so building
> on x86_64 does not make sense.
> 
> Ola/Mark: a simple patch like this should solve the issue I think?


True! I think we should put it in the "config SND_SOC_UX500_PLAT_MSP_I2S", though.

> 
> diff --git a/sound/soc/ux500/Kconfig b/sound/soc/ux500/Kconfig
> index 9b0ae4e..f454f06 100644
> --- a/sound/soc/ux500/Kconfig
> +++ b/sound/soc/ux500/Kconfig
> @@ -4,6 +4,7 @@
>  menuconfig SND_SOC_UX500
>         tristate "SoC Audio support for Ux500 platform"
>         depends on SND_SOC
> +       depends on MFD_DB8500_PRCMU
>         help
>                 Say Y if you want to enable ASoC-support for
>                 any of the Ux500 platforms (e.g. U8500).
> 
> 
> But it seems it has a wider dependency on some MOP500 board
> stuff being merged first, which is more of a problem I think, part
> of that is pending in the Ux500 tree.
> 
> Yours,
> Linus Walleij


