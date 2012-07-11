Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab2GKI2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 04:28:55 -0400
Received: from antcom.de ([188.40.178.216]:38665 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab2GKI2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 04:28:50 -0400
Message-ID: <4FFD393F.1070104@antcom.de>
Date: Wed, 11 Jul 2012 10:28:47 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Subject: Re: [PATCH v2 04/23] ARM: LPC32xx: Add DMA configuration to platform
 data
References: <1339692673-7848-1-git-send-email-stigge@antcom.de> <1339692673-7848-5-git-send-email-stigge@antcom.de> <201207102136.35944.arnd@arndb.de>
In-Reply-To: <201207102136.35944.arnd@arndb.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 11:36 PM, Arnd Bergmann wrote:
>> +/* NOTE: These will change, according to RMK */
>> +static int pl08x_get_signal(struct pl08x_dma_chan *ch)
>> +{
>> +	return ch->cd->min_signal;
>> +}
>> +
> 
> This has changed now, rendering linux-next broken for lpc32xx_defconfig:
> 
> /home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:190:36: warning: 'struct pl08x_dma_chan' declared inside parameter list [enabled by default]
> /home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:190:36: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> /home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c: In function 'pl08x_get_signal':
> /home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:192:11: error: dereferencing pointer to incomplete type
> /home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c: At top level:
> /home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:195:37: warning: 'struct pl08x_dma_chan' declared inside parameter list [enabled by default]
> /home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:202:2: warning: initialization from incompatible pointer type [enabled by default]
> /home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:202:2: warning: (near initialization for 'pl08x_pd.get_signal') [enabled by default]
> /home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:203:2: warning: initialization from incompatible pointer type [enabled by default]
> /home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:203:2: warning: (near initialization for 'pl08x_pd.put_signal') [enabled by default]
> /home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c: In function 'pl08x_get_signal':
> /home/arnd/linux-arm/arch/arm/mach-lpc32xx/phy3250.c:193:1: warning: control reaches end of non-void function [-Wreturn-type]
> /home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_slc.c: In function 'lpc32xx_dma_filter':
> /home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_slc.c:720:48: error: dereferencing pointer to incomplete type
> /home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_slc.c:720:67: warning: initialization from incompatible pointer type [enabled by default]
> /home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_slc.c:720:67: warning: (near initialization for 'ch') [enabled by default]
> /home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_slc.c:720:145: error: invalid use of undefined type 'struct pl08x_dma_chan'
> /home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_slc.c:723:8: error: dereferencing pointer to incomplete type
> make[4]: *** [drivers/mtd/nand/lpc32xx_slc.o] Error 1
> /home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_mlc.c: In function 'lpc32xx_dma_filter':
> /home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_mlc.c:582:48: error: dereferencing pointer to incomplete type
> /home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_mlc.c:582:67: warning: initialization from incompatible pointer type [enabled by default]
> /home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_mlc.c:582:67: warning: (near initialization for 'ch') [enabled by default]
> /home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_mlc.c:582:145: error: invalid use of undefined type 'struct pl08x_dma_chan'
> /home/arnd/linux-arm/drivers/mtd/nand/lpc32xx_mlc.c:585:8: error: dereferencing pointer to incomplete type
> make[4]: *** [drivers/mtd/nand/lpc32xx_mlc.o] Error 1
> 
> As far as I can tell, each branch touching these files is ok individually,
> but they don't go together.
> 
> There is also this bit of suspicious code in lpc32xx_slc:
> 
> static bool lpc32xx_dma_filter(struct dma_chan *chan, void *param)
> {
>         struct pl08x_dma_chan *ch =
>                 container_of(chan, struct pl08x_dma_chan, chan);
> 
>         /* In LPC32xx's PL080 DMA wiring, the SLC NAND DMA signal is #1 */
>         if (ch->cd->min_signal == 1)
>                 return true;
>         return false;
> }
> 
> I dont't think that actually valid -- you cannot make any assumption about
> the structure outside of dma_chan here, only about the parameter you pass
> in.

Thanks for the note! Looks like the interface consolidated to replace
ch->cd->min_signal with sth. like cd->min_signal directly.

Accessing the signal id/number is/was quite convenient because as you
can see in the 3 above cases that now get compile errors with the pl08x
changes, the LPC32xx chip hard-wires those numbers, and the respective
code is LPC32xx specific anyway.

So can we make an exception here to compare static dma channel numbers?
Or is there any other interface to access the static dma channel numbers
that I'm currently not aware of?

Depending on what we agree upon, I can then provide fixes to the
lpc32xx-next branch.

Thanks in advance,

Roland
