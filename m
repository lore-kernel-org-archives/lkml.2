Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423046Ab2LGRI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 12:08:26 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58284 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422888Ab2LGRIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 12:08:24 -0500
Message-ID: <50C22284.8050704@wwwdotorg.org>
Date: Fri, 07 Dec 2012 10:08:20 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Igor Grinberg <grinberg@compulab.co.il>
CC: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, "Hunter, Jon" <jon-hunter@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH V3 11/11] ARM: delete struct sys_timer
References: <1353349867-28494-1-git-send-email-swarren@wwwdotorg.org> <1353349867-28494-12-git-send-email-swarren@wwwdotorg.org> <50C1BC10.8000506@compulab.co.il>
In-Reply-To: <50C1BC10.8000506@compulab.co.il>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 02:51 AM, Igor Grinberg wrote:
> Hi Stephen,
> 
> I've only now bumped into the patchset (working the back log on linux-arm).
> Sorry for late reply, but I guess you should have Cc'd the relevant
> mailing lists with such changes.
> Cc'd now.

Perhaps. There's a trade-off with spamming tens of subarch lists though,
and the OMAP maintainer and LAKML were CC'd.

> On 11/19/12 20:31, Stephen Warren wrote:
>> Now that the only field in struct sys_timer is .init, delete the struct,
>> and replace the machine descriptor .timer field with the initialization
>> function itself.
>>
>> This will enable moving timer drivers into drivers/clocksource without
>> having to place a public prototype of each struct sys_timer object into
>> include/linux; the intent is to create a single of_clocksource_init()
>> function that determines which timer driver to initialize by scanning
>> the device dtree, much like the proposed irqchip_init() at:
>> http://www.spinics.net/lists/arm-kernel/msg203686.html
...
>> The patch is very large, so I've trimmed it for the mailing list, leaving
>> only the core ARM changes, changes outside arch/arm, and a single machine
>> example. The full series can be found at:
>>
>> git://nv-tegra.nvidia.com/user/swarren/linux-2.6 arm_timer_rework
...
> I've looked at the omap2+ changes and I think OMAP4 and 5 got messed up a bit...
> the below (compile tested on omap2plus only) should be applied:

Thanks; your patch looks correct. I'll fold it into my series.
