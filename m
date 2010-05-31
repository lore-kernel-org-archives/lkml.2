Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0EaOV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 10:21:28 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:60448 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754912Ab0EaOV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 10:21:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADNiA0zCTtAn/2dsb2JhbACeMnHBEYUWBA
Date: Mon, 31 May 2010 16:21:23 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: hskinnemoen@atmel.com, Nicolas Ferre <nicolas.ferre@atmel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Bernhard Roth <br@pwrnet.de>,
       Rick Bronson <rick@efn.org>, John Nicholls <john@thinlinx.com>,
       Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
       Ryan Mallon <ryan@bluewatersys.com>,
       michael trimarchi <michael@evidence.eu.com>,
       Konrad Mattheis <mattheis@ukma.de>, Elektrolot <elektrolot@wp.pl>,
       Prchal =?utf-8?B?SmnFmcOt?= <jiri.prchal@aksignal.cz>,
       akpm@linux-foundation.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux@maxim.org.za
Subject: Re: [PATCH] General fixes in the serial_rs485 structure
Message-ID: <20100531142122.GA2571@frolo.macqel>
References: <4BFE66CA.5050500@evidence.eu.com> <20100529000839.158dedd3@lxorguk.ukuu.org.uk> <4C0375C1.5030305@evidence.eu.com> <20100531113429.5efd6de9@lxorguk.ukuu.org.uk> <4C03BC19.5060402@evidence.eu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C03BC19.5060402@evidence.eu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 03:39:37PM +0200, Claudio Scordino wrote:

> diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
> index eed3c2d..1adb1bf 100644
> --- a/drivers/serial/atmel_serial.c
> +++ b/drivers/serial/atmel_serial.c
> @@ -216,7 +216,7 @@ void atmel_config_rs485(struct uart_port *port, struct serial_rs485 *rs485conf)
>  	if (rs485conf->flags & SER_RS485_ENABLED) {
>  		dev_dbg(port->dev, "Setting UART to RS485\n");
>  		atmel_port->tx_done_mask = ATMEL_US_TXEMPTY;
> -		UART_PUT_TTGR(port, rs485conf->delay_rts_before_send);
> +		UART_PUT_TTGR(port, rs485conf->delay_rts_after_send);
>  		mode |= ATMEL_US_USMODE_RS485;
>  	} else {
>  		dev_dbg(port->dev, "Setting UART to RS232\n");

Should the usage of delay_rts_after_send not depend on
(flags & SER_RS485_RTS_AFTER_SEND) also ?

and likewise with delay_rts_before_send and SER_RS485_RTS_BEFORE_SEND ?

Philippe

-- 
Philippe De Muyter  phdm at macqel dot be  Tel +32 27029044
Macq Electronique SA  rue de l'Aeronef 2  B-1140 Bruxelles  Fax +32 27029077
