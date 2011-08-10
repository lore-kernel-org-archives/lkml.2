Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1HJXwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:52:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab1HJXwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:52:35 -0400
Date: Wed, 10 Aug 2011 19:52:33 -0400
From: Jason Baron <jbaron@redhat.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org
Subject: Re: dynamic-debug not built into scx200_acb, scx200_i2c
Message-ID: <20110810235233.GA2588@redhat.com>
References: <CAJfuBxwq3xw3MZU01rwzg0NAnnxNoLrC2x0QXnj+2pD-6gkR4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfuBxwq3xw3MZU01rwzg0NAnnxNoLrC2x0QXnj+2pD-6gkR4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 03:06:49PM -0600, Jim Cromie wrote:
> scx200_acb has several pr_debugs, but theyre not available via dynamic-debug
> 
> Ive been unable to figure out why.
> Any ideas ?
> 

hmmm...I see drivers/i2c/busses/Makefile has:

ccflags-$(CONFIG_I2C_DEBUG_BUS) := -DDEBUG

Any chance CONFIG_I2C_DEBUG_BUS is set?

Thanks,

-Jason


> jimc@chumly:~/projects/lx/linux-2.6$ grep debug drivers/i2c/busses/scx200_*
> drivers/i2c/busses/scx200_acb.c:		pr_debug(NAME ": ACBCTL2 readback failed\n");
> drivers/i2c/busses/scx200_acb.c:		pr_debug(NAME ": disabled, but
> ACBCTL1=0x%02x\n",
> drivers/i2c/busses/scx200_acb.c:		pr_debug(NAME ": enabled, but NMINTE
> won't be set, "
> drivers/i2c/busses/scx200_acb.c:	pr_debug(NAME ": NatSemi SCx200
> ACCESS.bus Driver\n");
> drivers/i2c/busses/scx200_i2c.c:	pr_debug(NAME ": NatSemi SCx200 I2C Driver\n");
> drivers/i2c/busses/scx200_i2c.c:	pr_debug(NAME ": SCL=GPIO%02u,
> SDA=GPIO%02u\n", scl, sda);
> 
> 
> jimc@chumly:~/projects/lx/build-skc$ for k in `find drivers -name
> \*.ko`; do echo $k; readelf -S $k |grep __verbose; done
> drivers/i2c/busses/i2c-stub.ko
> drivers/i2c/busses/i2c-gpio.ko
> drivers/i2c/busses/scx200_i2c.ko
> drivers/i2c/busses/scx200_acb.ko
> drivers/i2c/muxes/gpio-i2cmux.ko
> drivers/i2c/i2c-mux.ko
> drivers/i2c/i2c-dev.ko
>   [15] __verbose         PROGBITS        00000000 0018c8 0000c0 00  WA  0   0  8
>   [16] .rel__verbose     REL             00000000 0024cc 000100 08     23  15  4
> drivers/i2c/i2c-core.ko
>   [24] __verbose         PROGBITS        00000000 003e58 000198 00  WA  0   0  8
>   [25] .rel__verbose     REL             00000000 0058c8 000220 08     32  24  4
> 
> 
> drivers/gpio/nsc_gpio.ko
>   [18] __verbose         PROGBITS        00000000 000850 000090 00  WA  0   0  8
>   [19] .rel__verbose     REL             00000000 0011bc 0000c0 08     26  18  4
> drivers/gpio/pcf857x.ko
>   [14] __verbose         PROGBITS        00000000 000e80 000048 00  WA  0   0  8
>   [15] .rel__verbose     REL             00000000 001710 000060 08     22  14  4
> drivers/gpio/pc8736x_gpio.ko
>   [17] __verbose         PROGBITS        00000000 001140 0000a8 00  WA  0   0  8
>   [18] .rel__verbose     REL             00000000 001da0 0000e0 08     25  17  4
> drivers/gpio/scx200_gpio.ko
> drivers/bluetooth/bfusb.ko
>   [14] __verbose         PROGBITS        00000000 002160 000198 00  WA  0   0  8
>   [15] .rel__verbose     REL             00000000 003108 000220 08     22  14  4
> drivers/bluetooth/btusb.ko
>   [16] __verbose         PROGBITS        00000000 002ca8 0001c8 00  WA  0   0  8
>   [17] .rel__verbose     REL             00000000 003e44 000260 08     24  16  4
> drivers/bluetooth/bcm203x.ko
>   [15] __verbose         PROGBITS        00000000 000f78 000078 00  WA  0   0  8
>   [16] .rel__verbose     REL             00000000 001a04 0000a0 08     23  15  4
> drivers/bluetooth/hci_uart.ko
>   [17] __verbose         PROGBITS        00000000 004068 000510 00  WA  0   0  8
>   [18] .rel__verbose     REL             00000000 0060a4 0006c0 08     25  17  4
> drivers/bluetooth/bpa10x.ko
>   [14] __verbose         PROGBITS        00000000 0014f0 000120 00  WA  0   0  8
>   [15] .rel__verbose     REL             00000000 002130 000180 08     22  14  4
> drivers/connector/cn.ko
> drivers/cpufreq/cpufreq_userspace.ko
>   [16] __verbose         PROGBITS        00000000 0008b8 000078 00  WA  0   0  8
>   [17] .rel__verbose     REL             00000000 001258 0000a0 08     24  16  4
> drivers/cpufreq/gx-suspmod.ko
>   [16] __verbose         PROGBITS        00000000 000f80 0000d8 00  WA  0   0  8
>   [17] .rel__verbose     REL             00000000 001ae8 000120 08     25  16  4
> drivers/cpufreq/cpufreq_ondemand.ko
> drivers/cpufreq/cpufreq_performance.ko
>   [14] __verbose         PROGBITS        00000000 000388 000018 00  WA  0   0  8
>   [15] .rel__verbose     REL             00000000 000a30 000020 08     22  14  4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
