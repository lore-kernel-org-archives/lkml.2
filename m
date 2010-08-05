Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814Ab0HEHQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:16:36 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:38218 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758803Ab0HEHQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:16:34 -0400
Message-ID: <4C5A64E0.5060807@stericsson.com>
Date: Thu, 5 Aug 2010 09:14:40 +0200
From: Philippe Langlais <philippe.langlais@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Vincent GUITTOT <vincent.guittot@stericsson.com>
Subject: Re: [PATCH] U6715 16550A serial driver support
References: <1280739519-26930-1-git-send-email-philippe.langlais@stericsson.com> <20100804125253.3977b0d7.akpm@linux-foundation.org>
In-Reply-To: <20100804125253.3977b0d7.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/04/10 21:52, Andrew Morton wrote:
> On Mon, 2 Aug 2010 10:58:39 +0200
> Philippe Langlais<philippe.langlais@stericsson.com>  wrote:
>
>    
>> UART Features extract from STEricsson U6715 data-sheet (arm926 SoC for mobile phone):
>> * Fully compatible with industry standard 16C550 and 16C450 from various
>> manufacturers
>> * RX and TX 64 byte FIFO reduces CPU interrupts
>> * Full double buffering
>> * Modem control signals include CTS, RTS, (and DSR, DTR on UART1 only)
>> * Automatic baud rate selection
>> * Manual or automatic RTS/CTS smart hardware flow control
>> * Programmable serial characteristics:
>> ___ Baud rate generation (50 to 3.25M baud)
>> ___ 5, 6, 7 or 8-bit characters
>> ___ Even, odd or no-parity bit generation and detection
>> ___ 1, 1.5 or 2 stop bit generation
>> * Independent control of transmit, receive, line status, data set interrupts and FIFOs
>> * Full status-reporting capabilities
>> * Separate DMA signaling for RX and TX
>> * Timed interrupt to spread receive interrupt on known duration
>> * DMA time-out interrupt to allow detection of end of reception
>> * Carkit pulse coding and decoding compliant with USB carkit control interface [40]
>>
>> In 16550A auto-configuration, if the fifo size is 64 then it's an U6 16550A port
>> Add set_termios hook&  export serial8250_do_set_termios to change uart
>> clock following baudrate
>>      
> Confused.
>
>    
>> ...
>>
>> --- a/include/linux/serial_8250.h
>> +++ b/include/linux/serial_8250.h
>> @@ -32,6 +32,9 @@ struct plat_serial8250_port {
>>   	unsigned int	type;		/* If UPF_FIXED_TYPE */
>>   	unsigned int	(*serial_in)(struct uart_port *, int);
>>   	void		(*serial_out)(struct uart_port *, int, int);
>> +	void		(*set_termios)(struct uart_port *,
>> +			               struct ktermios *new,
>> +			               struct ktermios *old);
>>   };
>>
>> ...
>>
>> --- a/include/linux/serial_core.h
>> +++ b/include/linux/serial_core.h
>> @@ -279,6 +279,9 @@ struct uart_port {
>>   	unsigned char __iomem	*membase;		/* read/write[bwl] */
>>   	unsigned int		(*serial_in)(struct uart_port *, int);
>>   	void			(*serial_out)(struct uart_port *, int, int);
>> +	void			(*set_termios)(struct uart_port *,
>> +				               struct ktermios *new,
>> +				               struct ktermios *old);
>>   	unsigned int		irq;			/* irq number */
>>   	unsigned long		irqflags;		/* irq flags  */
>>   	unsigned int		uartclk;		/* base uart clock */
>>      
> The patch adds these .set_termios hooks but doesn't actually use them
> for anything.
>
> The changelog doesn't tell us _why_ this was done (it should) and
> lacking any code to look at it's all a bit mysterious.
>
>    
This feature is used in our U6715 8250 platform serial driver, to avoid
hack in 8250.c set_termios (Alan Cox requirement).
In this driver the input uart clock frequency depends on baud rate and
is computed in our set_termios override function.
The U6715 paltform serial patch has been submitted on linux-arm mailing 
list,
and is ready to enter Russell King Linux tree.

More things to do ?

Philippe
