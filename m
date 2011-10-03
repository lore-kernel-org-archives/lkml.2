Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab1JCJTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:19:46 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:50046 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413Ab1JCJTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:19:39 -0400
Message-ID: <4E897E22.2000703@ti.com>
Date: Mon, 03 Oct 2011 14:49:30 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 26/30] ARM: omap: add board autoselection
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-27-git-send-email-arnd@arndb.de> <4E8947F7.2070108@ti.com> <3656685.pM1zNST8gQ@wuerfel>
In-Reply-To: <3656685.pM1zNST8gQ@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 October 2011 02:41 PM, Arnd Bergmann wrote:
> On Monday 03 October 2011 10:58:23 Santosh Shilimkar wrote:
>>> +config MACH_OMAP_AUTO_BOARD
>>> +     def_bool y
>>> +     depends on !MACH_OMAP2_TUSB6010
>>> +     depends on !MACH_OMAP_H4
>>> +     depends on !MACH_OMAP_APOLLON
>>> +     depends on !MACH_OMAP_APOLLON
>>> +     depends on !MACH_OMAP_2430SDP
>>> +     depends on !MACH_OMAP3_BEAGLE
>>> +     depends on !MACH_DEVKIT8000
>>> +     depends on !MACH_OMAP_LDP
>>> +     depends on !MACH_OMAP3530_LV_SOM
>>> +     depends on !MACH_OMAP3_TORPEDO
>>> +     depends on !MACH_OVERO
>>> +     depends on !MACH_OMAP3EVM
>>> +     depends on !MACH_OMAP3517EVM
>>> +     depends on !MACH_CRANEBOARD
>>> +     depends on !MACH_OMAP3_PANDORA
>>> +     depends on !MACH_OMAP3_TOUCHBOOK
>>> +     depends on !MACH_NOKIA_N8X0
>>> +     depends on !MACH_NOKIA_RM680
>>> +     depends on !MACH_NOKIA_RX51
>>> +     depends on !MACH_OMAP_ZOOM2
>>> +     depends on !MACH_OMAP_ZOOM3
>>> +     depends on !MACH_CM_T35
>>> +     depends on !MACH_CM_T3517
>>> +     depends on !MACH_IGEP0020
>>> +     depends on !MACH_IGEP0030
>>> +     depends on !MACH_SBC3530
>>> +     depends on !MACH_OMAP_3630SDP
>>> +     depends on !MACH_TI8168EVM
>>> +     depends on !MACH_OMAP4_PANDA
>> Do we need all above 'depends on *' ?
>> Even if they get selected for one of the below
>> ARCH along with default machine, build should be happy.
>> Right ?
> 
> I'm not too happy with having to maintain a list for each subarchitecture,
> when each one has the same problem. In general, I would really like to have
> the flexibility to disable all but any one board, which requires either
> maintaining a list like the above, or expressing the same like
> 
Ok.

> config MACH_OMAP_AUTO_BOARD
> 	 def_bool y
>        depends on !MACH_OMAP_BOARD_SELECTED
>        select MACH_OMAP_GENERIC if ARCH_OMAP2
>        select MACH_OMAP_3430SDP if ARCH_OMAP3 && !ARCH_OMAP2
>        select MACH_OMAP_4430SDP if ARCH_OMAP4 && !ARCH_OMAP3 && !ARCH_OMAP2
> 
> and adding a 'select MACH_OMAP_BOARD_SELECTED' for each one. Slightly more
> to write but perhaps a little less error-prone.
> 
> In the long run, I'd hope we can just get rid of these for subarchitectures
> that support device tree probing and make the device tree based machine
> description unconditional.
> 
I see your point. Sounds a good idea to me.

Regards
Santosh
