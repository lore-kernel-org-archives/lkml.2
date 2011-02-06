Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1BFEnU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 23:43:20 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40098 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab1BFEnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 23:43:19 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 5 Feb 2011 21:42:57 -0700
X-Google-Sender-Auth: 0a_2SFbCYp-nqukrG431HZfr31c
Message-ID: <AANLkTikLvO0Y44nCxEfCsNxU-Na+PzcLXZUjOsMUM1_A@mail.gmail.com>
Subject: Device Tree on ARM status report
To: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        linaro-dev <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

With several more engineers working on ARM device tree support, I'm
going to start collecting the status of all the work that is going on
(and I know about) and posting it in a regular status report,
hopefully weekly, for the next few months until the all of the major
features are implemented and working on several arm platforms.  I'll
try to use roughly the following format:

1) latest news and status updates
2) list of tasks with current state and who is responsible for them in
the same format as Launchpad blueprint whiteboards[1]. (In fact, I'll
probably move much, if not all, of this into Launchpad anyway, in
which case these emails will be a summary of all the blueprints. not
all of us work with Linaro, but it is a useful method for tracking
progress).
3) List of active engineers

[1] https://wiki.linaro.org/Process/Blueprints

Please read through and reply with comments/corrections.  Feel free to
add or remove tasks from the list I've given below.

Thanks,
g.


1 - Latest news
---------------
- devicetree/arm on git://git.secretlab.ca/git/linux-2.6 has
everything needed to turn on basic device tree support for any
platform.
- Similarly, u-boot just needs to have the CONFIG_OF_LIBFDT defined to
turn on device tree support.
- IRQ handling is still a problem and only one interrupt controller
can be supported at the moment, but Lennert is working on a solution.
- I've posted a patch that will allow dt and non-dt device
registration to co-exist peacefully by snooping platform device
registrations.  I could use some feedback and testing.
- hopefully the basic dt support can be merged into Nicolas' tree this
week if I get a cleaned up branch pushed out for him quickly.

2 - Task status
---------------
Core infrastructure:
[glikely] basic infrastructure to enable dt: DONE
[r-herring] Allow dtb to be located anywhere in RAM: DONE
[bones] Debug dtb corruption during init: INPROGRESS
[glikely] OF clock bindings: INPROGRESS
[glikely] Correctly handle dtb reserved memory sections: TODO
[glikely] merge basic dt support into nico's tree: TODO
[buytenh] virtual irq infrastructure: INPROGRESS
Remove u-boot restriction of first 16k for dtb: TODO
add processing of dtb reserved regions: TODO
verify dt gpio infrastructure works: TODO
[glikely] Remove early validation of machine type number: INPROGRESS

imx51 tasks
enable dtb support in u-boot: TODO
enable basic kernel dtb support: TODO
enable registration of devices form dt: TODO
... add more details here, specific devices, etc...

OMAP tasks
[buytenh] enable dtb support in u-boot: DONE
[buytenh] enable basic kernel dtb support on OMAP3: INPROGRESS
enable basic kernel dtb support on OMAP4: TODO
[buytenh] enable registration of devices form dt: TODO
... add more details here, specific devices, etc...

qemu support tasks:
Cleanup and mainline arm dtb support patches: TODO
configure qemu emulation from dtb (like microblaze): TODO
... add more details here, specific devices, etc...

Samsung S5PV310 tasks:
[thomas-ab] enable dtb support in u-boot: DONE?
[thomas-ab] enable basic kernel dtb support on S5PV310: DONE?
[thomas-ab] make gpio driver dt-aware: TODO
[thomas-ab] Register devices from dt: INPROGRESS
... add more details here, specific devices, etc...

Tegra tasks:
[glikely] enable dtb support in u-boot: DONE
[glikely] enable basic kernel dtb support on Harmony board: DONE
[glikely] probe irq controllers from device tree: TODO
[glikely] make gpio controller driver dt aware: TODO
[glikely] register devices from dt: INPROGRESS
... add more details here, specific devices, etc...

Versatile tasks:
enable dtb support in u-boot: TODO
[jk-ozlabs] enable basic kernel dtb support on versatile: DONE
[jk-ozlabs] probe clocks from dt: DONE
[jk-ozlabs] register devices from dt: DONE
decode irqs from dt: TODO

Versatile express tasks:
[lorenzo-pieralisi] enable dtb support in u-boot: DONE?
[lorenzo-pieralisi] enable basic kernel dtb support on versatile express: DONE
[lorenzo-pieralisi] probe clocks from dt: DONE?
[lorenzo-pieralisi] probe irq controllers from device tree: TODO
[lorenzo-pieralisi] register devices from dt: DONE?
... add more details here, specific devices, etc...

Xilinx arm tasks:
[john linn] enable dtb support in u-boot: TODO?
[john linn] enable basic kernel dtb support on xilinx arm devboard: DONE
[john linn] probe irq controllers from device tree: TODO
[john linn] register devices from dt: INPROGRESS?
... add more details here, specific devices, etc...

A15 tasks:
nothing yet

As far as I know, Rob's dtb anywhere patch is pending mainline, but
I'll carry it in devicetree/arm until it is merged.  Same for the
patch that eliminates early vetting of the machine type number.

Active engineering list:
Thomas Abraham [thomas-ab] Samsung
Lennert Buytenhek [no launchpad id] core infrastructure and OMAP
Andy Green [] OMAP
Shawn Guo [] imx51
Rob Herring [r-herring] clock bindings, boot code
Jason Hui [] imx51
Jeremy Kerr [jk-ozlabs] clock bindings, imx51, versatile
John Linn [no launchpad id] Xilinx ARM dev board
Grant Likely [glikely] core infrastructure, tegra, versatile
Lorenzo Pieralisi [lorenzo-pieralisi] versatile express
