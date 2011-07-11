Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab1GKPcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 11:32:08 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38471 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1GKPcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:32:06 -0400
Message-ID: <4E1B176E.3030503@gmail.com>
Date: Mon, 11 Jul 2011 10:31:58 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, nico@fluxnic.net,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 0/6] ARM: make mach/hardware.h optional
References: <1309366019-24379-1-git-send-email-robherring2@gmail.com> <201107021124.46953.arnd@arndb.de>
In-Reply-To: <201107021124.46953.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On 07/02/2011 04:24 AM, Arnd Bergmann wrote:
> On Wednesday 29 June 2011 18:46:53 Rob Herring wrote:
>>
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Currently, all ARM platforms must have a mach/hardware.h include. This is
>> because it is ultimately included by linux/pci.h which is included in many
>> places even for !CONFIG_PCI.
>>
>> This could be fixed simply with an ifdef around the include of mach/hardware.h
>> in asm/pci.h. However, in the interest of fixing this for single kernel
>> binary builds, this series removes the include of mach/hardware.h outside of
>> mach-* and plat-*. What's used from hardware.h is a couple of PCI defines. 
>> Converting them to variables allows each platform to set the values as needed.
>>
>> This does not address the inclusion of mach/hardware.h under drivers/*. This
>> appears to be mostly older platforms. There could also be some indirect
>> inclusions from other mach/* headers.
>>
> 
> Hi Rob,
> 
> This is very good work, I really like it. I've mentioned one idea for
> an improvement in patch 5, which you can still integrate, but otherwise
> 
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> 
> for the whole series.
> 

I have an updated version ready to send out. Will you take this in your
tree including the 1st patch for pci flags functions? Also, what about
the powerpc conversion to generic pci flags?

Rob
