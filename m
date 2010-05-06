Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0EFLJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 07:09:16 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:53069 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab0EFLJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 07:09:15 -0400
Message-ID: <4BE2A34C.1040301@mev.co.uk>
Date: Thu, 6 May 2010 12:09:00 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100422 Thunderbird/3.0.4
MIME-Version: 1.0
To: "nios2-dev@sopc.et.ntust.edu.tw" <nios2-dev@sopc.et.ntust.edu.tw>
CC: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Nios2-dev] [PATCH 2/2] serial: Add driver for the Altera UART
References: <cover.1273048151.git.tklauser@distanz.ch>	<095aab012b2a6b3bbf4c7bc04294bb9c19316318.1273048151.git.tklauser@distanz.ch> <1273142684.3477.22.camel@gentoo-ija64.mev.local>
In-Reply-To: <1273142684.3477.22.camel@gentoo-ija64.mev.local>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/10 11:44, Ian Abbott wrote:
> On Wed, 2010-05-05 at 09:35 +0100, Tobias Klauser wrote:
>> Add an UART driver for the UART component available as a SOPC (System on
>> Programmable Chip) component for Altera FPGAs.
> [...]
> 
>> +static void altera_uart_start_tx(struct uart_port *port)
>> +{
>> +       struct altera_uart *pp = container_of(port, struct altera_uart, port);
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +       pp->imr |= ALTERA_UART_CONTROL_TRDY_MSK;
>> +       writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +}
>> +
>> +static void altera_uart_stop_tx(struct uart_port *port)
>> +{
>> +       struct altera_uart *pp = container_of(port, struct altera_uart, port);
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +       pp->imr &= ~ALTERA_UART_CONTROL_TRDY_MSK;
>> +       writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +}
>> +
>> +static void altera_uart_stop_rx(struct uart_port *port)
>> +{
>> +       struct altera_uart *pp = container_of(port, struct altera_uart, port);
>> +       unsigned long flags;
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +       pp->imr &= ~ALTERA_UART_CONTROL_RRDY_MSK;
>> +       writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
>> +       spin_unlock_irqrestore(&port->lock, flags);
>> +}
> 
> Those four functions shouldn't grab port->lock because the caller in
> serial_core.c grabs it before calling them.

Oh, and that also applies to altera_uart_set_mctrl() - the caller grabs
port->lock before calling it.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
