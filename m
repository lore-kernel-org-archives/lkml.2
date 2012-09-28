Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab2I1JlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:41:07 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:55984 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757659Ab2I1JlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:41:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120927141837.GA26268@n2100.arm.linux.org.uk>
References: <1348754648-8315-1-git-send-email-kishon@ti.com>
	<1348754648-8315-2-git-send-email-kishon@ti.com>
	<20120927141837.GA26268@n2100.arm.linux.org.uk>
Date: Fri, 28 Sep 2012 15:10:59 +0530
Message-ID: <CAAe_U6J_AGArYEj1-sUmEeVkMmbkhp=WZxOuN-y-L6E5SDJM=Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] usb: phy: add a new driver for usb3 phy
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, Moiz Sonasath <m-sonasath@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Sep 27, 2012 at 7:48 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Sep 27, 2012 at 07:34:07PM +0530, Kishon Vijay Abraham I wrote:
>> +static int omap5_usb_phy_power(struct omap_usb *phy, bool on)
>> +{
>> +     u32 val;
>> +     unsigned long rate;
>> +     struct clk *sys_clk;
>> +
>> +     sys_clk = clk_get(NULL, "sys_clkin");
>> +     if (IS_ERR(sys_clk)) {
>> +             pr_err("%s: unable to get sys_clkin\n", __func__);
>> +             return -EINVAL;
>> +     }
>> +
>> +     rate = clk_get_rate(sys_clk);
>> +     rate = rate/1000000;
>> +     clk_put(sys_clk);
>
> Actually, you're supposed to hold on to the struct clk all the time your
> driver is making use of that - you're not supposed to drop it.
>
> That has several advantages: if clk_get() fails, then you're failing
> earlier on (when the driver is being probed) and when some event occurs.

Ok. Will post a patch fixing it.

Thanks
Kishon
