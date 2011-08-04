Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab1HDUyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 16:54:11 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:12164 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab1HDUyC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 16:54:02 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1312491240!14338257!2
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Wim Van Sebroeck <wim@iguana.be>
CC: Mika Westerberg <mika.westerberg@iki.fi>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>
Date: Thu, 4 Aug 2011 15:53:08 -0500
Subject: RE: [RFC PATCH v2] watchdog: ep93xx: Use the WatchDog Timer Driver
	Core.
Thread-Topic: [RFC PATCH v2] watchdog: ep93xx: Use the WatchDog Timer Driver
	Core.
Thread-Index: AcxS4b9GPVLKbhgQSfKo1MsvgbqisgAAz3hg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3882B8D1F@AUSP01VMBX24.collaborationhost.net>
References: <201108031021.26620.hartleys@visionengravers.com>
 <20110804181244.GA2445@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F001F3882B8C44@AUSP01VMBX24.collaborationhost.net>
 <20110804200439.GU4227@infomag.iguana.be>
In-Reply-To: <20110804200439.GU4227@infomag.iguana.be>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 04, 2011 1:05 PM, Wim Van Sebroeck wrote:
>>> BTW, now that the driver uses watchdog core should we also select
>>> WATCHDOG_CORE in the Kconfig? If it is not enabled we get:
>>>
>>> drivers/built-in.o: In function `ep93xx_wdt_init':
>>> clkdev.c:(.init.text+0x2bd8): undefined reference to
>>> `watchdog_register_device'
>>> make: *** [.tmp_vmlinux1] Error 1
>> 
>> Of course.
>> 
>> I wasn't sure how Wim wanted to handle this.  I see two ways of doing it
>> in the Kconfig.
>> 
>> 1) Each driver config option has a select WATCHDOG_CORE if it is required.
>> 
>>    Pro: all the watchdog drivers (that are available) are displayed
>>    Con: each driver needs to add the select if needed
>>    Side-effect: the WATCHDOG_CORE option could (should) be a hidden option
>> 
>> 2) Separate the watchdog drivers into groups that need the WATCHDOG_CORE
>>    and those that don't then put a if WATCHDOG_CORE/endif around the ones
>>    that need it.
>> 
>>    Pro: keeps the Kconfig clean
>>    Con: the drivers that use WATCHDOG_CORE are not displayed unless the
>>         option is selected
>>    Con: defconfigs probably will need to be updated to select WATCHDOG_CORE
>> 
>> Wim, do you have any opinion on this?
>
> I allready discussed this with Wolfram a few weeks ago. Since we don't want
> defconfigs to change, the best option is to:
> 1) use 'select WATCHDOG_CORE' during conversion of the drivers.
> 2) remove CONFIG_WATCHDOG_CORE and replace it by CONFIG_WATCHDOG in a later
>    stage so that the core API becomes the user-space layer for all watchdog
>    device drivers.This so that we can support multiple watchdogs in the
>    future and to make sure that we keep having a consistent user-space
>    interface.

OK.  I'll repost the ep93xx conversion and include the Kconfig change.

Thanks!
Hartley