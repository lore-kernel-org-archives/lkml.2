Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2BQJug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:50:36 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50293 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab2BQJue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:50:34 -0500
MIME-Version: 1.0
In-Reply-To: <20120217072808.GA26800@feng-i7>
References: <4F3DA617.5030805@linux.intel.com>
	<20120217072808.GA26800@feng-i7>
Date: Fri, 17 Feb 2012 18:50:33 +0900
Message-ID: <CANKRQnhfQyUrMWaXJVsjmL-yFnHa9WuR5LfTkqv=QmRGnC2aTw@mail.gmail.com>
Subject: Re: pch_uart and pch_phub clock selection
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Feng Tang <feng.tang@intel.com>, Darren Hart <dvhart@linux.intel.com>
Cc: "lkml," <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

2012年2月17日16:28 Feng Tang <feng.tang@intel.com>:
> I see that the the CM-iTC board is special-cased to set a 192MHz uart_clock.
> This is done in pch_uart.c code, but there is some register manipulation done in
> the pch_phub.c driver and I don't understand the connection. How are the two
> related?
According to your use, need to configure clock registers which are in pch_phub .
Upstreamed version, UART_CLK can be used directly(neither multiple nor
division) as UART clock.

You can get clock configuration information from SourceForge.
(http://sourceforge.net/projects/ml7213/files/Kernel%202.6.37/Release/Ver1.2.0/EG20TPCH_ML7213_ML7223_ML7831_linux-2.6.37_v120_20110930.tar.bz2/
and extract pch_phub. you can find readme.)
I extract it and show below.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
<Configuration>
=======================

1. Over 115K baud rate UART settings
    By default, UART can communicate less than 115Kbps.
    In case you want UART to work more than 115Kbps, the following
clock configuration is necessary.
    - Clock setting
          Set BAUDSEL = usb_48mhz
          Set PLL2VCO = "x 8" the clock
          Set BAUDDIV = "x 1/6" the clock
          Set UARTCLKSEL = PLL2 output
    For details, please refer to ML7213/ML7223 EDS "5 Chip Configuration"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In case we want UART to work high baud rate(e.g.4Mbps), we set like above.
and execute "setserial /dev/ttyPCH0 baud_base 4000000".
I can see PCH_UART with 4Mbps works well.

Darren, is this answer for your question ?

> Tomoya, do you know if we can also set it to 192MHz for ML7223 IOH Bus-m/n?
Yes, you can.

-- 
ROHM Co., Ltd.
tomoya
