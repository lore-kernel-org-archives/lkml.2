Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1I1TdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 15:33:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:59745 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab1I1TdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 15:33:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="57660614"
Message-ID: <4E837679.4040904@linux.intel.com>
Date: Wed, 28 Sep 2011 12:33:13 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "lkml," <linux-kernel@vger.kernel.org>,
        Denis Turischev <denis@compulab.co.il>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: Serial issues with EG20T (Topcliff) PCH uarts
References: <4E820FA8.8050604@linux.intel.com> <20110927225722.54936878@lxorguk.ukuu.org.uk> <4E835EBC.3080604@linux.intel.com> <CAErSpo6XcctMq1uM2No8Z=1_sgBxBhNQ3os3dU=aHCsPxrpwBg@mail.gmail.com>
In-Reply-To: <CAErSpo6XcctMq1uM2No8Z=1_sgBxBhNQ3os3dU=aHCsPxrpwBg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/28/2011 12:14 PM, Bjorn Helgaas wrote:
> On Wed, Sep 28, 2011 at 11:51 AM, Darren Hart <dvhart@linux.intel.com> wrote:
>>
>> Hi Alan,
>>
>> Thanks for the suggestions. Still not working, details follow.
>>
>> On 09/27/2011 02:57 PM, Alan Cox wrote:
>>>
>>> No idea for syslinux.
>>
>> Doesn't like 9600 either.
> 
> Are you using "serial 1" or similar for the syslinux config?  I don't
> know how syslinux learns the (port -> address) mapping, but
> doc/syslinux.txt says you can also specify the address directly, e.g.,
> "serial 0xb060 9600".

I was using 0,1,2,3, with no output. Using serial 0xb060 as you describe
results in a single char appearing in minicom when syslinux tries to
output to the serial port.

> 
> I'm not familiar with the EG20T hardware, but all the code in
> drivers/tty/serial/pch_uart.c makes me wonder how 16550-compatible
> those things really are.  If the EG20T UARTs require special tickling,
> syslinux isn't likely to know how to do that.

I the results of the test above support this concern. Syslinux
apparently couldn't find the ports by itself. Specifying the IO address
directly gets it to the right place, but something appears to not be
initialized.

I wonder if this could be fixed with some help from the firmware.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
