Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0JRLBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 07:01:34 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:38741 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754275Ab0JRLBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 07:01:32 -0400
Message-ID: <001201cb6eb3$d14914a0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Wolfram Sang <w.sang@pengutronix.de>; Alan Cox" 
	<alan@lxorguk.ukuu.org.uk>,
        "Linus Walleij" <linus.walleij@stericsson.com>, <joe@perches.com>,
        <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        "srinidhi kasagar" <srinidhi.kasagar@stericsson.com>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Crane Cai" <crane.cai@amd.com>,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        "Jean Delvare \(PC drivers, core\)" <khali@linux-fr.org>,
        "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        <andrew.chih.howe.khor@intel.com>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
References: <4C91D676.8020406@dsn.okisemi.com>
Subject: Re: [MeeGo-Dev][PATCH v2] Topcliff: Update PCH_I2C driver to 2.6.35
Date: Mon, 18 Oct 2010 20:01:22 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi I2C maintainer,

I posted the i2c patch 1 month ago.
But I haven't received any response from you.
Could you review this patch ?

Thanks, Ohtake(OKISemi)
----- Original Message ----- 
From: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
To: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>; "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>;
"Crane Cai" <crane.cai@amd.com>; "Samuel Ortiz" <sameo@linux.intel.com>; "Linus Walleij" <linus.walleij@stericsson.com>;
"Ralf Baechle" <ralf@linux-mips.org>; "srinidhi kasagar" <srinidhi.kasagar@stericsson.com>; <linux-i2c@vger.kernel.org>;
<linux-kernel@vger.kernel.org>; <joe@perches.com>; "Linus Walleij" <linus.walleij@stericsson.com>; "Wolfram Sang
<w.sang@pengutronix.de>; Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: <yong.y.wang@intel.com>; <qi.wang@intel.com>; <andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; "Tomoya
MORINAGA" <morinaga526@dsn.okisemi.com>; "Arnd Bergmann" <arnd@arndb.de>; "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Sent: Thursday, September 16, 2010 5:33 PM
Subject: [MeeGo-Dev][PATCH v2] Topcliff: Update PCH_I2C driver to 2.6.35


> I2C driver of Topcliff PCH
>
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus.
> Topcliff PCH has I2C I/F. Using this I/F, it is able to access system
> devices connected to I2C.
>
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> Reviewed-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  drivers/i2c/busses/Kconfig   |    8 +
>  drivers/i2c/busses/Makefile  |    1 +
>  drivers/i2c/busses/i2c-pch.c |  908 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 917 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/i2c/busses/i2c-pch.c
>
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index bceafbf..b7b132d 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -613,6 +613,14 @@ config I2C_XILINX
>     This driver can also be built as a module.  If so, the module
>     will be called xilinx_i2c.
>
> +config PCH_I2C
> + tristate "PCH I2C of Intel Topcliff"
> + depends on PCI
> + help
> +   This driver is for PCH(Platform controller Hub) I2C of Topcliff which
> +   is an IOH(Input/Output Hub) for x86 embedded processor.
> +   This driver can access PCH I2C bus device.
> +
>  comment "External I2C/SMBus adapter drivers"
>
>  config I2C_PARPORT
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index 936880b..aa04135 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -59,6 +59,7 @@ obj-$(CONFIG_I2C_STU300) += i2c-stu300.o
>  obj-$(CONFIG_I2C_VERSATILE) += i2c-versatile.o
>  obj-$(CONFIG_I2C_OCTEON) += i2c-octeon.o
>  obj-$(CONFIG_I2C_XILINX) += i2c-xiic.o
> +obj-$(CONFIG_PCH_I2C) += i2c-pch.o
>
>  # External I2C/SMBus adapter drivers
>  obj-$(CONFIG_I2C_PARPORT) += i2c-parport.o
> diff --git a/drivers/i2c/busses/i2c-pch.c b/drivers/i2c/busses/i2c-pch.c
> new file mode 100644
> index 0000000..37491d7
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-pch.c
> @@ -0,0 +1,908 @@
> +/*
> + * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/delay.h>
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/i2c.h>
> +#include <linux/fs.h>
> +#include <linux/io.h>
> +#include <linux/types.h>
> +#include <linux/interrupt.h>
> +#include <linux/jiffies.h>
> +#include <linux/pci.h>
> +#include <linux/mutex.h>
> +#include <linux/ktime.h>
> +
> +#define PCH_EVENT_SET 0 /* I2C Interrupt Event Set Status */
> +#define PCH_EVENT_NONE 1 /* I2C Interrupt Event Clear Status */
> +#define PCH_MAX_CLK 100000 /* Maximum Clock speed in MHz */
> +#define PCH_BUFFER_MODE_ENABLE 0x0002 /* flag for Buffer mode enable */
> +#define PCH_EEPROM_SW_RST_MODE_ENABLE 0x0008 /* EEPROM SW RST enable flag */
> +
> +#define PCH_I2CSADR 0x00 /* I2C slave address register */
> +#define PCH_I2CCTL 0x04 /* I2C control register */
> +#define PCH_I2CSR 0x08 /* I2C status register */
> +#define PCH_I2CDR 0x0C /* I2C data register */
> +#define PCH_I2CMON 0x10 /* I2C bus monitor register */
> +#define PCH_I2CBC 0x14 /* I2C bus transfer rate setup counter */
> +#define PCH_I2CMOD 0x18 /* I2C mode register */
> +#define PCH_I2CBUFSLV 0x1C /* I2C buffer mode slave address register */
> +#define PCH_I2CBUFSUB 0x20 /* I2C buffer mode subaddress register */
> +#define PCH_I2CBUFFOR 0x24 /* I2C buffer mode format register */
> +#define PCH_I2CBUFCTL 0x28 /* I2C buffer mode control register */
> +#define PCH_I2CBUFMSK 0x2C /* I2C buffer mode interrupt mask register */
> +#define PCH_I2CBUFSTA 0x30 /* I2C buffer mode status register */
> +#define PCH_I2CBUFLEV 0x34 /* I2C buffer mode level register */
> +#define PCH_I2CESRFOR 0x38 /* EEPROM software reset mode format register */
> +#define PCH_I2CESRCTL 0x3C /* EEPROM software reset mode ctrl register */
> +#define PCH_I2CESRMSK 0x40 /* EEPROM software reset mode */
> +#define PCH_I2CESRSTA 0x44 /* EEPROM software reset mode status register */
> +#define PCH_I2CTMR 0x48 /* I2C timer register */
> +#define PCH_I2CSRST 0xFC /* I2C reset register */
> +#define PCH_I2CNF 0xF8 /* I2C noise filter register */
> +
> +#define BUS_IDLE_TIMEOUT 20
> +#define PCH_I2CCTL_I2CMEN 0x0080
> +#define TEN_BIT_ADDR_DEFAULT 0xF000
> +#define TEN_BIT_ADDR_MASK 0xF0
> +#define PCH_START 0x0020
> +#define PCH_ESR_START 0x0001
> +#define PCH_BUFF_START 0x1
> +#define PCH_REPSTART 0x0004
> +#define PCH_ACK 0x0008
> +#define PCH_GETACK 0x0001
> +#define CLR_REG 0x0
> +#define I2C_RD 0x1
> +#define I2CMCF_BIT 0x0080
> +#define I2CMIF_BIT 0x0002
> +#define I2CMAL_BIT 0x0010
> +#define I2CBMFI_BIT 0x0001
> +#define I2CBMAL_BIT 0x0002
> +#define I2CBMNA_BIT 0x0004
> +#define I2CBMTO_BIT 0x0008
> +#define I2CBMIS_BIT 0x0010
> +#define I2CESRFI_BIT 0X0001
> +#define I2CESRTO_BIT 0x0002
> +#define I2CESRFIIE_BIT 0x1
> +#define I2CESRTOIE_BIT 0x2
> +#define I2CBMDZ_BIT 0x0040
> +#define I2CBMAG_BIT 0x0020
> +#define I2CMBB_BIT 0x0020
> +#define BUFFER_MODE_MASK (I2CBMFI_BIT | I2CBMAL_BIT | I2CBMNA_BIT | \
> + I2CBMTO_BIT | I2CBMIS_BIT)
> +#define I2C_ADDR_MSK 0xFF
> +#define I2C_MSB_2B_MSK 0x300
> +#define FAST_MODE_CLK 400
> +#define FAST_MODE_EN 0x0001
> +#define SUB_ADDR_LEN_MAX 4
> +#define BUF_LEN_MAX 32
> +#define PCH_BUFFER_MODE 0x1
> +#define EEPROM_SW_RST_MODE 0x0002
> +#define NORMAL_INTR_ENBL 0x0300
> +#define EEPROM_RST_INTR_ENBL (I2CESRFIIE_BIT | I2CESRTOIE_BIT)
> +#define EEPROM_RST_INTR_DISBL 0x0
> +#define BUFFER_MODE_INTR_ENBL 0x001F
> +#define BUFFER_MODE_INTR_DISBL 0x0
> +#define NORMAL_MODE 0x0
> +#define BUFFER_MODE 0x1
> +#define EEPROM_SR_MODE 0x2
> +#define I2C_TX_MODE 0x0010
> +#define PCH_BUF_TX 0xFFF7
> +#define PCH_BUF_RD 0x0008
> +#define I2C_ERROR_MASK (I2CESRTO_EVENT | I2CBMIS_EVENT | I2CBMTO_EVENT | \
> + I2CBMNA_EVENT | I2CBMAL_EVENT | I2CMAL_EVENT)
> +#define I2CMAL_EVENT 0x0001
> +#define I2CMCF_EVENT 0x0002
> +#define I2CBMFI_EVENT 0x0004
> +#define I2CBMAL_EVENT 0x0008
> +#define I2CBMNA_EVENT 0x0010
> +#define I2CBMTO_EVENT 0x0020
> +#define I2CBMIS_EVENT 0x0040
> +#define I2CESRFI_EVENT 0x0080
> +#define I2CESRTO_EVENT 0x0100
> +#define PCI_DEVICE_ID_PCH_I2C 0x8817
> +
> +#define pch_dbg(adap, fmt, arg...)  \
> + dev_dbg(adap->pch_adapter.dev.parent, "%s :" fmt, __func__, ##arg)
> +
> +#define pch_err(adap, fmt, arg...)  \
> + dev_err(adap->pch_adapter.dev.parent, "%s :" fmt, __func__, ##arg)
> +
> +#define pch_pci_err(pdev, fmt, arg...)  \
> + dev_err(&pdev->dev, "%s :" fmt, __func__, ##arg)
> +
> +#define pch_pci_dbg(pdev, fmt, arg...)  \
> + dev_dbg(&pdev->dev, "%s :" fmt, __func__, ##arg)
> +
> +/**
> + * struct i2c_algo_pch_data - for I2C driver functionalities
> + * @p_adapter_info: stores the reference to adapter_info structure
> + * @pch_adapter: stores the reference to i2c_adapter structure
> + * @pch_base_address: specifies the remapped base address
> + * @pch_buff_mode_en: specifies if buffer mode is enabled
> + * @pch_event_flag: specifies occurrence of interrupt events
> + * @pch_xfer_in_progress: specifies whether the transfer is completed
> + */
> +struct i2c_algo_pch_data {
> + struct adapter_info *p_adapter_info;
> + struct i2c_adapter pch_adapter;
> + void __iomem *pch_base_address;
> + int pch_buff_mode_en;
> + u32 pch_event_flag;
> + bool pch_xfer_in_progress;
> +};
> +
> +/**
> + * struct adapter_info - This structure holds the adapter information for the
> + PCH i2c controller
> + * @pch_data: stores a list of i2c_algo_pch_data
> + * @pch_suspended: specifies whether the system is suspended or not
> + * perhaps with more lines and words.
> + *
> + * pch_data has as many elements as maximum I2C channels
> + */
> +struct adapter_info {
> + struct i2c_algo_pch_data pch_data;
> + bool pch_suspended;
> +};
> +
> +
> +static int pch_i2c_speed = 100; /* I2C bus speed in Kbps */
> +static int pch_clk = 50000; /* specifies I2C clock speed in KHz */
> +static wait_queue_head_t pch_event;
> +static DEFINE_MUTEX(pch_mutex);
> +
> +static struct pci_device_id __devinitdata pch_pcidev_id[] = {
> + {PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_PCH_I2C)},
> + {0,}
> +};
> +
> +static irqreturn_t pch_handler(int irq, void *pData);
> +
> +static inline void pch_setbit(void __iomem *addr, u32 offset, u32 bitmask)
> +{
> + u32 val;
> + val = ioread32(addr + offset);
> + val |= bitmask;
> + iowrite32(val, addr + offset);
> +}
> +
> +static inline void pch_clrbit(void __iomem *addr, u32 offset, u32 bitmask)
> +{
> + u32 val;
> + val = ioread32(addr + offset);
> + val &= (~bitmask);
> + iowrite32(val, addr + offset);
> +}
> +
> +/**
> + * pch_init() - hardware initialization of I2C module
> + * @adap: Pointer to struct i2c_algo_pch_data.
> + */
> +static void pch_init(struct i2c_algo_pch_data *adap)
> +{
> + void __iomem *p = adap->pch_base_address;
> + u32 pch_i2cbc;
> + u32 pch_i2ctmr;
> + u32 reg_value;
> +
> + /* reset I2C controller */
> + iowrite32(0x01, p + PCH_I2CSRST);
> + iowrite32(0x0, p + PCH_I2CSRST);
> + /* Initialize I2C registers */
> + iowrite32(CLR_REG, p + PCH_I2CCTL);
> + iowrite32(CLR_REG, p + PCH_I2CMOD);
> + iowrite32(CLR_REG, p + PCH_I2CBUFFOR);
> + iowrite32(CLR_REG, p + PCH_I2CBUFSLV);
> + iowrite32(CLR_REG, p + PCH_I2CBUFSUB);
> + iowrite32(CLR_REG, p + PCH_I2CBUFMSK);
> + iowrite32(CLR_REG, p + PCH_I2CESRFOR);
> + iowrite32(CLR_REG, p + PCH_I2CESRMSK);
> + iowrite32(0x21, p + PCH_I2CNF);
> +
> + reg_value = PCH_I2CCTL_I2CMEN;
> + pch_setbit(adap->pch_base_address, PCH_I2CCTL,
> +   PCH_I2CCTL_I2CMEN);
> +
> + if (pch_i2c_speed != 400)
> + pch_i2c_speed = 100;
> +
> + if (pch_i2c_speed == FAST_MODE_CLK) {
> + reg_value |= FAST_MODE_EN;
> + pch_dbg(adap, "Fast mode enabled\n");
> + }
> +
> + if (pch_clk <= 0 || pch_clk > PCH_MAX_CLK)
> + pch_clk = 62500;
> +
> + pch_i2cbc = (pch_clk + (pch_i2c_speed * 4)) / pch_i2c_speed * 8;
> + /* Set transfer speed in I2CBC */
> + iowrite32(pch_i2cbc, p + PCH_I2CBC);
> +
> + pch_i2ctmr = (pch_clk) / 8;
> + iowrite32(pch_i2ctmr, p + PCH_I2CTMR);
> +
> + reg_value |= NORMAL_INTR_ENBL; /* Enable interrupts in normal mode */
> + iowrite32(reg_value, p + PCH_I2CCTL);
> +
> + pch_dbg(adap,
> + "I2CCTL=%x pch_i2cbc=%x pch_i2ctmr=%x Enable interrupts\n",
> + ioread32(p + PCH_I2CCTL), pch_i2cbc, pch_i2ctmr);
> +
> + init_waitqueue_head(&pch_event);
> +}
> +
> +static inline int ktime_lt(const ktime_t cmp1, const ktime_t cmp2)
> +{
> + return cmp1.tv64 < cmp2.tv64;
> +}
> +
> +/**
> + * pch_wait_for_bus_idle() - check the status of bus.
> + * @adap: Pointer to struct i2c_algo_pch_data.
> + * @timeout: waiting time counter (us).
> + */
> +static s32 pch_wait_for_bus_idle(struct i2c_algo_pch_data *adap,
> + s32 timeout)
> +{
> + void __iomem *p = adap->pch_base_address;
> +
> + /* MAX timeout value is timeout*1000*1000nsec */
> + ktime_t ns_val = ktime_add_ns(ktime_get(), timeout*1000*1000);
> + do {
> + if ((ioread32(p + PCH_I2CSR) & I2CMBB_BIT) == 0)
> + break;
> + msleep(1);
> + } while (ktime_lt(ktime_get(), ns_val));
> +
> + pch_dbg(adap, "I2CSR = %x\n", ioread32(p + PCH_I2CSR));
> +
> + if (timeout == 0) {
> + pch_err(adap, "%s: Timeout Error.return%d\n", __func__, -ETIME);
> + return -ETIME;
> + }
> +
> + return 0;
> +}
> +
> +/**
> + * pch_start() - Generate I2C start condition in normal mode.
> + * @adap: Pointer to struct i2c_algo_pch_data.
> + *
> + * Generate I2C start condition in normal mode by setting I2CCTL.I2CMSTA to 1.
> + */
> +static void pch_start(struct i2c_algo_pch_data *adap)
> +{
> + void __iomem *p = adap->pch_base_address;
> + pch_dbg(adap, "I2CCTL = %x\n", ioread32(p + PCH_I2CCTL));
> + pch_setbit(adap->pch_base_address, PCH_I2CCTL, PCH_START);
> +}
> +
> +/**
> + * pch_wait_for_xfer_complete() - initiates a wait for the tx complete event
> + * @adap: Pointer to struct i2c_algo_pch_data.
> + */
> +static s32 pch_wait_for_xfer_complete(struct i2c_algo_pch_data *adap)
> +{
> + s32 ret;
> + ret = wait_event_timeout(pch_event,
> + (adap->pch_event_flag != 0), msecs_to_jiffies(50));
> + if (ret < 0) {
> + pch_err(adap, "timeout: %x\n", adap->pch_event_flag);
> + return ret;
> + }
> +
> + if (ret == 0) {
> + pch_err(adap, "timeout: %x\n", adap->pch_event_flag);
> + return -ETIMEDOUT;
> + }
> +
> + if (adap->pch_event_flag & I2C_ERROR_MASK) {
> + pch_err(adap, "error bits set: %x\n", adap->pch_event_flag);
> + return -EIO;
> + }
> +
> + adap->pch_event_flag = 0;
> + ret = 0;
> +
> + return ret;
> +}
> +
> +/**
> + * pch_getack() - to confirm ACK/NACK
> + * @adap: Pointer to struct i2c_algo_pch_data.
> + */
> +static s32 pch_getack(struct i2c_algo_pch_data *adap)
> +{
> + u32 reg_val;
> + void __iomem *p = adap->pch_base_address;
> + reg_val = ioread32(p + PCH_I2CSR) & PCH_GETACK;
> +
> + if (reg_val != 0) {
> + pch_err(adap, "return%d\n", -EPROTO);
> + return -EPROTO;
> + }
> +
> + return 0;
> +}
> +
> +/**
> + * pch_stop() - generate stop condition in normal mode.
> + * @adap: Pointer to struct i2c_algo_pch_data.
> + */
> +static void pch_stop(struct i2c_algo_pch_data *adap)
> +{
> + void __iomem *p = adap->pch_base_address;
> + pch_dbg(adap, "I2CCTL = %x\n", ioread32(p + PCH_I2CCTL));
> + /* clear the start bit */
> + pch_clrbit(adap->pch_base_address, PCH_I2CCTL, PCH_START);
> +}
> +
> +/**
> + * pch_repstart() - generate repeated start condition in normal mode
> + * @adap: Pointer to struct i2c_algo_pch_data.
> + */
> +static void pch_repstart(struct i2c_algo_pch_data *adap)
> +{
> + void __iomem *p = adap->pch_base_address;
> + pch_dbg(adap, "I2CCTL = %x\n", ioread32(p + PCH_I2CCTL));
> + pch_setbit(adap->pch_base_address, PCH_I2CCTL, PCH_REPSTART);
> +}
> +
> +/**
> + * pch_writebytes() - write data to I2C bus in normal mode
> + * @i2c_adap: Pointer to the struct i2c_adapter.
> + * @last: specifies whether last message or not.
> + * In the case of compound mode it will be 1 for last message,
> + * otherwise 0.
> + * @first: specifies whether first message or not.
> + * 1 for first message otherwise 0.
> + */
> +static s32 pch_writebytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
> +   u32 last, u32 first)
> +{
> + struct i2c_algo_pch_data *adap = i2c_adap->algo_data;
> + u8 *buf;
> + u32 length;
> + u32 addr;
> + u32 addr_2_msb;
> + u32 addr_8_lsb;
> + s32 wrcount;
> + void __iomem *p = adap->pch_base_address;
> +
> + length = msgs->len;
> + buf = msgs->buf;
> + addr = msgs->addr;
> +
> + /* enable master tx */
> + pch_setbit(adap->pch_base_address, PCH_I2CCTL, I2C_TX_MODE);
> +
> + pch_dbg(adap, "I2CCTL = %x msgs->len = %d\n", ioread32(p + PCH_I2CCTL),
> + length);
> +
> + if (first) {
> + if (pch_wait_for_bus_idle(adap, BUS_IDLE_TIMEOUT) == -ETIME)
> + return -ETIME;
> + }
> +
> + if (msgs->flags & I2C_M_TEN) {
> + addr_2_msb = ((addr & I2C_MSB_2B_MSK) >> 7);
> + iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK, p + PCH_I2CDR);
> + if (first)
> + pch_start(adap);
> + if (pch_wait_for_xfer_complete(adap) == 0 &&
> +     pch_getack(adap) == 0) {
> + addr_8_lsb = (addr & I2C_ADDR_MSK);
> + iowrite32(addr_8_lsb, p + PCH_I2CDR);
> + } else {
> + pch_stop(adap);
> + return -ETIME;
> + }
> + } else {
> + /* set 7 bit slave address and R/W bit as 0 */
> + iowrite32(addr << 1, p + PCH_I2CDR);
> + if (first)
> + pch_start(adap);
> + }
> +
> + if ((pch_wait_for_xfer_complete(adap) == 0) &&
> +     (pch_getack(adap) == 0)) {
> + for (wrcount = 0; wrcount < length; ++wrcount) {
> + /* write buffer value to I2C data register */
> + iowrite32(buf[wrcount], p + PCH_I2CDR);
> + pch_dbg(adap, "writing %x to Data register\n",
> + buf[wrcount]);
> +
> + if (pch_wait_for_xfer_complete(adap) != 0)
> + return -ETIME;
> +
> + if (pch_getack(adap))
> + return -EIO;
> + }
> +
> + /* check if this is the last message */
> + if (last)
> + pch_stop(adap);
> + else
> + pch_repstart(adap);
> + } else {
> + pch_stop(adap);
> + return -EIO;
> + }
> +
> + pch_dbg(adap, "return=%d\n", wrcount);
> +
> + return wrcount;
> +}
> +
> +/**
> + * pch_sendack() - send ACK
> + * @adap: Pointer to struct i2c_algo_pch_data.
> + */
> +static void pch_sendack(struct i2c_algo_pch_data *adap)
> +{
> + void __iomem *p = adap->pch_base_address;
> + pch_dbg(adap, "I2CCTL = %x\n", ioread32(p + PCH_I2CCTL));
> + pch_clrbit(adap->pch_base_address, PCH_I2CCTL, PCH_ACK);
> +}
> +
> +/**
> + * pch_sendnack() - send NACK
> + * @adap: Pointer to struct i2c_algo_pch_data.
> + */
> +static void pch_sendnack(struct i2c_algo_pch_data *adap)
> +{
> + void __iomem *p = adap->pch_base_address;
> + pch_dbg(adap, "I2CCTL = %x\n", ioread32(p + PCH_I2CCTL));
> + pch_setbit(adap->pch_base_address, PCH_I2CCTL, PCH_ACK);
> +}
> +
> +/**
> + * pch_readbytes() - read data  from I2C bus in normal mode.
> + * @i2c_adap: Pointer to the struct i2c_adapter.
> + * @msgs: Pointer to i2c_msg structure.
> + * @last: specifies whether last message or not.
> + * @first: specifies whether first message or not.
> + */
> +s32 pch_readbytes(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs,
> +   u32 last, u32 first)
> +{
> + struct i2c_algo_pch_data *adap = i2c_adap->algo_data;
> +
> + u8 *buf;
> + u32 count;
> + u32 length;
> + u32 addr;
> + u32 addr_2_msb;
> + void __iomem *p = adap->pch_base_address;
> +
> + length = msgs->len;
> + buf = msgs->buf;
> + addr = msgs->addr;
> +
> + /* enable master reception */
> + pch_clrbit(adap->pch_base_address, PCH_I2CCTL, I2C_TX_MODE);
> +
> + if (first) {
> + if (pch_wait_for_bus_idle(adap, BUS_IDLE_TIMEOUT) == -ETIME)
> + return -ETIME;
> + }
> +
> + if (msgs->flags & I2C_M_TEN) {
> + addr_2_msb = (((addr & I2C_MSB_2B_MSK) >> 7) | (I2C_RD));
> + iowrite32(addr_2_msb | TEN_BIT_ADDR_MASK, p + PCH_I2CDR);
> +
> + } else {
> + /* 7 address bits + R/W bit */
> + addr = (((addr) << 1) | (I2C_RD));
> + iowrite32(addr, p + PCH_I2CDR);
> + }
> +
> + /* check if it is the first message */
> + if (first)
> + pch_start(adap);
> +
> + if ((pch_wait_for_xfer_complete(adap) == 0) &&
> +     (pch_getack(adap) == 0)) {
> + pch_dbg(adap, "return %d\n", 0);
> +
> + if (length == 0) {
> + pch_stop(adap);
> + ioread32(p + PCH_I2CDR); /* Dummy read needs */
> +
> + count = length;
> + } else {
> + int read_index;
> + int loop;
> + pch_sendack(adap);
> +
> + /* Dummy read */
> + for (loop = 1, read_index = 0; loop < length; loop++) {
> + buf[read_index] = ioread32(p + PCH_I2CDR);
> +
> + if (loop != 1)
> + read_index++;
> +
> + if (pch_wait_for_xfer_complete(adap) != 0) {
> + pch_stop(adap);
> + return -ETIME;
> + }
> + } /* end for */
> +
> + pch_sendnack(adap);
> +
> + buf[read_index] = ioread32(p + PCH_I2CDR);
> +
> + if (length != 1)
> + read_index++;
> +
> + if (pch_wait_for_xfer_complete(adap) == 0) {
> + if (last)
> + pch_stop(adap);
> + else
> + pch_repstart(adap);
> +
> + buf[read_index++] = ioread32(p + PCH_I2CDR);
> + count = read_index;
> + } else {
> + count = -ETIME;
> + }
> +
> + }
> + } else {
> + count = -ETIME;
> + pch_stop(adap);
> + }
> +
> + return count;
> +}
> +
> +/**
> + * pch_cb_ch0() - Interrupt handler Call back function
> + * @adap: Pointer to struct i2c_algo_pch_data.
> + */
> +static void pch_cb_ch0(struct i2c_algo_pch_data *adap)
> +{
> + u32 sts;
> + void __iomem *p = adap->pch_base_address;
> +
> + sts = ioread32(p + PCH_I2CSR);
> + sts &= (I2CMAL_BIT | I2CMCF_BIT | I2CMIF_BIT);
> + if (I2CMAL_BIT & sts)
> + adap->pch_event_flag |= I2CMAL_EVENT;
> +
> + if (I2CMCF_BIT & sts)
> + adap->pch_event_flag |= I2CMCF_EVENT;
> +
> + /* clear the applicable bits */
> + pch_clrbit(adap->pch_base_address, PCH_I2CSR, sts);
> +
> + pch_dbg(adap, "PCH_I2CSR = %x\n", ioread32(p + PCH_I2CSR));
> +
> + wake_up(&pch_event);
> +}
> +
> +/**
> + * pch_handler() - interrupt handler for the PCH I2C controller
> + * @irq: irq number.
> + * @pData: cookie passed back to the handler function.
> + */
> +static irqreturn_t pch_handler(int irq, void *pData)
> +{
> + s32 reg_val;
> +
> + struct i2c_algo_pch_data *adap_data = (struct i2c_algo_pch_data *)pData;
> + void __iomem *p = adap_data->pch_base_address;
> + u32 mode = ioread32(p + PCH_I2CMOD) & (BUFFER_MODE | EEPROM_SR_MODE);
> +
> + if (mode != NORMAL_MODE) {
> + pch_err(adap_data, "I2C mode is not supported\n");
> + return IRQ_NONE;
> + }
> +
> + reg_val = ioread32(p + PCH_I2CSR);
> + if (reg_val & (I2CMAL_BIT | I2CMCF_BIT | I2CMIF_BIT))
> + pch_cb_ch0(adap_data);
> + else
> + return IRQ_NONE;
> +
> + return IRQ_HANDLED;
> +}
> +
> +/**
> + * pch_xfer() - Reading adnd writing data through I2C bus
> + * @i2c_adap: Pointer to the struct i2c_adapter.
> + * @msgs: Pointer to i2c_msg structure.
> + * @num: number of messages.
> + */
> +static s32 pch_xfer(struct i2c_adapter *i2c_adap,
> +     struct i2c_msg *msgs, s32 num)
> +{
> + struct i2c_msg *pmsg;
> + u32 i;
> + u32 status;
> + u32 msglen;
> + u32 subaddrlen;
> + s32 ret;
> +
> + struct i2c_algo_pch_data *adap = i2c_adap->algo_data;
> +
> + ret = mutex_lock_interruptible(&pch_mutex);
> + if (ret)
> + return -ERESTARTSYS;
> +
> + if (adap->p_adapter_info->pch_suspended) {
> + mutex_unlock(&pch_mutex);
> + return -EBUSY;
> + }
> +
> + pch_dbg(adap, "adap->p_adapter_info->pch_suspended is %d\n",
> + adap->p_adapter_info->pch_suspended);
> + /* transfer not completed */
> + adap->pch_xfer_in_progress = true;
> +
> + pmsg = &msgs[0];
> + pmsg->flags |= adap->pch_buff_mode_en;
> + status = pmsg->flags;
> + pch_dbg(adap,
> + "After invoking I2C_MODE_SEL :flag= 0x%x\n", status);
> + /* calculate sub address length and message length */
> + /* these are applicable only for buffer mode */
> + subaddrlen = pmsg->buf[0];
> + /* calculate actual message length excluding
> + * the sub address fields */
> + msglen = (pmsg->len) - (subaddrlen + 1);
> + i = 0;
> + if (status & (I2C_M_RD)) {
> + pch_dbg(adap, "invoking pch_readbytes\n");
> + ret = pch_readbytes(i2c_adap, pmsg, (i + 1 == num),
> +    (i == 0));
> + } else {
> + pch_dbg(adap, "invoking pch_writebytes\n");
> + ret = pch_writebytes(i2c_adap, pmsg, (i + 1 == num),
> +     (i == 0));
> + }
> +
> + adap->pch_xfer_in_progress = false; /* transfer completed */
> +
> + mutex_unlock(&pch_mutex);
> +
> + return ret;
> +}
> +
> +/**
> + * pch_func() - return the functionality of the I2C driver
> + * @adap: Pointer to struct i2c_algo_pch_data.
> + */
> +static u32 pch_func(struct i2c_adapter *adap)
> +{
> + return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | I2C_FUNC_10BIT_ADDR;
> +}
> +
> +static struct i2c_algorithm pch_algorithm = {
> + .master_xfer = pch_xfer,
> + .functionality = pch_func
> +};
> +
> +/**
> + * pch_disbl_int() - Disable PCH I2C interrupts
> + * @adap: Pointer to struct i2c_algo_pch_data.
> + */
> +static void pch_disbl_int(struct i2c_algo_pch_data *adap)
> +{
> + void __iomem *p = adap->pch_base_address;
> +
> + pch_clrbit(adap->pch_base_address, PCH_I2CCTL, NORMAL_INTR_ENBL);
> +
> + iowrite32(EEPROM_RST_INTR_DISBL, p + PCH_I2CESRMSK);
> +
> + iowrite32(BUFFER_MODE_INTR_DISBL, p + PCH_I2CBUFMSK);
> +}
> +
> +static int __devinit pch_probe(struct pci_dev *pdev,
> +        const struct pci_device_id *id)
> +{
> + void __iomem *base_addr;
> + s32 ret;
> + struct adapter_info *adap_info;
> +
> + pch_pci_dbg(pdev, "Entered.\n");
> +
> + adap_info = kzalloc((sizeof(struct adapter_info)), GFP_KERNEL);
> + if (adap_info == NULL) {
> + pch_pci_err(pdev, "Memory allocation FAILED\n");
> + return -ENOMEM;
> + }
> +
> + ret = pci_enable_device(pdev);
> + if (ret) {
> + pch_pci_err(pdev, "pci_enable_device FAILED\n");
> + goto err_pci_enable;
> + }
> +
> + ret = pci_request_regions(pdev, KBUILD_MODNAME);
> + if (ret) {
> + pch_pci_err(pdev, "pci_request_regions FAILED\n");
> + goto err_pci_req;
> + }
> +
> + base_addr = pci_iomap(pdev, 1, 0);
> +
> + if (base_addr == NULL) {
> + pch_pci_err(pdev, "pci_iomap FAILED\n");
> + ret = -ENOMEM;
> + goto err_pci_iomap;
> + }
> +
> + adap_info->pch_suspended = false;
> +
> + adap_info->pch_data.p_adapter_info = adap_info;
> +
> + adap_info->pch_data.pch_adapter.owner = THIS_MODULE;
> + adap_info->pch_data.pch_adapter.class = I2C_CLASS_HWMON;
> + strcpy(adap_info->pch_data.pch_adapter.name, KBUILD_MODNAME);
> + adap_info->pch_data.pch_adapter.algo = &pch_algorithm;
> + adap_info->pch_data.pch_adapter.algo_data =
> + &adap_info->pch_data;
> +
> + /* (i * 0x80) + base_addr; */
> + adap_info->pch_data.pch_base_address = base_addr;
> +
> + adap_info->pch_data.pch_adapter.dev.parent = &pdev->dev;
> +
> + ret = i2c_add_adapter(&(adap_info->pch_data.pch_adapter));
> +
> + if (ret) {
> + pch_pci_err(pdev, "i2c_add_adapter FAILED\n");
> + goto err_i2c_add_adapter;
> + }
> +
> + pch_init(&adap_info->pch_data);
> + ret = request_irq(pdev->irq, pch_handler, IRQF_SHARED,
> +   KBUILD_MODNAME, &adap_info->pch_data);
> + if (ret) {
> + pch_pci_err(pdev, "request_irq FAILED\n");
> + goto err_request_irq;
> + }
> +
> + pci_set_drvdata(pdev, adap_info);
> + pch_pci_dbg(pdev, "returns %d.\n", ret);
> + return 0;
> +
> +err_request_irq:
> + i2c_del_adapter(&(adap_info->pch_data.pch_adapter));
> +err_i2c_add_adapter:
> + pci_iounmap(pdev, base_addr);
> +err_pci_iomap:
> + pci_release_regions(pdev);
> +err_pci_req:
> + pci_disable_device(pdev);
> +err_pci_enable:
> + kfree(adap_info);
> + return ret;
> +}
> +
> +static void __devexit pch_remove(struct pci_dev *pdev)
> +{
> + struct adapter_info *adap_info = pci_get_drvdata(pdev);
> +
> + pch_disbl_int(&adap_info->pch_data);
> + free_irq(pdev->irq, &adap_info->pch_data);
> + i2c_del_adapter(&(adap_info->pch_data.pch_adapter));
> +
> + if (adap_info->pch_data.pch_base_address) {
> + pci_iounmap(pdev, adap_info->pch_data.pch_base_address);
> + adap_info->pch_data.pch_base_address = 0;
> + }
> +
> + pci_set_drvdata(pdev, NULL);
> +
> + pci_release_regions(pdev);
> +
> + pci_disable_device(pdev);
> + kfree(adap_info);
> +}
> +
> +#ifdef CONFIG_PM
> +static int pch_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> + int ret;
> + struct adapter_info *adap_info = pci_get_drvdata(pdev);
> + void __iomem *p = adap_info->pch_data.pch_base_address;
> +
> + adap_info->pch_suspended = true;
> +
> + while ((adap_info->pch_data.pch_xfer_in_progress)) {
> + /* Wait until all channel transfers are completed */
> + msleep(1);
> + }
> + /* Disable the i2c interrupts */
> + pch_disbl_int(&adap_info->pch_data);
> +
> + pch_pci_dbg(pdev, "I2CSR = %x I2CBUFSTA = %x I2CESRSTA = %x "
> + "invoked function pch_disbl_int successfully\n",
> + ioread32(p + PCH_I2CSR), ioread32(p + PCH_I2CBUFSTA),
> + ioread32(p + PCH_I2CESRSTA));
> +
> + ret = pci_save_state(pdev);
> +
> + if (ret) {
> + pch_pci_err(pdev, "pci_save_state\n");
> + return ret;
> + }
> +
> + pci_enable_wake(pdev, PCI_D3hot, 0);
> + pci_disable_device(pdev);
> + pci_set_power_state(pdev, pci_choose_state(pdev, state));
> +
> + return 0;
> +}
> +
> +static int pch_resume(struct pci_dev *pdev)
> +{
> + struct adapter_info *adap_info = pci_get_drvdata(pdev);
> +
> + pci_set_power_state(pdev, PCI_D0);
> + pci_restore_state(pdev);
> +
> + if (pci_enable_device(pdev) < 0) {
> + pch_pci_err(pdev, "pci_enable_device FAILED in pch_resume\n");
> + return -EIO;
> + }
> +
> + pci_enable_wake(pdev, PCI_D3hot, 0);
> +
> + pch_init(&adap_info->pch_data);
> +
> + adap_info->pch_suspended = false;
> +
> + return 0;
> +}
> +#else
> +#define pch_suspend NULL
> +#define pch_resume NULL
> +#endif
> +
> +static struct pci_driver pch_pcidriver = {
> + .name = KBUILD_MODNAME,
> + .id_table = pch_pcidev_id,
> + .probe = pch_probe,
> + .remove = __devexit_p(pch_remove),
> + .suspend = pch_suspend,
> + .resume = pch_resume
> +};
> +
> +static int __init pch_pci_init(void)
> +{
> + return pci_register_driver(&pch_pcidriver);
> +}
> +module_init(pch_pci_init);
> +
> +static void __exit pch_pci_exit(void)
> +{
> + pci_unregister_driver(&pch_pcidriver);
> +}
> +module_exit(pch_pci_exit);
> +
> +MODULE_DESCRIPTION("PCH I2C PCI Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("OKI Semiconductor <masa-korg@dsn.okisemi.com>");
> +module_param(pch_i2c_speed, int, (S_IRUSR | S_IWUSR));
> +module_param(pch_clk, int, (S_IRUSR | S_IWUSR));
> -- 
> 1.6.0.6
>


