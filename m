Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1IFUZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 16:25:26 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:18349 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab1IFUZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 16:25:22 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-127.messagelabs.com!1315340250!30708436!439
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "art@ified.ca" <art@ified.ca>, "jslaby@suse.cz" <jslaby@suse.cz>
Date: Tue, 6 Sep 2011 15:23:37 -0500
Subject: RE: [PATCH] vt_ioctl.c: fix compile error with pm_set_vt_switch()
Thread-Topic: [PATCH] vt_ioctl.c: fix compile error with pm_set_vt_switch()
Thread-Index: Acxsy2dBPfFut1NVTySUHbFnhhR0lAABxzrQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F39D748C13@AUSP01VMBX24.collaborationhost.net>
References: <201109021402.42503.hartleys@visionengravers.com>
 <201109051654.28682.arnd@arndb.de>
 <ADE657CA350FB648AAC2C43247A983F001F39D748B6E@AUSP01VMBX24.collaborationhost.net>
 <6392794.F5gNpf4v9p@wuerfel>
In-Reply-To: <6392794.F5gNpf4v9p@wuerfel>
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

On Tuesday, September 06, 2011 12:29 PM, Arnd Bergmann wrote:
> On Tuesday 06 September 2011 13:26:12 H Hartley Sweeten wrote:
>> Your patch below does appear to fix the problem.
>> 
>> Tested-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> 
>> 
>> There is still a bit of #if ugliness with the pm_{prepare,restore}_console.
>> 
>> The source file kernel/power/console.c is compiled when CONFIG_PM_SLEEP is
>> enabled.  But that file ends up empty if CONFIG_VT and CONFIG_VT_CONSOLE are
>> not defined.
>> 
>> I wonder if it would be cleaner to make a new entry in kernel/power/Kconfig:
>> 
>> config PM_SLEEP_CONSOLE
>>         def_bool y
>>         depends on PM_SLEEP && VT && VT_CONSOLE
>> 
>> Then use that config option in the Makefile and in suspend.h.
>
> Yes, that would be cleaner. I would probably move it to drivers/tty/vt
> in the same step and name the option VT_CONSOLE_SLEEP.

Ok.

> Do you want to send a patch?

Will do in just a minute.

> Thanks for testing!

Not a problem!

Regards,
Hartley
