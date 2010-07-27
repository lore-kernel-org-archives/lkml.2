Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab0G0Orj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 10:47:39 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:52631 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108Ab0G0Ori (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 10:47:38 -0400
Message-ID: <4C4EF132.7090304@stericsson.com>
Date: Tue, 27 Jul 2010 16:46:10 +0200
From: Philippe Langlais <philippe.langlais@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Lightning/1.0b1 Thunderbird/3.0.5
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Vincent GUITTOT <vincent.guittot@stericsson.com>
Subject: Re: patch "U6715 8250 serial like driver" added to gregkh-2.6 tree
References: <1279531660-16317-1-git-send-email-philippe.langlais@stericsson.com>	<12798430773066@site>	<20100723090119.5d63cfb7@lxorguk.ukuu.org.uk>	<4C4E9064.6070001@stericsson.com> <20100727091408.49d55447@lxorguk.ukuu.org.uk>
In-Reply-To: <20100727091408.49d55447@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/27/10 10:14, Alan Cox wrote:
>>> I think what you need to keep this clean is to create a
>>> port->set_termios() for the 8250 port (akin to
>>> port->serial_in/serial_out) which does the specials you need each end and
>>> calls the standard serial8250_set_termios)
>>>
>>>        
>> I don't think so, call a function which compute clock each time
>> we access UART registers isn't optimal, another function to overload ?
>>      
> set_termios() gets called once at init time and once each time a
> caller requests a change in serial parameters. That's not usually
> considered a hot path. I'm not suggesting you hide it in the register
> methods but add ->set_termios as a method that can be overridden, plus
> export the existing one so you can wrap it.
>
> If you can't detect the chip then create yourself a u6715 driver file
> which registers the ports you have and specifies the relevant
> serial_in/out methods and other detail as well as containing the board
> specific routines needed.
>
> See arch/arm/mach-omap2/serial.c for a ARM example doing this, where all
> the chip knowledge is nicely buried away in the platform support.
>    
We have such a platform driver, but I can't see anywhere an example of 
set_termios()
or another uart_ops function overriding.
These platform drivers only add new functions around power & clock.
Platform drivers are initialized before 8250 driver, how to override 
8250 driver ?



