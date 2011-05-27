Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab1E0T66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:58:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24974 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab1E0T6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:58:55 -0400
Date: Fri, 27 May 2011 12:58:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: linux-next: build failure after merge of the voltage tree
Message-Id: <20110527125830.447abb79.randy.dunlap@oracle.com>
In-Reply-To: <201105271759.p4RHxa2X008919@hera.kernel.org>
References: <201105271759.p4RHxa2X008919@hera.kernel.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4DE00277.010A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011 17:59:36 GMT Linux Kernel Mailing List wrote:

> Gitweb:     http://git.kernel.org/linus/c01e36dde4632e0a7474fddf0716f1e54f01f13e
> Commit:     c01e36dde4632e0a7474fddf0716f1e54f01f13e
> Parent:     327e15af15248563c896c16adad6fc6e04bb5a4d
> Author:     Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
> AuthorDate: Wed May 11 01:43:02 2011 -0500
> Committer:  Liam Girdwood <lrg@slimlogic.co.uk>
> CommitDate: Fri May 27 10:49:09 2011 +0100
> 
>     linux-next: build failure after merge of the voltage tree
>     
>     On May 10, 2011, at 9:27 PM, Stephen Rothwell wrote:
>     
>     > Hi Jorge,
>     >
>     > On Tue, 10 May 2011 12:30:36 -0500 Jorge Eduardo Candelaria <jedu@slimlogic.co.uk> wrote:
>     >>
>     >> On May 10, 2011, at 3:38 AM, Liam Girdwood wrote:
>     >>
>     >>> On Tue, 2011-05-10 at 12:44 +1000, Stephen Rothwell wrote:
>     >>>> Hi Liam,
>     >>>>
>     >>>> After merging the voltage tree, today's linux-next build (x86_64
>     >>>> allmodconfig) failed like this:
>     >>>>
>     >>>> ERROR: "tps65910_gpio_init" [drivers/mfd/tps65910.ko] undefined!
>     >>>> ERROR: "tps65910_irq_init" [drivers/mfd/tps65910.ko] undefined!
>     >>>> ERROR: "irq_modify_status" [drivers/mfd/tps65910-irq.ko] undefined!
>     >>>> ERROR: "irq_set_chip_and_handler_name" [drivers/mfd/tps65910-irq.ko] undefined!
>     >>>> ERROR: "handle_edge_irq" [drivers/mfd/tps65910-irq.ko] undefined!
>     >>>>
>     >>>> I have used the voltage tree from next-20110509 for today.
>     >>>
>     >>> Jorge, could you send a fix for this today.
>     >>
>     >> The following patch should solve this:
>     >>
>     >> From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
>     >> MFD: Fix TPS65910 build
>     >>
>     >> Support for tps65910 as a module is not available. The driver can
>     >> only be compiled as built-in. OTOH, the regulator driver can still
>     >> be built as module without breaking the compilation.
>     >>
>     >> Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
>     >
>     > Today (even with the above patch included) I got these errors from the
>     > x86_64 allmodconfig build:
>     >
>     > tps65910.c:(.text+0xf4140): undefined reference to `i2c_master_send'
>     > drivers/built-in.o: In function `tps65910_i2c_read':
>     > tps65910.c:(.text+0xf41d2): undefined reference to `i2c_transfer'
>     > drivers/built-in.o: In function `tps65910_i2c_init':
>     > tps65910.c:(.init.text+0xcb83): undefined reference to `i2c_register_driver'
>     > drivers/built-in.o: In function `tps65910_i2c_exit':
>     > tps65910.c:(.exit.text+0x6e0): undefined reference to `i2c_del_driver'
>     >
>     > I have used the voltage tree from next-20110509 again today.
>     
>     Following patch should fix the dependency problems. Please review:
>     
>     From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
>     [PATCH] MFD: TPS65910: Fix I2C dependency
>     
>     TPS65910 driver can only be compiled built-in, so the I2C driver
>     should be as well.
>     
>     Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
>     Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
> ---
>  drivers/mfd/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 05f882f..4990a49 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -721,7 +721,7 @@ config MFD_PM8XXX_IRQ
>  
>  config MFD_TPS65910
>  	bool "TPS65910 Power Management chip"
> -	depends on I2C && GPIOLIB
> +	depends on I2C=y && GPIOLIB
>  	select MFD_CORE
>  	help
>  	  if you say yes here you get support for the TPS65910 series of
> --


Hi,

Current mainline build fails when GPIO is not enabled:

warning: (MFD_TPS65910) selects GPIO_TPS65910 which has unmet direct dependencies (GPIOLIB && MFD_TPS65910)

which causes:

In file included from drivers/gpio/tps65910-gpio.c:21:
include/linux/mfd/tps65910.h:774: error: field 'gpio' has incomplete type
drivers/gpio/tps65910-gpio.c: In function 'tps65910_gpio_get':
drivers/gpio/tps65910-gpio.c:25: warning: type defaults to 'int' in declaration of '__mptr'
drivers/gpio/tps65910-gpio.c:25: warning: initialization from incompatible pointer type
drivers/gpio/tps65910-gpio.c: In function 'tps65910_gpio_set':
drivers/gpio/tps65910-gpio.c:39: warning: type defaults to 'int' in declaration of '__mptr'
drivers/gpio/tps65910-gpio.c:39: warning: initialization from incompatible pointer type
drivers/gpio/tps65910-gpio.c: In function 'tps65910_gpio_output':
drivers/gpio/tps65910-gpio.c:52: warning: type defaults to 'int' in declaration of '__mptr'
drivers/gpio/tps65910-gpio.c:52: warning: initialization from incompatible pointer type
drivers/gpio/tps65910-gpio.c: In function 'tps65910_gpio_input':
drivers/gpio/tps65910-gpio.c:63: warning: type defaults to 'int' in declaration of '__mptr'
drivers/gpio/tps65910-gpio.c:63: warning: initialization from incompatible pointer type
drivers/gpio/tps65910-gpio.c: In function 'tps65910_gpio_init':
drivers/gpio/tps65910-gpio.c:96: error: implicit declaration of function 'gpiochip_add'
make[3]: *** [drivers/gpio/tps65910-gpio.o] Error 1
make[2]: *** [drivers/gpio] Error 2
make[1]: *** [drivers] Error 2


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
