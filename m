Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab2BVDhC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 22:37:02 -0500
Received: from mga01.intel.com ([192.55.52.88]:57288 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab2BVDg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 22:36:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="128008727"
Message-ID: <4F4462B8.6030607@linux.intel.com>
Date: Tue, 21 Feb 2012 19:36:24 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH 0/4] pch_uart: Cleanups, board quirks, and user uartclk
 parameter
References: <cover.1329875301.git.dvhart@linux.intel.com> <CANKRQni9E6NO39MFSak6MjQ0DtmQeviGo966Ex9ZUvai56wCjg@mail.gmail.com>
In-Reply-To: <CANKRQni9E6NO39MFSak6MjQ0DtmQeviGo966Ex9ZUvai56wCjg@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/21/2012 07:10 PM, Tomoya MORINAGA wrote:
> 2012年2月22日10:59 Darren Hart <dvhart@linux.intel.com>:
>> This series does some minor clean-up to the pch_uart driver, adds support
>> for the Fish River Island II UART clock, and introduces a user_uartclk
>> parameter to aid in developing for early and changing hardware.
>>
>> Note that this series is my proposed alternative solution to that provided
>> by Tomoya MORNIAGA and Feng Tang which drops the board quirks and opts to
>> assume a 192 MHz clock on all boards. The problem with this approach is
>> that the CLKCFG register may have been set to something other than the
>> 192MHz configuration by the firmware. If so, then the pch_uart will send
>> garbage between the time the boot console is disabled and the pch_phub
>> sets the CLKCFG register again. In my case, the pch_phub PCI probe occurs
>> after the pch_uart_console_setup. Even if it happened before, the output
>> up until the PCI probing would be garbage.
>>
>> In order to support an early serial console, we cannot rely on the pch_phub
>> probe function to setup the CFGCLK register. This series relies on the board
>> quirks and doesn't force the setting of the CLKREG in the pch_phub code.
>> Instead, it aligns with what is the default configuration (defined by firmware)
>> for a given board. The user_uartclk provides a mechanism to force a specific
>> uartclk if necessary.
> 
> I think UART console function(including "early serial console") is
> used for debug use.
> 
> So, if people who want to see the boot log correctly before pch_phub installed,
> the people have only to do configure uart_clock by themselves.
> 
> So, I think default uart_clock 192MHz setting is better than Darren's opinion.
> 
> Let me know your opinion.

This patch series allows for a functional early serial console as well
as using the UART after boot. It leaves the CM-iTC board alone. So this
seems to enable all use cases, while forcing 192MHz breaks the FRI2
early serial console. I don't see an advantage to that approach other
than the obviously simpler code (which is nice, but should not trump
functionality).

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
