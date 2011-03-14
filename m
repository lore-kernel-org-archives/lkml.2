Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab1CNTzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:55:53 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37764 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab1CNTzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:in-reply-to:mime-version:content-type:message-id
         :content-transfer-encoding:cc:from:subject:date:to:x-mailer;
        b=SO7FR+1JU4ffcG0ptTyTGBL3Y+Gauj6PoGQnRl93F6Zgm4TgfebUa75caea9coaTrQ
         3zuGP1Gp6sRyAx2Tbv0hQN3y3V1iVLoBld9+w5B6qQqWolaMKwBMMo7n7aKBAxk4JbVj
         55Gr3pmH8flfN6M2tiI+s1aqrtk9vhjHQOUGQ=
References: <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com> <1299512600-29047-4-git-send-email-haojian.zhuang@marvell.com> <1299512600-29047-5-git-send-email-haojian.zhuang@marvell.com> <1299512600-29047-6-git-send-email-haojian.zhuang@marvell.com> <1299512600-29047-7-git-send-email-haojian.zhuang@marvell.com> <1299512600-29047-8-git-send-email-haojian.zhuang@marvell.com> <1299512600-29047-9-git-send-email-haojian.zhuang@marvell.com> <1299512600-29047-10-git-send-email-haojian.zhuang@marvell.com> <1299512600-29047-11-git-send-email-haojian.zhuang@marvell.com> <1299512600-29047-12-git-send-email-haojian.zhuang@marvell.com> <20110314112838.GK31153@sortiz-mobl> <25B60CDC2F704E4E9D88FFD52780CB4C05CEAFFB95@SC-VEXCH1.marvell.com>
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C05CEAFFB95@SC-VEXCH1.marvell.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=utf-8
Message-Id: <21E8077F-C20C-47AE-885C-73C69681E1B4@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "dtor@mail.ru" <dtor@mail.ru>, "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Subject: Re: [PATCH] mfd: pxa-w1: MFD driver for PXA 1wire control + DS1WM chip
Date: Mon, 14 Mar 2011 15:55:47 -0400
To: Haojian Zhuang <hzhuang1@marvell.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 14, 2011, at 8:34, Haojian Zhuang wrote:

> 
> 
>> -----Original Message-----
>> From: Samuel Ortiz [mailto:sameo@linux.intel.com]
>> Sent: 2011年3月14日 7:29 PM
>> To: Haojian Zhuang
>> Cc: johnpol@2ka.mipt.ru; a.zummo@towertech.it; lrg@slimlogic.co.uk;
>> broonie@opensource.wolfsonmicro.com; dmitry.torokhov@gmail.com;
>> dtor@mail.ru; rpurdie@rpsys.net; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] mfd: pxa-w1: MFD driver for PXA 1wire control +
>> DS1WM chip
>> 
>> Hi Haojian,
>> 
>> On Mon, Mar 07, 2011 at 11:43:20PM +0800, Haojian Zhuang wrote:
>>> This driver provides registers and IRQ of PXA3xx chips to the ds1wm
>> driver.
>> Why is this an MFD driver ?
>> 
>> Cheers,
>> Samuel.
>> 
>> --
>> Intel Open Source Technology Centre
>> http://oss.intel.com/
> 
> Hi Samuel,
> 
> Because there's already a DS1WM driver in drivers/w1/masters/ds1wm.c. In PXA silicons, W1 controler is compatible with this driver. So we implement it as MFD driver, like htc-pasic3.c.
> 
> Best Regards
> Haojian--
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
I successfully made this driver work with a ds1wm core inside a virtex5 interfaced through PCI express. The base address of the ds1wm is at a certain offset in the BAR0 of the virtex5. We used a shared interrupt for the ds1wm and the other function our virtex5 does. This is on a x86 platform. I posted a couple of patches last week which added multi-slave search support to the existing ds1wm driver.

look for [w1 PATCHES 3/3] Complete the 1-wire (w1) ds1wm driver search algo

I declare the presence of the ds1wm from my pci_probe of the FPGA device. 

static int ds1wm_enable(struct platform_device *pdev)
{
   struct MYSTRUCT* pMyDevStruct = dev_get_drvdata(pdev->dev.parent);
   u32* address = pHudDev->bar0KernAddr + REG_OFFSET_RESET;
... custom stuff you need to do to make the ds1wm power up
   return 0;
}

static int ds1wm_disable(struct platform_device *pdev)
{
   ... undo what you did in enable.
   return 0;
}
#define REG_1_WIRE_BASE                0xXX
static struct ds1wm_driver_data ds1wm_pdata = {
      .active_high = 1,
      .clock_rate = 125000000 // PCIe transaction clock
};


static struct resource ds1wm_resources[] = {
      [0] = {
            .start  = REG_1_WIRE_BASE,
            .end    = REG_1_WIRE_BASE + (5*sizeof(int)), // that's 5 registers each on a 32 bit address, we omit the 6th one, i.e. control reg
            .flags  = IORESOURCE_MEM,
      },
      [1] = {
            .start  = 0, // cell define as offset from parent base resource, i.e. 0 means same
            .end    = 0,
            .flags  = IORESOURCE_IRQ,
      },
};

static struct mfd_cell ds1wm_cell = {
      .name          = "ds1wm",
	.enable        = ds1wm_enable,
	.disable       = ds1wm_disable,
      .driver_data   = &ds1wm_pdata,
      .num_resources = 2,
      .resources     = ds1wm_resources,
};

[...] in my pci_probe() [...]
		ds1wm_cell.platform_data = &ds1wm_cell;
		ds1wm_cell.data_size = sizeof(ds1wm_cell);
		PDEBUG( "adding ds1wm core in mfd subsys, irq: %d\n", pPciDev->irq);
		if(0 > mfd_add_devices(&pPciDev->dev, 0, &ds1wm_cell, 1, &pPciDev->resource[0], pPciDev->irq))
		{
			printk(KERN_CRIT PRINTK_ID "%s failed to add ds1wm \n", pHudDev->hwDeviceName);
			goto cancel_and_exit;
		}
		PDEBUG( "ds1wm core added to mfd subsys\n");

GOOD LUCK!

FYI, here's the intro I had for these patches:
===================

The first patch add generic functionnality to w1_io for Resume Command [A5h]
lots of slaves support. I found it useful for multi-commands/reset workflows
with the same slave on a multi-slave bus.

This DS2408 w1 slave driver is not complete for all the 
features of the chip, but its sufficient if you use it as
a simple IO expander. Enjoy!

The ds1wm had Kconfig dependencies towards ARM && HAVE_CLK. I took them
out since I was using the ds1wm on an x86_64 platform (ds1wm in a FPGA through
pcie) and found them irrelevant.

The clock freq/divisors at the top of ds1wm.c did not have the MSB set to 1.
This bit is CLK_EN which turns the whole prescaler and dividers on. The driver
never mentionned this bit either, so I just included this bit right in the table
entries. I also took the liberty to add a couple of entries to the table. The
spec doesn't explicitely mentions these possibilities but the description and 
examination of the core shows the prescalers & dividers can be used for more
than the table explicitely shows. The table I enlarged still doesn't cover all
possibilities, but it's a good start.

I also made a few tweaks to a couple of the read and write algorithms which 
made sense while I had my head very deep in the ds1wm documentation. We stressed
it a lot with 10+ slaves on the bus, many ds2408, ds2431 and ds2433 at the same
time doing extensive interaction. It proved quite stable in our production 
environment.