Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2JZJQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:16:27 -0400
Received: from antcom.de ([188.40.178.216]:53771 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab2JZJQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:16:24 -0400
Message-ID: <508A54E4.2060108@antcom.de>
Date: Fri, 26 Oct 2012 11:16:20 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.9) Gecko/20121015 Icedove/10.0.9
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "tru@work-microwave.de" <tru@work-microwave.de>
Subject: Re: [PATCH 2/2] ARM: mach-imx: CAN clock fix for i.MX53
References: <1351164400-27940-1-git-send-email-stigge@antcom.de> <1351164400-27940-2-git-send-email-stigge@antcom.de> <20121026085934.GA1641@pengutronix.de>
In-Reply-To: <20121026085934.GA1641@pengutronix.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 10/26/2012 10:59 AM, Sascha Hauer wrote:
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
> 
> I just rechecked. The above matches the i.MX53 Reference Manual rev 2.1
> 
>> +	clk[can1_serial_gate] = imx_clk_gate2("can1_serial_gate", "can_sel", MXC_CCM_CCGR4, 6);
>> +	clk[can1_ipg_gate] = imx_clk_gate2("can1_ipg_gate", "ipg", MXC_CCM_CCGR4, 8);
>> +	clk[can2_serial_gate] = imx_clk_gate2("can2_serial_gate", "can_sel", MXC_CCM_CCGR4, 6);
>> +	clk[can2_ipg_gate] = imx_clk_gate2("can2_ipg_gate", "ipg", MXC_CCM_CCGR4, 8);
> 
> This doesn't.

This may be right, but unfortunately, since the introduction of your
can1 + can2 clocking change, the first block stopped working for me.

My above patch is basically a rollback which works for the first block.

An interesting hint is: can2 (which was the only one defined _before_
your can1 + can2 change) didn't work before and afterwards at all. (But
I'm not using it anyway.)

Thanks,

Roland
