Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab2LSUyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:54:46 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14875 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab2LSUyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:54:41 -0500
X-IronPort-AV: E=Sophos;i="4.84,318,1355126400"; 
   d="scan'208";a="15371563"
Message-ID: <50D2298F.2030308@codeaurora.org>
Date: Wed, 19 Dec 2012 12:54:39 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Josh Cartwright <josh.cartwright@ni.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 4/4] clk: zynq: Use of_init_clk_data()
References: <1355778135-32458-1-git-send-email-sboyd@codeaurora.org> <1355778135-32458-5-git-send-email-sboyd@codeaurora.org> <b11edd0b-27ff-48b3-9f2a-1e7ab293cc34@CO9EHSMHS019.ehs.local> <50D223DD.8070208@codeaurora.org>
In-Reply-To: <50D223DD.8070208@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/12 12:30, Stephen Boyd wrote:
> On 12/19/12 11:22, Soren Brinkmann wrote:
>> Hi Stephen,
>>
>> I guess Josh is the better person to talk about this, since he created the
>> patches regarding common clock for mainline, but I tried running your series
>> and ran into this:
>>
>> Unable to handle kernel NULL pointer dereference at virtual address 0000002a
>> pgd = c0004000
>> [0000002a] *pgd=00000000
>> Internal error: Oops: 5 [#1] PREEMPT ARM
>> Modules linked in:
>> CPU: 0    Tainted: G        W     (3.7.0-rc3-00025-gc11ffdd-dirty #246)
>> PC is at __clk_prepare+0x20/0x80
>> LR is at clk_prepare+0x2c/0x44
>> pc : [<c031659c>]    lr : [<c0316628>]    psr: a0000153
>> sp : ee02fdd0  ip : ee02fde8  fp : ee02fde4
>> r10: 00000000  r9 : 00000000  r8 : c0587884
>> r7 : 00000000  r6 : c05aab98  r5 : fffffffe  r4 : fffffffe
>> r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : fffffffe
>> Flags: NzCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
>> Control: 18c5387d  Table: 00004059  DAC: 00000015
>> Process swapper (pid: 1, stack limit = 0xee02e230)
>> Stack: (0xee02fdd0 to 0xee030000)
>> fdc0:                                     c05b6a18 fffffffe ee02fdfc ee02fde8
>> fde0: c0316628 c0316588 ee085400 fffffffe ee02fe24 ee02fe00 c03c1358 c0316608
>> fe00: c03c1328 ee085410 c05aab98 c05aab98 00000000 c0587884 ee02fe34 ee02fe28
>> fe20: c026a5c0 c03c1334 ee02fe5c ee02fe38 c0268f50 c026a5a8 c026a7b8 c0313ac0
>> fe40: ee085410 ee085410 ee085444 c05aab98 ee02fe7c ee02fe60 c02691c0 c0268e18
>> fe60: c0269150 c05aab98 c0269150 00000000 ee02fea4 ee02fe80 c0267320 c026915c
>> fe80: ee00948c ee096df0 c021e02c c05aab98 ed9a0bc0 c05ab3a8 ee02feb4 ee02fea8
>> fea0: c0268a28 c02672d0 ee02fee4 ee02feb8 c0268408 c0268a0c c04b56d1 00000000
>> fec0: ee02fee4 c05aab98 c0565e60 00000000 0000006f c0587884 ee02ff14 ee02fee8
>> fee0: c0269990 c0268340 00000000 00000000 c0565e60 00000000 0000006f c0587884
>> ff00: 00000000 00000000 ee02ff24 ee02ff18 c026a9cc c02698f0 ee02ff3c ee02ff28
>> ff20: c0565e84 c026a984 ee02e000 ee02ff40 ee02ff74 ee02ff40 c00086f8 c0565e6c
>> ff40: c04f72e4 00000000 ee02ff74 00000006 00000006 c0571dac c0571d8c 0000006f
>> ff60: c0587884 00000000 ee02ffac ee02ff78 c03bf9c4 c0008664 00000006 00000006
>> ff80: c05511a8 00000000 ee02ffac 00000000 c03bf8cc 00000000 00000000 00000000
>> ffa0: 00000000 ee02ffb0 c000ea98 c03bf8d8 00000000 00000000 00000000 00000000
>> ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>> ffe0: 00000000 00000000 00000000 00000000 00000013 00000000 0158ec21 0eced1ff
>> [<c031659c>] (__clk_prepare+0x20/0x80) from [<c0316628>] (clk_prepare+0x2c/0x44)
>> [<c0316628>] (clk_prepare+0x2c/0x44) from [<c03c1358>] (xuartps_probe+0x30/0x1ac
>> )
>> [<c03c1358>] (xuartps_probe+0x30/0x1ac) from [<c026a5c0>] (platform_drv_probe+0x
>> 24/0x28)
>> [<c026a5c0>] (platform_drv_probe+0x24/0x28) from [<c0268f50>] (driver_probe_devi
>> ce+0x144/0x344)
>> [<c0268f50>] (driver_probe_device+0x144/0x344) from [<c02691c0>] (__driver_attac
>> h+0x70/0x94)
>> [<c02691c0>] (__driver_attach+0x70/0x94) from [<c0267320>] (bus_for_each_dev+0x5
>> c/0x8c)
>> [<c0267320>] (bus_for_each_dev+0x5c/0x8c) from [<c0268a28>] (driver_attach+0x28/
>> 0x30)
>> [<c0268a28>] (driver_attach+0x28/0x30) from [<c0268408>] (bus_add_driver+0xd4/0x
>> 254)
>> [<c0268408>] (bus_add_driver+0xd4/0x254) from [<c0269990>] (driver_register+0xac
>> /0x14c)
>> [<c0269990>] (driver_register+0xac/0x14c) from [<c026a9cc>] (platform_driver_reg
>> ister+0x54/0x68)
>> [<c026a9cc>] (platform_driver_register+0x54/0x68) from [<c0565e84>] (xuartps_ini
>> t+0x24/0x44)
>> [<c0565e84>] (xuartps_init+0x24/0x44) from [<c00086f8>] (do_one_initcall+0xa0/0x
>> 170)
>> [<c00086f8>] (do_one_initcall+0xa0/0x170) from [<c03bf9c4>] (kernel_init+0xf8/0x
>> 2ac)
>> [<c03bf9c4>] (kernel_init+0xf8/0x2ac) from [<c000ea98>] (ret_from_fork+0x14/0x20
>> )
>> Code: e8bd4000 e2504000 01a05004 0a000015 (e594302c) 
>> ---[ end trace 1b75b31a2719ed1d ]---
>> Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
>>
>>
>> A probably unique thing I do is, I set the status of uart0 to disabled. This way
>> I can reuse my rootfs which does not run getty on ttyPS1. And this worked fine
>> before.
>>
> Thanks for testing. It seems that clocks are failing to register. Please
> try this patch.
>

Also, why are clock-names an optional property in devicetree? It would
be nice to not have two different APIs for consumers (i.e. drivers) to
get clocks from devicetree bindings. I suggest we do this for your uart
driver so that you can use the regular clock APIs and not the of_* ones.
We should get rid of of_clk_get().

---->8-----

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 5914b56..eef5f0c 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -45,6 +45,7 @@
                        reg = <0xE0000000 0x1000>;
                        interrupts = <0 27 4>;
                        clocks = <&uart_clk 0>;
+                       clock-names = "ref";
                };

                uart1: uart@e0001000 {
@@ -52,6 +53,7 @@
                        reg = <0xE0001000 0x1000>;
                        interrupts = <0 50 4>;
                        clocks = <&uart_clk 1>;
+                       clock-names = "ref";
                };

                slcr: slcr@f8000000 {
diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 2be22a2..6868e6b 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -947,10 +947,10 @@ static int xuartps_probe(struct platform_device *pdev)
        struct resource *res, *res2;
        struct clk *clk;

-       clk = of_clk_get(pdev->dev.of_node, 0);
-       if (!clk) {
-               dev_err(&pdev->dev, "no clock specified\n");
-               return -ENODEV;
+       clk = devm_clk_get(&pdev->dev, "ref");
+       if (IS_ERR(clk)) {
+               dev_err(&pdev->dev, "failed to get clock\n");
+               return PTR_ERR(clk);
        }

        rc = clk_prepare_enable(clk);

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

