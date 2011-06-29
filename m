Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1F2Clh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 22:41:37 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62829 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab1F2Cld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 22:41:33 -0400
Message-ID: <4E0A90D9.1060601@gmail.com>
Date: Tue, 28 Jun 2011 21:41:29 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, nico@fluxnic.net
Subject: Re: [PATCH 2/4] ARM: remove unnecessary mach/hardware.h includes
References: <1309301859-17651-1-git-send-email-robherring2@gmail.com> <1309301859-17651-3-git-send-email-robherring2@gmail.com> <20110628232429.GI21898@n2100.arm.linux.org.uk>
In-Reply-To: <20110628232429.GI21898@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2011 06:24 PM, Russell King - ARM Linux wrote:
> On Tue, Jun 28, 2011 at 05:57:37PM -0500, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Remove some includes of mach/hardware.h which are not needed. hardware.h will
>> be removed completely for tegra and cns3xxx in follow on patch.
> 
> At least this one is incorrect:
> 
> arch/arm/mach-rpc/include/mach/hardware.h:#define IO_EC_MEMC_BASE              0x80000000
> arch/arm/kernel/ecard.c:                    address = IO_EC_MEMC_BASE + (slot << 12);
> 
> That's just one of the defines that ecard.c uses from mach/hardare.h.
> 
It happens to still compile, so it's getting included thru another
include. I see these options:

-Revert this change. RPC is not going to be built in a multi-platform
kernel anyway. Leaving it could affect how include paths get setup for
multi-platform builds.
-Move ecard.c into mach-rpc. It doesn't appear to be used by anything else.

I'll do the 1st option for now.

Rob
