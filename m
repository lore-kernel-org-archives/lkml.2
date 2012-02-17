Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab2BQSVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:21:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:38816 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab2BQSVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:21:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="111547732"
Message-ID: <4F3E928E.8060908@linux.intel.com>
Date: Fri, 17 Feb 2012 09:46:54 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "lkml, " <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: pch_uart and pch_phub clock selection
References: <4F3DA617.5030805@linux.intel.com> <20120217013012.GA18530@kroah.com>
In-Reply-To: <20120217013012.GA18530@kroah.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/16/2012 05:30 PM, Greg Kroah-Hartman wrote:
> On Thu, Feb 16, 2012 at 04:57:59PM -0800, Darren Hart wrote:
>> I'm working on a tunnel creek (atom e6xx + topcliff PCH) development platform
>> that uses a 48MHz or 64MHz clock to drive the pch_uart. I've found that if I
>> force the uart_clock to 48MHz (or 64MHz on the latest rev) I can get the kernel
>> messages and getty on the serial port.
>>
>> I see that the the CM-iTC board is special-cased to set a 192MHz uart_clock.
>> This is done in pch_uart.c code, but there is some register manipulation done in
>> the pch_phub.c driver and I don't understand the connection. How are the two
>> related?
>>
>> Is the pch_phub.c register manipulation required for proper related? It seems to
>> work without touching those registers if I just force the clock.
>>
>> The device I'm working with is EFI, and the dmi_get_system_info(DMI_BOARD_NAME)
>> returns "(null)", so I can't use the same test to identify this board. Is there
>> another common mechanism I might be able to use?
> 
> There's no relevant DMI information for the board at all?  What does:
> 	grep . /sys/class/dmi/id/*
> show?

Duh.

# cat /sys/class/dmi/id/product_name
Fish River Island II


> 
>>
>> The following patch (by way of example, not meant for inclusion) gets things
>> working for this particular board with this command line:
>>
>> console=ttyPCH1,115200 pch_uart.clock_param=48000000
>>
>> I believe the right thing to do here is to discover a way to identify the board
>> and special case the clock as is done for the CM-iTC, but I would like to
>> understand the purpose of the pch_phub register manipulation code. Does this
>> make sense?
>>
>> Thanks,
>>
>> Darren
>>
>>
>> >From f83fa6cb575844d8e37f136890fe32258eb88dd2 Mon Sep 17 00:00:00 2001
>> Message-Id: <f83fa6cb575844d8e37f136890fe32258eb88dd2.1329439822.git.dvhart@linux.intel.com>
>> From: Darren Hart <dvhart@linux.intel.com>
>> Date: Wed, 15 Feb 2012 15:44:18 -0800
>> Subject: [PATCH] pch_uart: Add clock parameter
>>
>> Allow for the specification of the clock as a module parameter. This is useful
>> when a board uses a non-standard clock, or when different versions of a board
>> use different clocks, and that board name or the version are not available to
>> the kernel.
> 
> You also rename base_baud to uart_clock here, so you might want to
> mention it in the changelog entry :)
> 

Right, thanks. I suspect I'll end up breaking that change out as a
semantic patch :-)

> greg k-h

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
