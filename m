Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab2BVJ4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:56:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:6815 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab2BVJ4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:56:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="128097270"
Message-ID: <4F44BB9E.7060108@linux.intel.com>
Date: Wed, 22 Feb 2012 01:55:42 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH 0/4] pch_uart: Cleanups, board quirks, and user uartclk
 parameter
References: <cover.1329875301.git.dvhart@linux.intel.com> <CANKRQni9E6NO39MFSak6MjQ0DtmQeviGo966Ex9ZUvai56wCjg@mail.gmail.com> <20120222085830.1ed8c25e@pyramind.ukuu.org.uk>
In-Reply-To: <20120222085830.1ed8c25e@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/22/2012 12:58 AM, Alan Cox wrote:
>>> assume a 192 MHz clock on all boards. The problem with this approach is
>>> that the CLKCFG register may have been set to something other than the
>>> 192MHz configuration by the firmware.
> 
> So you can use the early PCI hooks or even bash the register directly in
> your early bootup code. You won't be the only early boot console that
> does this sort of thing. There are even people bitbanging PCI I²C
> interfaces at boot time for such purpose.
> 
>> So, I think default uart_clock 192MHz setting is better than Darren's opinion.
> 
> It's certainly easier to maintain, but it would be good to know if the
> setting can be written or retrieved directly in the early console setup
> using the early PCI ops or similar.

OK, I'm not opposed to forcing everything to 192MHz, that would clean up
pch_uart.c quite a bit. I have heard different things about the
specification for this chipset. One statement was that 64MHz was the
maximum UART clock. Feng suggests that 192MHz is the recommended UART
clock. I need to dig up this spec and determine what it actually says.

I have V2 with Alan's feedback from 2/4 incorporated, but I'll hold off
unless people want to see it now. Seems like it will change a lot if we
force 192MHz everywhere.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
