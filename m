Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab1HDS3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 14:29:19 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:41206 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab1HDS3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 14:29:14 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-160.messagelabs.com!1312482549!30663492!20
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.180]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "wim@iguana.be" <wim@iguana.be>,
        "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>
Date: Thu, 4 Aug 2011 13:29:00 -0500
Subject: RE: [RFC PATCH v2] watchdog: ep93xx: Use the WatchDog Timer Driver
 Core.
Thread-Topic: [RFC PATCH v2] watchdog: ep93xx: Use the WatchDog Timer Driver
 Core.
Thread-Index: AcxS0iTjjTSXaM2lTpa8wG3wy3yZzAAAMweA
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3882B8C44@AUSP01VMBX24.collaborationhost.net>
References: <201108031021.26620.hartleys@visionengravers.com>
 <20110804181244.GA2445@mwesterb-mobl.ger.corp.intel.com>
In-Reply-To: <20110804181244.GA2445@mwesterb-mobl.ger.corp.intel.com>
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

On Thursday, August 04, 2011 11:13 AM, Mika Westerberg wrote:
> On Wed, Aug 03, 2011 at 10:21:26AM -0700, H Hartley Sweeten wrote:
>> Convert the ep93xx watchdog driver to using the WatchDog Timer Driver Core.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Wim Van Sebroeck <wim@iguana.be>
>> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
>
> Tested-by: Mika Westerberg <mika.westerberg@iki.fi>

Thanks!

>
> BTW, now that the driver uses watchdog core should we also select
> WATCHDOG_CORE in the Kconfig? If it is not enabled we get:
>
> drivers/built-in.o: In function `ep93xx_wdt_init':
> clkdev.c:(.init.text+0x2bd8): undefined reference to
> `watchdog_register_device'
> make: *** [.tmp_vmlinux1] Error 1

Of course.

I wasn't sure how Wim wanted to handle this.  I see two ways of doing it
in the Kconfig.

1) Each driver config option has a select WATCHDOG_CORE if it is required.

   Pro: all the watchdog drivers (that are available) are displayed
   Con: each driver needs to add the select if needed
   Side-effect: the WATCHDOG_CORE option could (should) be a hidden option

2) Separate the watchdog drivers into groups that need the WATCHDOG_CORE
   and those that don't then put a if WATCHDOG_CORE/endif around the ones
   that need it.

   Pro: keeps the Kconfig clean
   Con: the drivers that use WATCHDOG_CORE are not displayed unless the
        option is selected
   Con: defconfigs probably will need to be updated to select WATCHDOG_CORE

Wim, do you have any opinion on this?

> Other than that, you can also add my
>
> Reviewed-by: Mika Westerberg <mika.westerberg@iki.fi>
>
> if you like.

Thanks,
Hartley
