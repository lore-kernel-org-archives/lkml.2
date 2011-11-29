Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab1K2Nfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 08:35:44 -0500
Received: from mga07.intel.com ([143.182.124.22]:19855 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755338Ab1K2Nfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 08:35:41 -0500
MIME-Version: 1.0
In-Reply-To: <1322567933.2182.16.camel@mars>
References: <1322567933.2182.16.camel@mars>
Date: Tue, 29 Nov 2011 15:35:38 +0200
Message-ID: <CAE1zotJy6eYMOuNqQx7eiFPnnJ5raDRSDqTaLcV8iie5MJ0wbg@mail.gmail.com>
Subject: Re: [BUG] i2c-designware: (allyesconfig) error: multiple definition
From: "Purdila, Octavian" <octavian.purdila@intel.com>
To: Christoph Fritz <chf.fritz@googlemail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Dirk Brandewie <dirk.brandewie@gmail.com>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 1:58 PM, Christoph Fritz
<chf.fritz@googlemail.com> wrote:
> Hi,
>
>  I just hit this bug with allyesconfig:
>
> make[2]: `include/generated/mach-types.h' is up to date.
>  CALL    /xxx/linux-2.6/scripts/checksyscalls.sh
>  CHK     include/generated/compile.h
>  CHK     kernel/config_data.h
>  CHECK   /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c
>  CC      drivers/i2c/busses/i2c-designware-core.o
>  CHECK   /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-pcidrv.c
>  CC      drivers/i2c/busses/i2c-designware-pcidrv.o
>  CHECK   /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-platdrv.c
>  CC      drivers/i2c/busses/i2c-designware-platdrv.o
>  LD      drivers/i2c/busses/i2c-designware-pci.o
>  LD      drivers/i2c/busses/i2c-designware-platform.o
>  LD      drivers/i2c/busses/built-in.o
> drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_clear_int':
> /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:694: multiple definition of `i2c_dw_clear_int'
> drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:694: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_init':
> /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:247: multiple definition of `i2c_dw_init'
> drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:247: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `dw_readl':
> /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:169: multiple definition of `dw_readl'
> drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:169: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_isr':
> /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:627: multiple definition of `i2c_dw_isr'
> drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:627: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_xfer':
> /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:498: multiple definition of `i2c_dw_xfer'
> drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:498: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_is_enabled':
> /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:679: multiple definition of `i2c_dw_is_enabled'
> drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:679: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `dw_writel':
> /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:177: multiple definition of `dw_writel'
> drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:177: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_xfer_msg':
> /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:362: multiple definition of `i2c_dw_xfer_msg'
> drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:362: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_enable':
> /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:674: multiple definition of `i2c_dw_enable'
> drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:674: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_read_comp_param':
> /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:704: multiple definition of `i2c_dw_read_comp_param'
> drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:704: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_disable':
> /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:683: multiple definition of `i2c_dw_disable'
> drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:683: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_func':
> /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:562: multiple definition of `i2c_dw_func'
> drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:562: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_disable_int':
> /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:699: multiple definition of `i2c_dw_disable_int'
> drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:699: first defined here make[4]: *** [drivers/i2c/busses/built-in.o] Error 1
> make[3]: *** [drivers/i2c/busses] Error 2
> make[2]: *** [drivers/i2c] Error 2
> make[1]: *** [drivers] Error 2
> make: *** [sub-make] Error 2
>
>

Hi Christoph,

What tree are you using? I tried the following on Linus's tree (head
at 8748dfae379573cdbea4e765b55e608a1764f918):

make allyesconfig
make -j4 drivers/i2c/busses/

and did not run into any errors.

Thanks,
Tavi
