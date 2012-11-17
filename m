Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2KQJlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 04:41:19 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:50947 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2KQJlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 04:41:16 -0500
Message-ID: <50A75BB4.4070003@free-electrons.com>
Date: Sat, 17 Nov 2012 10:41:08 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] clk: mvebu: armada 370/XP add clock gating control
 provider for DT
References: <1353014906-31566-6-git-send-email-andrew@lunn.ch> <1353088920-17458-1-git-send-email-gregory.clement@free-electrons.com> <1353088920-17458-2-git-send-email-gregory.clement@free-electrons.com> <20121117082602.GF24569@lunn.ch>
In-Reply-To: <20121117082602.GF24569@lunn.ch>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew

On 11/17/2012 09:26 AM, Andrew Lunn wrote:
> Hi Gregory
> 
> Nice work

Thanks!

> 
> On Fri, Nov 16, 2012 at 07:01:59PM +0100, Gregory CLEMENT wrote:
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> ---
>>  .../bindings/clock/mvebu-gated-clock.txt           |   43 ++++++++++++++
>>  arch/arm/mach-mvebu/Kconfig                        |    1 +
>>  drivers/clk/mvebu/clk-gating-ctrl.c                |   61 ++++++++++++++++++++
>>  3 files changed, 105 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt b/Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt
>> index 7497cc0..9dbcdd9 100644
>> --- a/Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt
>> +++ b/Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt
>> @@ -6,6 +6,49 @@ the clock ID in its "clocks" phandle cell. The clock ID is directly mapped to
>>  the corresponding clock gating control bit in HW to ease manual clock lookup
>>  in datasheet.
>>  
>> +The following is a list of provided IDs for Armada XP:
> 
> Should that the 370, not XP?

Yes indeed, it was a wrong copy and paste.

> 
>> +ID	Clock	Peripheral
>> +-----------------------------------
>> +0	Audio	AC97 Cntrl
>> +1	pex0_en	PCIe 0 Clock out
>> +2	pex1_en	PCIe 1 Clock out
>> +3	ge1	Gigabit Ethernet 1
>> +4	ge0	Gigabit Ethernet 0
>> +5	pex0	PCIe Cntrl 0
>> +9	pex1	PCIe Cntrl 1
>> +15	sata0	SATA Host 0
>> +17	sdio	SDHCI Host
>> +25	tdm	Time Division Mplx
>> +28	ddr	DDR Cntrl
>> +30	sata1	SATA Host 0
> 
> Not many clocks there. USB? XOR? Crypto?

Yes I was surprised too, but it was I found on the datasheet.
For USB, for example you can turn the USB in low power mode but
at the PHY level.


> 
> What is the ddr clock for? Does bad things happen if you turn it off?
> Kirkwood has a similar clock, dunit, which i decided not to export,
> since when you turn it off, the whole SoC locks up.

Well of course if you code run in DDR then it could be a problem. But
I think it could be useful to turn it off when going to suspend, it
the DDR can do self-refresh. In this case it should be possible to run
the code from SRAM or L2 Cache.

Gregory
