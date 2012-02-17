Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab2BQSVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:21:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:38816 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab2BQSVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:21:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="111547745"
Message-ID: <4F3E9909.7010301@linux.intel.com>
Date: Fri, 17 Feb 2012 10:14:33 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Feng Tang <feng.tang@intel.com>, "lkml," <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: pch_uart and pch_phub clock selection
References: <4F3DA617.5030805@linux.intel.com> <20120217072808.GA26800@feng-i7> <CANKRQnhfQyUrMWaXJVsjmL-yFnHa9WuR5LfTkqv=QmRGnC2aTw@mail.gmail.com>
In-Reply-To: <CANKRQnhfQyUrMWaXJVsjmL-yFnHa9WuR5LfTkqv=QmRGnC2aTw@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2012 01:50 AM, Tomoya MORINAGA wrote:
> Hi
> 
> 2012年2月17日16:28 Feng Tang <feng.tang@intel.com>:
>> I see that the the CM-iTC board is special-cased to set a 192MHz uart_clock.
>> This is done in pch_uart.c code, but there is some register manipulation done in
>> the pch_phub.c driver and I don't understand the connection. How are the two
>> related?
> According to your use, need to configure clock registers which are in pch_phub .
> Upstreamed version, UART_CLK can be used directly(neither multiple nor
> division) as UART clock.

I'm not following. I think you are saying that I need to configure the
clock registers - but in my patch I don't touch them and it works. Are
the registers intended to be read so I can determine HOW the device is
configured, are they intended to be written in order to change how it is
configured, or both.

Firmware sets up some initial state and this has been what I'm trying to
match in order to get an early serial console.

> 
> You can get clock configuration information from SourceForge.
> (http://sourceforge.net/projects/ml7213/files/Kernel%202.6.37/Release/Ver1.2.0/EG20TPCH_ML7213_ML7223_ML7831_linux-2.6.37_v120_20110930.tar.bz2/
> and extract pch_phub. you can find readme.)
> I extract it and show below.
> 
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> <Configuration>
> =======================
> 
> 1. Over 115K baud rate UART settings
>     By default, UART can communicate less than 115Kbps.
>     In case you want UART to work more than 115Kbps, the following
> clock configuration is necessary.
>     - Clock setting
>           Set BAUDSEL = usb_48mhz
>           Set PLL2VCO = "x 8" the clock
>           Set BAUDDIV = "x 1/6" the clock
>           Set UARTCLKSEL = PLL2 output
>     For details, please refer to ML7213/ML7223 EDS "5 Chip Configuration"
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> In case we want UART to work high baud rate(e.g.4Mbps), we set like above.
> and execute "setserial /dev/ttyPCH0 baud_base 4000000".
> I can see PCH_UART with 4Mbps works well.
> 
> Darren, is this answer for your question ?

Not quite. I need to be able to use the UART at boot as an early serial
console. So I believe I need to match the firmware UART configuration
early on (well before we could call setserial).

> 
>> Tomoya, do you know if we can also set it to 192MHz for ML7223 IOH Bus-m/n?
> Yes, you can.
> 

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
