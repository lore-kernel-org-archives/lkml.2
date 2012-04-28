Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab2D1Kjg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 06:39:36 -0400
Received: from antcom.de ([188.40.178.216]:34429 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab2D1Kje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 06:39:34 -0400
Message-ID: <4F9BC8E2.20005@antcom.de>
Date: Sat, 28 Apr 2012 12:39:30 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Device tree conversion of spi device vs. controller_data
References: <4F816772.5000607@antcom.de> <20120413032945.0C76B3E07AC@localhost> <4F87D157.2020700@antcom.de> <20120427180344.F023D3E171B@localhost>
In-Reply-To: <20120427180344.F023D3E171B@localhost>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/04/12 20:03, Grant Likely wrote:
>>> Can you point me at specific code?
>>>
>>> .controller_data is owned by the spi_master driver.  The eeprom driver
>>> shouldn't be accessing it directly at all; but I'll need to look at
>>> specific code to really understand what is going on.
>>
>> Please have a look at arch/arm/mach-lpc32xx/phy3250.c :
>>
>> static struct pl022_config_chip spi0_chip_info = {
>>         .com_mode               = INTERRUPT_TRANSFER,
>>         .iface                  = SSP_INTERFACE_MOTOROLA_SPI,
>>         .hierarchy              = SSP_MASTER,
>>         .slave_tx_disable       = 0,
>>         .rx_lev_trig            = SSP_RX_4_OR_MORE_ELEM,
>>         .tx_lev_trig            = SSP_TX_4_OR_MORE_EMPTY_LOC,
>>         .ctrl_len               = SSP_BITS_8,
>>         .wait_state             = SSP_MWIRE_WAIT_ZERO,
>>         .duplex                 = SSP_MICROWIRE_CHANNEL_FULL_DUPLEX,
>>         .cs_control             = phy3250_spi_cs_set,
> 
> phy3250_spi_cs_set is only a wrapper around gpio_set_value().  GPIO CS
> manipulation should be handled by the core pl022 spi driver, so that
> gets rid of the hardest part of this conversion (callbacks in platform
> data).
> 
> The pl022_config_chip structure is 100% owned by the spi controller
> (pl022).  If the bus driver depends on this structure, then it is the
> responsibility of the bus driver to allocate one and set the
> controller data pointer for each of the child devices.  You may need
> to add pl022-specific properties to each of the child nodes to
> populate this data correctly if it cannot be determined with other
> means.

Yes, that's what I'll need to do.

Thanks!

Roland
