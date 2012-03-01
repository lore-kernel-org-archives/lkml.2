Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966000Ab2CAJT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:19:56 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43519 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965582Ab2CAJTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:19:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of paul.liu@linaro.org designates 10.68.73.225 as permitted sender) smtp.mail=paul.liu@linaro.org
Message-ID: <4F4F3F33.4000608@linaro.org>
Date: Thu, 01 Mar 2012 17:19:47 +0800
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH v4 1/2] mfd: Add anatop mfd driver
References: <1324980994-18462-1-git-send-email-paul.liu@linaro.org> <1328734286-30091-1-git-send-email-paul.liu@linaro.org> <20120221111705.GV5387@sortiz-mobl>
In-Reply-To: <20120221111705.GV5387@sortiz-mobl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012年02月21日 19:17), Samuel Ortiz wrote:
> Hi Paul,
> 
> I didn't get patch #2, so I don't get to see how the read/write functions ar
> eused for example.
> 

Hi Samuel,

Sorry for late reply.
I've sent out v5 today.

>> +	ioreg = ioremap(ofaddr, ofsize);
>> +	if (!ioreg)
>> +		return -EINVAL;
>> +	drvdata = devm_kzalloc(dev, sizeof(struct anatop), GFP_KERNEL);
>> +	if (!drvdata)
>> +		return -EINVAL;
>> +	drvdata->ioreg = ioreg;
>> +	drvdata->read = anatop_read;
>> +	drvdata->write = anatop_write;
>> +	platform_set_drvdata(pdev, drvdata);
>> +	of_platform_bus_probe(np, of_anatop_regulator_match, dev);
>> +	return ret;
>> +}
> So it seems that your driver here does nothing but extending your device tree
> definition. Correct me if I'm wrong, aren't you trying to fix a broken device
> tree definition here ?
> 

The driver here ioremap the addresses for anatop chip in i.MX6Q SoC. The
addresses are shared by several regulators. Also thermal drivers are
also in the same range.

Here are examples of the anatop description in dts file

   anatop@020c8000 {
           compatible = "fsl,imx6q-anatop";
           reg = <0x020c8000 0x1000>;
           interrupts = <0 49 0x04 0 54 0x04 0 127 0x04>;
           #address-cells = <1>;
           #size-cells = <1>;
           reg_vddpu: regulator-vddpu@140 {
                   compatible = "fsl,anatop-regulator";
                   regulator-name = "vddpu";
                   regulator-min-microvolt = <725000>;
                   regulator-max-microvolt = <1300000>;
                   regulator-always-on;
                   reg = <0x140 1>;
                   vol-bit-shift = <9>;
                   vol-bit-size = <5>;
                   min-bit-val = <1>;
                   min-voltage = <725000>;
                   max-voltage = <1300000>;
           };
           reg_vddcore: regulator-vddcore@140 {
                   compatible = "fsl,anatop-regulator";
                   regulator-name = "vddcore";
                   regulator-min-microvolt = <725000>;
                   regulator-max-microvolt = <1300000>;
                   regulator-always-on;
                   reg = <0x140 1>;
                   vol-bit-shift = <0>;
                   vol-bit-size = <5>;
                   min-bit-val = <1>;
                   min-voltage = <725000>;
                   max-voltage = <1300000>;
           };
           ...

So both reg_vddpu and reg_vddcore are using the same address.

Yours Sincerely,
Paul
