Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2HBUUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 16:20:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:55032 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753727Ab2HBUUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 16:20:49 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX197tzcQyhZ7c2hwoFngy2rMJ3azTOv0RkJ28YqnYq
	4JAldgDBFyKwEs
Message-ID: <501AE10E.6080606@gmx.net>
Date: Thu, 02 Aug 2012 22:20:30 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120623 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Borislav Petkov <bp@alien8.de>, bhelgaas@google.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH V3 0/3] PNP: Allow PNP resources to be disabled (interface)
References: <50158321.4030007@gmx.net> <50158FA9.7080700@gmx.net> <20120730082820.GA32745@liondog.tnic> <201208022209.16015.rjw@sisk.pl>
In-Reply-To: <201208022209.16015.rjw@sisk.pl>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/12 22:09, Rafael J. Wysocki wrote:
> On Monday, July 30, 2012, Borislav Petkov wrote:
>> On Sun, Jul 29, 2012 at 09:31:53PM +0200, Witold Szczeponik wrote:
>>> the aim is to select a PNP ACPI option where resources can be disabled
>>> (or are not needed).  E.g., the parallel port of the 600E can be used
>>> with and without IRQ lines.  The means to allow for this is to use the
>>> sysfs interface to select disabled resources (just like any other 
>>> resource value).  In https://lkml.org/lkml/2011/7/3/41, I used the 
>>> following example:
>>>
>>>   echo disable > /sys/bus/pnp/devices/$device/resources
>>>   echo clear > /sys/bus/pnp/devices/$device/resources
>>>   echo set irq disabled > /sys/bus/pnp/devices/$device/resources
>>>   echo fill > /sys/bus/pnp/devices/$device/resources
>>>   echo activate > /sys/bus/pnp/devices/$device/resources
>>>
>>> The third line is made possible by the patch series.  All other
>>> lines are already implemented.
>>
>> Shouldn't this be rather "disable_irq" or something which is a single
>> word and thus would simplify parsing a lot?
> 
> Or just "irq", which isn't going to be confused with anything else it seems.
> 
> Thanks,
> Rafael
> 

Hi Rafael, 

the code in "drivers/pnp/interface.c" implements a (non-trivial) interface
which accepts the keywords "disable", "activate", "fill", "auto", "clear",
and "get" as simple, one word commands.  The remaining "set" command is
more complex, for it determines which resource is to be set ("io", "mem",
"irq", "dma", and "bus"), followed by the actual value(s) of this resource
(e.g., "0x0200-0x021f", or "7"). 

The patch series allows to use the term "disabled" or "<none>" as a 
resource value (c.f. my example above) when needed (c.f. my motivation for
the patch series). 

We could, of course, change the parser in "interface.c", but this would 
change the ABI, I am afraid.  Something that I'd rather not do... 

I hope, this makes the scope of the patch series clear(er).  

--- Witold
