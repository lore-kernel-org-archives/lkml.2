Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab0JKRQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:16:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30616 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab0JKRQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:16:35 -0400
Message-ID: <4CB34606.1040407@oracle.com>
Date: Mon, 11 Oct 2010 10:14:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for September 29 (media & IR build errors)
References: <20100929143604.3d870ddf.sfr@canb.auug.org.au> <20100929083128.4efc3f0d.randy.dunlap@oracle.com> <4CA41431.1000304@redhat.com>
In-Reply-To: <4CA41431.1000304@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/10 21:38, Mauro Carvalho Chehab wrote:
> Em 29-09-2010 12:31, Randy Dunlap escreveu:
>> On Wed, 29 Sep 2010 14:36:04 +1000 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20100928:
>>
>>
>> ERROR: "ir_keydown" [drivers/media/video/ir-kbd-i2c.ko] undefined!
>> ERROR: "__ir_input_register" [drivers/media/video/ir-kbd-i2c.ko] undefined!
>> ERROR: "get_rc_map" [drivers/media/video/ir-kbd-i2c.ko] undefined!
>> ERROR: "ir_input_unregister" [drivers/media/video/ir-kbd-i2c.ko] undefined!
>> ERROR: "get_rc_map" [drivers/media/video/cx88/cx88xx.ko] undefined!
>> ERROR: "ir_repeat" [drivers/media/video/cx88/cx88xx.ko] undefined!
>> ERROR: "ir_input_unregister" [drivers/media/video/cx88/cx88xx.ko] undefined!
>> ERROR: "ir_keydown" [drivers/media/video/cx88/cx88xx.ko] undefined!
>> ERROR: "__ir_input_register" [drivers/media/video/cx88/cx88xx.ko] undefined!
>> ERROR: "get_rc_map" [drivers/media/video/bt8xx/bttv.ko] undefined!
>> ERROR: "ir_input_unregister" [drivers/media/video/bt8xx/bttv.ko] undefined!
>> ERROR: "__ir_input_register" [drivers/media/video/bt8xx/bttv.ko] undefined!
>> ERROR: "ir_core_debug" [drivers/media/IR/ir-common.ko] undefined!
>> ERROR: "ir_g_keycode_from_table" [drivers/media/IR/ir-common.ko] undefined!
> 
> Randy,
> 
> Thanks for the test.
> 
> With Sept, 29 + my linux-next tree (that weren't merged on yesterday's build,
> I didn't notice the above errors). I suspect that the fixes were already on my
> tree.
> 
> I noticed, however, two Kconfig errors on staging (for go7007 and cx25821), related
> to IR_CORE changes:
> 
> warning: (VIDEO_GO7007 && STAGING && !STAGING_EXCLUDE_BUILD && VIDEO_DEV && PCI && I2C && INPUT && BKL && SND || VIDEO_CX25821 && STAGING && !STAGING_EXCLUDE_BUILD && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && BKL) selects VIDEO_IR which has unmet direct dependencies (IR_CORE)
> warning: (VIDEO_CX25821 && STAGING && !STAGING_EXCLUDE_BUILD && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && BKL) selects VIDEO_IR which has unmet direct dependencies (IR_CORE)
> 
> I'm adding the enclosed patch to my linux-next tree in order to fix this trouble.
> On a test after the patch on my tree, your randconfig applied well over my tree.
> So, I'm pushing it to my tree at kernel.org.
> 
> Cheers,
> Mauro
> 
> ---
> 
> commit 9c1eba02d90134fdfa4140b594b2367e90df1dbf
> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:   Thu Sep 30 00:56:08 2010 -0300
> 
>     V4L/DVB: Fix Kconfig dependencies for VIDEO_IR
>     
>     warning: (VIDEO_GO7007 && STAGING && !STAGING_EXCLUDE_BUILD && VIDEO_DEV && PCI && I2C && INPUT && BKL && SND || VIDEO_CX25821 && STAGING && !STAGING_EXCLUDE_BUILD && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && BKL) selects VIDEO_IR which has unmet direct dependencies (IR_CORE)
>     warning: (VIDEO_CX25821 && STAGING && !STAGING_EXCLUDE_BUILD && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && BKL) selects VIDEO_IR which has unmet direct dependencies (IR_CORE)
>     
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Yes, this works.  Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> diff --git a/drivers/staging/cx25821/Kconfig b/drivers/staging/cx25821/Kconfig
> index df7756a..a766d0b 100644
> --- a/drivers/staging/cx25821/Kconfig
> +++ b/drivers/staging/cx25821/Kconfig
> @@ -4,7 +4,7 @@ config VIDEO_CX25821
>  	select I2C_ALGOBIT
>  	select VIDEO_BTCX
>  	select VIDEO_TVEEPROM
> -	select VIDEO_IR
> +	depends on VIDEO_IR
>  	select VIDEOBUF_DVB
>  	select VIDEOBUF_DMA_SG
>  	select VIDEO_CX25840
> diff --git a/drivers/staging/go7007/Kconfig b/drivers/staging/go7007/Kconfig
> index e47f683..b816a60 100644
> --- a/drivers/staging/go7007/Kconfig
> +++ b/drivers/staging/go7007/Kconfig
> @@ -3,7 +3,7 @@ config VIDEO_GO7007
>  	depends on VIDEO_DEV && PCI && I2C && INPUT
>  	depends on SND
>  	select VIDEOBUF_DMA_SG
> -	select VIDEO_IR
> +	depends on VIDEO_IR
>  	select VIDEO_TUNER
>  	select VIDEO_TVEEPROM
>  	select SND_PCM


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
