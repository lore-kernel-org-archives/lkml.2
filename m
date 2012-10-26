Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab2JZLF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:05:59 -0400
Received: from antcom.de ([188.40.178.216]:51230 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab2JZLF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:05:57 -0400
Message-ID: <508A6E92.1000107@antcom.de>
Date: Fri, 26 Oct 2012 13:05:54 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.9) Gecko/20121015 Icedove/10.0.9
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Sascha Hauer <s.hauer@pengutronix.de>, kernel@pengutronix.de,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "tru@work-microwave.de" <tru@work-microwave.de>
Subject: Re: [PATCH 2/2] ARM: mach-imx: CAN clock fix for i.MX53
References: <1351164400-27940-1-git-send-email-stigge@antcom.de> <1351164400-27940-2-git-send-email-stigge@antcom.de> <20121026085934.GA1641@pengutronix.de> <508A54E4.2060108@antcom.de> <508A665C.80107@pengutronix.de>
In-Reply-To: <508A665C.80107@pengutronix.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 12:30 PM, Marc Kleine-Budde wrote:
>>>> +	clk[can1_serial_gate] = imx_clk_gate2("can1_serial_gate",
>>>> "can_sel", MXC_CCM_CCGR4, 6); +	clk[can1_ipg_gate] =
>>>> imx_clk_gate2("can1_ipg_gate", "ipg", MXC_CCM_CCGR4, 8); +
>>>> clk[can2_serial_gate] = imx_clk_gate2("can2_serial_gate",
>>>> "can_sel", MXC_CCM_CCGR4, 6); +	clk[can2_ipg_gate] =
>>>> imx_clk_gate2("can2_ipg_gate", "ipg", MXC_CCM_CCGR4, 8);
>>> 
>>> This doesn't.
>> 
>> This may be right, but unfortunately, since the introduction of
>> your can1 + can2 clocking change, the first block stopped working
>> for me.
> 
> You are effectively using can2's clock for can1. Are you sure you 
> haven't mixed up can1 and can2?

Just using the above patch and patch 1/2 from this series (missing can
pinmuxing), doing like this in custom .dts:

+                       can1: can@53fc8000 {
+                               pinctrl-names = "default";
+                               pinctrl-0 = <&pinctrl_can1_1>;
+                               clock-frequency = <66500000>;
+                               status = "okay";
+                       };

Then, the can0 interface appears which can be upped as network interface.

Quite straightforward, isn't it?

Roland
