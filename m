Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab0GPQmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:42:25 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34503 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab0GPQmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:42:24 -0400
Message-ID: <4C408BEF.1060302@canonical.com>
Date: Fri, 16 Jul 2010 17:42:23 +0100
From: Lee Jones <lee.jones@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Milton Miller <miltonm@bga.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Martin Michlmayr <tbm@cyrius.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Stop ARM boards crashing when CUPS is loaded -	2.6.35-rc5
References: <4C3C72C6.4000005@canonical.com>	<20100715130214.4c9303b2.akpm@linux-foundation.org>	<20100715200618.GA6773@n2100.arm.linux.org.uk>	<4C40218A.4090806@canonical.com>	<20100716092018.GB16995@n2100.arm.linux.org.uk> <miltonm-arm-parport-1@bga.com>
In-Reply-To: <miltonm-arm-parport-1@bga.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/10 17:23, Milton Miller wrote:
> On Fri Jul 16 2010 about 05:33:06 EST,  Lee Jones wrote:
>>> The best solution is probably for the parport code to go through a
>>> modernisation cycle like the serial code did, essentially using
>>> platform devices to pass the base addresses. This would make the
>>> driver more portable, and eliminates this problem entirely (because
>>> platforms which don't have parports won't register the platform device(s)
>>> necessary for parport to even probe illegal addresses.)
>>
>> This sounds brilliant - when are you going to start? </kidding>
> 
> It has a long time ago ...
> 
> drivers/parport/parport_pc.c calls parport_pc_find_nonpci_ports,
> which is in asm/parport.h

I'm not entirely sure what you're trying to say here?

How does that help with the platformisation of the driver?

>> In all seriousness, do you think anyone is likely to undertake this
>> work anytime soon? I am seeing this problem in a distribution which
>> is due for release in October. I have no problem implementing a config
>> change in the meantime, but as you say, a more _correct_ and portable
>> solution should be sought.
> 
> Why not replace the arm asm/parport.h with asm-generic/parport.h which
> already has a check for CONFIG_ISA, which appears to only be selected
> on a few ARM platforms?

static int __devinit parport_pc_find_isa_ports(int autoirq, int autodma);
static int __devinit parport_pc_find_nonpci_ports(int autoirq, int autodma)
{
#ifdef CONFIG_ISA
	return parport_pc_find_isa_ports(autoirq, autodma);
#else
	return 0;
#endif
}

That's perfect! 

This would work a treat.

Surely this #ifdef should be in all the parport.h files which call
parport_pc_find_isa_ports?
