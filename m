Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab1E3ERU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 00:17:20 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:34634 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807Ab1E3ERT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 00:17:19 -0400
Message-ID: <4DE31A2E.70705@st.com>
Date: Mon, 30 May 2011 06:16:46 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
Cc: =?windows-1252?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: 2 small kernel config issues related to UML + RTC
References: <201105291122.01602.toralf.foerster@gmx.de> <103895.1306689477@turing-police.cc.vt.edu>
In-Reply-To: <103895.1306689477@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Valdis

On 5/29/2011 7:17 PM, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 29 May 2011 11:22:01 +0200, Toralf F�rster said:
>>   │ Symbol: STMMAC_RTC_TIMER [=n]                        
>>   │ Type  : boolean
>>   │ Prompt: Real time clock
>>   │   Defined at drivers/net/stmmac/Kconfig:50
>>   │   Depends on: <choice> && RTC_CLASS
>>   │   Location:
>>   │     -> Network device support (NETDEVICES [=y])
>>   │       -> Ethernet (1000 Mbit) (NETDEV_1000 [=n])
>>   │         -> STMicroelectronics 10/100/1000 Ethernet driver (STMMAC_ETH [=n])
>>   │           -> STMMAC Timer optimisation (STMMAC_TIMER [=n])
>>   │             -> Select Timer device (<choice> [=n])
> 
> Ouch. That has to be the strangest place one could *possibly* put an RTC driver. ;)
> 
> Giuseppe - is that RTC driver *really* an integral part of the chipset and
> won't work without the Ethernet parts, or should the driver code for the RTC
> live elsewhere in the tree?

No the external RTC (or the SH-4 TMU) HW can be used by the driver to
handle the rx/tx process mitigating the DMA interrupts. This is not the
best approach but it actually helped many people to space the CPU
especially on old chips w/o dedicate timer.

It's likely I will remove all this code as soon as I work on a chip with
the embedded watchdog.

Regards
Giuseppe
