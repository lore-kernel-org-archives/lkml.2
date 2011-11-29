Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab1K2L7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:59:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44532 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1K2L66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:58:58 -0500
Subject: [BUG] i2c-designware: (allyesconfig) error: multiple definition
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Ben Dooks <ben-linux@fluff.org>, Dirk Brandewie <dirk.brandewie@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 29 Nov 2011 12:58:53 +0100
Message-ID: <1322567933.2182.16.camel@mars>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 I just hit this bug with allyesconfig:

make[2]: `include/generated/mach-types.h' is up to date.
  CALL    /xxx/linux-2.6/scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CHK     kernel/config_data.h
  CHECK   /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c
  CC      drivers/i2c/busses/i2c-designware-core.o
  CHECK   /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-pcidrv.c
  CC      drivers/i2c/busses/i2c-designware-pcidrv.o
  CHECK   /xxx/linux-2.6/drivers/i2c/busses/i2c-designware-platdrv.c
  CC      drivers/i2c/busses/i2c-designware-platdrv.o
  LD      drivers/i2c/busses/i2c-designware-pci.o
  LD      drivers/i2c/busses/i2c-designware-platform.o
  LD      drivers/i2c/busses/built-in.o
drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_clear_int':
/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:694: multiple definition of `i2c_dw_clear_int'
drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:694: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_init':
/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:247: multiple definition of `i2c_dw_init'
drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:247: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `dw_readl':
/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:169: multiple definition of `dw_readl'
drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:169: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_isr':
/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:627: multiple definition of `i2c_dw_isr'
drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:627: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_xfer':
/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:498: multiple definition of `i2c_dw_xfer'
drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:498: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_is_enabled':
/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:679: multiple definition of `i2c_dw_is_enabled'
drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:679: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `dw_writel':
/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:177: multiple definition of `dw_writel'
drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:177: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_xfer_msg':
/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:362: multiple definition of `i2c_dw_xfer_msg'
drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:362: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_enable':
/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:674: multiple definition of `i2c_dw_enable'
drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:674: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_read_comp_param':
/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:704: multiple definition of `i2c_dw_read_comp_param'
drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:704: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_disable':
/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:683: multiple definition of `i2c_dw_disable'
drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:683: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_func':
/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:562: multiple definition of `i2c_dw_func'
drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:562: first defined here drivers/i2c/busses/i2c-designware-pci.o: In function `i2c_dw_disable_int':
/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:699: multiple definition of `i2c_dw_disable_int'
drivers/i2c/busses/i2c-designware-platform.o:/xxx/linux-2.6/drivers/i2c/busses/i2c-designware-core.c:699: first defined here make[4]: *** [drivers/i2c/busses/built-in.o] Error 1
make[3]: *** [drivers/i2c/busses] Error 2
make[2]: *** [drivers/i2c] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2


