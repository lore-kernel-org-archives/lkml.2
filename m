Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964808Ab0GSSZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:25:21 -0400
Received: from panicking.kicks-ass.org ([95.141.32.57]:45530 "EHLO
	panicking.kicks-ass.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760868Ab0GSSZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:25:18 -0400
Message-ID: <4C448F8B.7060908@panicking.kicks-ass.org>
Date: Mon, 19 Jul 2010 19:46:51 +0200
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Janakiram Sistla <janakiram.sistla@gmail.com>
CC: Sergey Lapin <slapinid@gmail.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>, sameo@linux.intel.com,
        List Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org, Mikko Ylinen <mikko.k.ylinen@nokia.com>
Subject: Re: [PATCH] mfd: twl4030: Driver for twl4030 madc module
References: <1259146071-2372-1-git-send-email-amit.kucheria@verdurent.com>	 <48239d391001200412i7736354dg4e07076a63d7b966@mail.gmail.com> <4fb5db51001250134s19c309eax947617ae2fc26d5f@mail.gmail.com>
In-Reply-To: <4fb5db51001250134s19c309eax947617ae2fc26d5f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Janakiram Sistla wrote:
>>>  drivers/mfd/Kconfig              |   21 ++
>>>  drivers/mfd/Makefile             |    3 +-
>>>  drivers/mfd/twl4030-madc.c       |  548 ++++++++++++++++++++++++++++++++++++++
>>>  include/linux/i2c/twl4030-madc.h |  126 +++++++++
>>>  4 files changed, 697 insertions(+), 1 deletions(-)
>>>  create mode 100644 drivers/mfd/twl4030-madc.c
>>>  create mode 100644 include/linux/i2c/twl4030-madc.h
>>>
>> We have just tried to adopt this driver to our custom OMAP3 board, but
>> were unable to get any interrupts.
>> Any ideas on what is missing? We've checked whole TRM and found
>> nothing wrong yet :(
>>
> we tried the same driver for Omap zoom platform ,I too dont see any
> interrupts from this driver.I also observe that duing bluetooth file
> transfer i see the below crash from twl4030-madc driver.
> 
> Once i disable the madc driver in kernel configuration my Bluetooth
> works fine,while Bluetooth has nothing to do with i2c or madc driver.A
> similar crash is also observed during GFX operation
> 
> Regards,
> Ram.
> 
> here is the log:
> i2c_omap i2c_omap.1: controller timed out waiting for start condition to finish
> twl: i2c_write failed to transfer all messages
> Unable to handle kernel NULL pointer dereference at virtual address 00000044
> pgd = c0004000
> [00000044] *pgd=00000000
> Internal error: Oops: 17 [#1] PREEMPT
> last sysfs file: /sys/devices/platform/kim/firmware/kim/loading
> Modules linked in: bt_drv st_drv
> CPU: 0    Not tainted  (2.6.32-14922-g86eec44 #1)
> PC is at dev_driver_string+0x0/0x38
> LR is at twl4030_madc_write+0x2c/0x4c
> pc : [<c01f2bc0>]    lr : [<c01fede0>]    psr: a0000013
> sp : cf02bf08  ip : 0000738f  fp : 00000000
> r10: cf002cc8  r9 : c038a839  r8 : 00000000
> r7 : cf02bf3c  r6 : c04edff8  r5 : 00000007  r4 : cf227a00
> r3 : 00000007  r2 : 02070002  r1 : 00000007  r0 : 00000000
> Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> Control: 10c5387d  Table: 8d23c019  DAC: 00000017
> Process events/0 (pid: 5, stack limit = 0xcf02a2e8)
> Stack: (0xcf02bf08 to 0xcf02c000)
> bf00:                   00000006 00000002 c04edff8 c01fef6c cf179680 cf179680
> bf20: cf02a000 cf002cc0 c028a5a8 00000000 cf002cc8 c028a5dc 00000000 00000200
> bf40: cf020001 00000000 cf020d40 00000017 cf0213c0 c007f1dc 00000000 cd277e40
> bf60: cf02bf94 c036e58c cd0bac9c cf020ed4 60000013 cf002cc0 cf002cbc cf02a000
> bf80: cf002cc0 c01dcc00 cf002cc0 00000000 cf179684 c0076ff4 cf02bfcc 00000000
> bfa0: cf020d40 c007a660 cf02bfa8 cf02bfa8 cf023f60 cf02bfd4 cf023f60 cf002cc0
> bfc0: c0076e8c 00000000 00000000 c007a334 00000000 00000000 cf02bfd8 cf02bfd8
> bfe0: 00000000 00000000 00000000 00000000 00000000 c0035f80 00000000 00000000
> [<c01f2bc0>] (dev_driver_string+0x0/0x38) from [<c01fede0>] (twl4030_madc_write+
> 0x2c/0x4c)
> [<c01fede0>] (twl4030_madc_write+0x2c/0x4c) from [<c01fef6c>] (twl4030_madc_conv
> ersion+0x74/0x288)
> [<c01fef6c>] (twl4030_madc_conversion+0x74/0x288) from [<c028a5dc>] (twl4030_bk_
> bci_battery_work+0x34/0x60)
> [<c028a5dc>] (twl4030_bk_bci_battery_work+0x34/0x60) from [<c0076ff4>] (worker_t
> hread+0x168/0x214)
> [<c0076ff4>] (worker_thread+0x168/0x214) from [<c007a334>] (kthread+0x7c/0x84)
> [<c007a334>] (kthread+0x7c/0x84) from [<c0035f80>] (kernel_thread_exit+0x0/0x8)
> Code: c04edd3c c04eddcc c042bef5 c040d709 (e5903044)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 2d2aa87..e12ac1a 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -478,6 +478,7 @@ static int __init twl4030_madc_probe(struct platform_device 
 
        madc->imr = (pdata->irq_line == 1) ? TWL4030_MADC_IMR1 : TWL4030_MADC_IM
        madc->isr = (pdata->irq_line == 1) ? TWL4030_MADC_ISR1 : TWL4030_MADC_IS
+       madc->dev = &pdev->dev;
 
        ret = misc_register(&twl4030_madc_device);
        if (ret) {

This is the reason of the crash

Michael Trimarchi


> 

