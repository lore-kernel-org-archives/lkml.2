Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0HBP4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:56:49 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:64296 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835Ab0HBP4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:56:47 -0400
Date: Mon, 2 Aug 2010 17:56:42 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Mike Frysinger <vapier@gentoo.org>, Graf Yang <graf.yang@analog.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Barry Song <barry.song@analog.com>, Robin Getz <robin.getz@analog.com>,
        Yi Li <yi.li@analog.com>, Sonic Zhang <sonic.zhang@analog.com>,
        Jean Delvare <khali@linux-fr.org>, Cliff Cai <cliff.cai@analog.com>,
        Harald Krapfenbauer <Harald.Krapfenbauer@bluetechnix.at>,
        Tejun Heo <tj@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 0/6] Removing dead code
Message-ID: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!
       
        As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

        I've been running a check on the blackfin sourcetree for
config Items not defined in Kconfig and found many such cases. Sourcecode
blocks depending on these Items are not reachable from a vanilla
kernel -- dead code. I've seen such dead blocks made on purpose
e.g. while integrating new features into the kernel but generally
they're just useless.

        Each of the patches in this patchset removes on such dead
config Item, I'd be glad if you consider applying them. I've been
doing deeper analysis of such issues before and can do so again but
I'm not so sure they were fastly usefull.

There were many more dead flags in the vanilla kernel cause the config
options were only introduced into the blackfin.uclinux.org kernel. I
hope i just got patches for real problem flags[1]. Perhaps some
syncing here would do something good for the blackfin arch.

I wasn't able to build the kernel for blackfin, so be aware that this
patches might break the compiling process, but i don't think so cause
they (hopefully) are just removing dead code.

        Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

        Christian Dietrich

[0] http://vamos1.informatik.uni-erlangen.de/
[1] Dead Flags in vanilla kernel but not in blackfin.uclinux.org
    ## Blackfin -- blackfin.uclinux.org
    BFIN_SPI_ADC
    NET_DSA_KSZ8893M
    BFIN_TWI_LCD
    FB_BF537_LQ035
    FB_HITACHI_TX09
    INPUT_ADXL34X_SPI
    USB_NET2272
    SPI_BFIN_SPORT
    AD2S120X
    AD2S90
    INPUT_ADXL34X
    INPUT_ADXL34X_I2C
    INPUT_ADXL34X_SPI
    USB_SL811_BFIN_USE_VBUS
    JOYSTICK_AD7142
    AD7152
    SND_SOC_ADAU1361
    FB_BFIN_7393
    BACKLIGHT_ADP8870
    SND_SOC_ADAU1371
    AD7414
    SND_SOC_ADAU1761
    REGULATOR_AD5398
    AD7150
    AD7416

Christian Dietrich (6):
  arch/blackfin: Remove config HIGHMEM
  arch/blackfin: Remove dead CONFIG_BF535
  arch/blackfin: Remove CONFIG_MEM_GENERIC_BOARD
  arch/blackfin: Remove dead CONFIG_REGULATOR_ADP_SWITCH
  arch/blackfin: Remove dead CONFIG_ADF702X
  arch/blackfin: Removing dead SND_BLACKFIN_AD183X

 arch/blackfin/Kconfig                       |    5 -
 arch/blackfin/include/asm/mem_init.h        |   18 ---
 arch/blackfin/include/asm/traps.h           |    2 +-
 arch/blackfin/kernel/traps.c                |   11 +--
 arch/blackfin/mach-bf527/boards/cm_bf527.c  |   18 ---
 arch/blackfin/mach-bf527/boards/ezkit.c     |   18 ---
 arch/blackfin/mach-bf533/boards/H8606.c     |   17 ---
 arch/blackfin/mach-bf533/boards/cm_bf533.c  |   17 ---
 arch/blackfin/mach-bf533/boards/ezkit.c     |   16 ---
 arch/blackfin/mach-bf533/boards/stamp.c     |   17 ---
 arch/blackfin/mach-bf537/boards/cm_bf537e.c |   17 ---
 arch/blackfin/mach-bf537/boards/cm_bf537u.c |   17 ---
 arch/blackfin/mach-bf537/boards/pnav10.c    |   18 ---
 arch/blackfin/mach-bf537/boards/stamp.c     |  162 ---------------------------
 arch/blackfin/mach-bf537/boards/tcm_bf537.c |   17 ---
 arch/blackfin/mach-bf548/boards/ezkit.c     |   18 ---
 arch/blackfin/mach-bf561/boards/cm_bf561.c  |   16 ---
 arch/blackfin/mach-bf561/boards/ezkit.c     |   18 ---
 arch/blackfin/mm/init.c                     |    3 -
 19 files changed, 2 insertions(+), 423 deletions(-)

