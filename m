Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972Ab2J2Vby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:31:54 -0400
Received: from antcom.de ([188.40.178.216]:56734 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab2J2Vbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:31:53 -0400
Message-ID: <508EF59D.6040202@antcom.de>
Date: Mon, 29 Oct 2012 22:31:09 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: mach-imx: CAN clock fix for i.MX53
References: <1351164400-27940-1-git-send-email-stigge@antcom.de> <1351164400-27940-2-git-send-email-stigge@antcom.de> <20121029212043.GA1641@pengutronix.de>
In-Reply-To: <20121029212043.GA1641@pengutronix.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/10/12 22:20, Sascha Hauer wrote:
> Roland,
> 
> Do you have updates on this one? I think this patch is wrong, specifying
> the clock rate in the devicetree is only for PowerPC, so I think this
> needs further investigation.

Please ignore it for now. As discussed with Marc, the issue seemed to be
caused by me (wrongfully) using the "clock-frequency" dt property which
caused probe() to ignore the clocks.

A colleague of mine will notify me if the problem surfaces again. So for
now I assume it's gone.

Maybe the above strategy regarding "clock-frequency" needs to be
documented better or changed, though, to prevent more confusion like in
the above case.

Thanks,

Roland

> On Thu, Oct 25, 2012 at 01:26:40PM +0200, Roland Stigge wrote:
>> This patch fixes CAN clocking on i.MX53.
>>
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>>
>> ---
>>  arch/arm/mach-imx/clk-imx51-imx53.c |    8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> --- linux-2.6.orig/arch/arm/mach-imx/clk-imx51-imx53.c
>> +++ linux-2.6/arch/arm/mach-imx/clk-imx51-imx53.c
>> @@ -426,10 +426,10 @@ int __init mx53_clocks_init(unsigned lon
>>  	clk[usb_phy2_gate] = imx_clk_gate2("usb_phy2_gate", "usb_phy_sel", MXC_CCM_CCGR4, 12);
>>  	clk[can_sel] = imx_clk_mux("can_sel", MXC_CCM_CSCMR2, 6, 2,
>>  				mx53_can_sel, ARRAY_SIZE(mx53_can_sel));
>> -	clk[can1_serial_gate] = imx_clk_gate2("can1_serial_gate", "can_sel", MXC_CCM_CCGR6, 22);
>> -	clk[can1_ipg_gate] = imx_clk_gate2("can1_ipg_gate", "ipg", MXC_CCM_CCGR6, 20);
>> -	clk[can2_serial_gate] = imx_clk_gate2("can2_serial_gate", "can_sel", MXC_CCM_CCGR4, 8);
>> -	clk[can2_ipg_gate] = imx_clk_gate2("can2_ipg_gate", "ipg", MXC_CCM_CCGR4, 6);
>> +	clk[can1_serial_gate] = imx_clk_gate2("can1_serial_gate", "can_sel", MXC_CCM_CCGR4, 6);
>> +	clk[can1_ipg_gate] = imx_clk_gate2("can1_ipg_gate", "ipg", MXC_CCM_CCGR4, 8);
>> +	clk[can2_serial_gate] = imx_clk_gate2("can2_serial_gate", "can_sel", MXC_CCM_CCGR4, 6);
>> +	clk[can2_ipg_gate] = imx_clk_gate2("can2_ipg_gate", "ipg", MXC_CCM_CCGR4, 8);
>>  	clk[i2c3_gate] = imx_clk_gate2("i2c3_gate", "per_root", MXC_CCM_CCGR1, 22);
>>  
>>  	for (i = 0; i < ARRAY_SIZE(clk); i++)
>>
> 

