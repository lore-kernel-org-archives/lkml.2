Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab2BVDKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 22:10:13 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54660 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2BVDKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 22:10:11 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1329875301.git.dvhart@linux.intel.com>
References: <cover.1329875301.git.dvhart@linux.intel.com>
Date: Wed, 22 Feb 2012 12:10:10 +0900
Message-ID: <CANKRQni9E6NO39MFSak6MjQ0DtmQeviGo966Ex9ZUvai56wCjg@mail.gmail.com>
Subject: Re: [PATCH 0/4] pch_uart: Cleanups, board quirks, and user uartclk parameter
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012年2月22日10:59 Darren Hart <dvhart@linux.intel.com>:
> This series does some minor clean-up to the pch_uart driver, adds support
> for the Fish River Island II UART clock, and introduces a user_uartclk
> parameter to aid in developing for early and changing hardware.
>
> Note that this series is my proposed alternative solution to that provided
> by Tomoya MORNIAGA and Feng Tang which drops the board quirks and opts to
> assume a 192 MHz clock on all boards. The problem with this approach is
> that the CLKCFG register may have been set to something other than the
> 192MHz configuration by the firmware. If so, then the pch_uart will send
> garbage between the time the boot console is disabled and the pch_phub
> sets the CLKCFG register again. In my case, the pch_phub PCI probe occurs
> after the pch_uart_console_setup. Even if it happened before, the output
> up until the PCI probing would be garbage.
>
> In order to support an early serial console, we cannot rely on the pch_phub
> probe function to setup the CFGCLK register. This series relies on the board
> quirks and doesn't force the setting of the CLKREG in the pch_phub code.
> Instead, it aligns with what is the default configuration (defined by firmware)
> for a given board. The user_uartclk provides a mechanism to force a specific
> uartclk if necessary.

I think UART console function(including "early serial console") is
used for debug use.

So, if people who want to see the boot log correctly before pch_phub installed,
the people have only to do configure uart_clock by themselves.

So, I think default uart_clock 192MHz setting is better than Darren's opinion.

Let me know your opinion.

thanks,

---
ROHM Co., Ltd.
tomoya
