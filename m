Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab2JUMVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 08:21:19 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:46568 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab2JUMVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 08:21:17 -0400
Message-ID: <5083E887.9040905@free-electrons.com>
Date: Sun, 21 Oct 2012 14:20:23 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Ike Pan <ike.pan@canonical.com>, Nadav Haklai <nadavh@marvell.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Mike Turquette <mturquette@linaro.org>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>, Li Li <li.li@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jon Masters <jcm@redhat.com>,
        devicetree-discuss@lists.ozlabs.org, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH V3 0/3]  Add clock framework for armada 370/XP
References: <1350303499-30868-1-git-send-email-gregory.clement@free-electrons.com> <20121017153925.GR20922@titan.lakedaemon.net>
In-Reply-To: <20121017153925.GR20922@titan.lakedaemon.net>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 05:39 PM, Jason Cooper wrote:
> Mike,
> 
> On Mon, Oct 15, 2012 at 02:18:16PM +0200, Gregory CLEMENT wrote:
>> Hello Mike,
>>
>> The v3.7-rc1 was released yesterday. So here it is the updated version
>> of my patch set. The rebase was flawless. An I have just fixed a typo
>> in the device tree and warnings from checkpatch. I built and test it
>> for the Armada 370 and Armada XP evaluation board.
>>
>> The purpose of this patch set is to add support for clock framework
>> for Armada 370 and Armada XP SoCs. All the support is done under the
>> directory drivers/clk/mvebu/ as the support for other mvebu SoCs was
>> in mind during the writing of the code.
>>
>> Two kinds of clocks are added:
>>
>> - The CPU clocks are only for Armada XP (which is multi-core)
>>
>> - The core clocks are clocks which have their rate fixed during
>>   reset.
>>
>> Many thanks to Thomas Petazzoni and Sebastian Hesselbarth for their
>> review and feedback. The device tree bindings were really improved
>> with the advices of Sebastian.
>>
>> Changelog:
>> V2 -> V3:
>> - Rebased on top of v3.7-rc1
>> - Fixed a typo in device trees
>> - Fixed warning from checkpatch
>>
>> V1 -> V2:
>>
>> - Improved the spelling and the wording of the documentation and the
>>   1st commit log
>> - Removed the "end_of_list" name which are unused here.
>> - Fix the cpu clock by using of_clk_src_onecell_get in the same way it
>>   was used for the core clocks
>>
>> Regards,
>>
>>
>> Gregory CLEMENT (3):
>>   clk: mvebu: add armada-370-xp specific clocks
>>   clk: armada-370-xp: add support for clock framework
>>   clocksource: time-armada-370-xp converted to clk framework
>>
>>  .../devicetree/bindings/clock/mvebu-core-clock.txt |   40 +++
>>  .../devicetree/bindings/clock/mvebu-cpu-clock.txt  |   21 ++
>>  arch/arm/boot/dts/armada-370-db.dts                |    4 -
>>  arch/arm/boot/dts/armada-370-xp.dtsi               |    1 +
>>  arch/arm/boot/dts/armada-370.dtsi                  |   12 +
>>  arch/arm/boot/dts/armada-xp.dtsi                   |   48 +++
>>  arch/arm/mach-mvebu/Kconfig                        |    5 +
>>  arch/arm/mach-mvebu/armada-370-xp.c                |    8 +-
>>  arch/arm/mach-mvebu/common.h                       |    1 +
>>  drivers/clk/Makefile                               |    1 +
>>  drivers/clk/mvebu/Makefile                         |    2 +
>>  drivers/clk/mvebu/clk-core.c                       |  312 ++++++++++++++++++++
>>  drivers/clk/mvebu/clk-core.h                       |   19 ++
>>  drivers/clk/mvebu/clk-cpu.c                        |  155 ++++++++++
>>  drivers/clk/mvebu/clk-cpu.h                        |   19 ++
>>  drivers/clk/mvebu/clk.c                            |   36 +++
>>  drivers/clocksource/time-armada-370-xp.c           |   11 +-
>>  17 files changed, 685 insertions(+), 10 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/clock/mvebu-core-clock.txt
>>  create mode 100644 Documentation/devicetree/bindings/clock/mvebu-cpu-clock.txt
>>  create mode 100644 drivers/clk/mvebu/Makefile
>>  create mode 100644 drivers/clk/mvebu/clk-core.c
>>  create mode 100644 drivers/clk/mvebu/clk-core.h
>>  create mode 100644 drivers/clk/mvebu/clk-cpu.c
>>  create mode 100644 drivers/clk/mvebu/clk-cpu.h
>>  create mode 100644 drivers/clk/mvebu/clk.c
> 
> Would it be okay if we took this through the mvebu tree?  It looks like
> the only potential merge conflict we would have would be in
> drivers/clk/Makefile.  It would make dependency tracking easier.
> 

It will also be easier for me if it was possible, because I have
patch series awaiting which will depend on the support of the
clock framework for mvebu.

> Otherwise is fine as well, just let me know which you prefer.
> 
> Assuming, of course, everything looks good to you.
> 
> thx,
> 
> Jason.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
