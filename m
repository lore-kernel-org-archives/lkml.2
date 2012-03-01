Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab2CAAtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:49:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:14866 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab2CAAte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:49:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="113251415"
Message-ID: <4F4EC73E.40209@linux.intel.com>
Date: Wed, 29 Feb 2012 16:47:58 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Alan Cox <alan@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 0/4 V2] pch_uart: Cleanups, board quirks, and user uartclk
 parameter
References: <cover.1330539597.git.dvhart@linux.intel.com> <CANKRQnhFVJAUHAg0qTPFJ8L0L_+-_q4ZtfOnV0wSR1Xa6Mn8UQ@mail.gmail.com>
In-Reply-To: <CANKRQnhFVJAUHAg0qTPFJ8L0L_+-_q4ZtfOnV0wSR1Xa6Mn8UQ@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/29/2012 04:38 PM, Tomoya MORINAGA wrote:
> Hi
> 
> Darren's patch series, I think OK.
> However, need to proceed next step.

Great, Greg are you happy with these as they are?

> 
> As I said before,
> internal clock(USB_48MHz) should be used than external clock(UART_CLK)
> as default setting.
> --Reasons
>   - Users don't always use 1.8432MHz as UART_CLK.
>     So,  In case of using except 1.8432MHz,
>     the user needs to change both pch_phub and pch_uart setting (It's
> bother things).
>   - High baud rate can't be used more than 115Kbps
> 
> I think there is no merit to use UART_CLK.
> 
> ---Merit to use 192MHz
>   - Users don't have to care both pch_phub and pch_uart clock setting.
>   - High baud rate can be supported

I have no objection to this provided the early serial console can work
without additional patches. So the question now is, how do we force the
192MHz clock setting BEFORE the pch_phub code runs?


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
