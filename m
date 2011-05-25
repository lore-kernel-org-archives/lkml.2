Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1EYVKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:10:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38262 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab1EYVKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:10:21 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1105241435550.3207@xanadu.home>
References: <BANLkTiknh4nCviohecbcJEiWnSW-JdMxDw@mail.gmail.com> <alpine.LFD.2.00.1105241435550.3207@xanadu.home>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 25 May 2011 15:10:00 -0600
X-Google-Sender-Auth: 0GYCmdGjpcelrl4jgUW36_Y--lQ
Message-ID: <BANLkTi=hCpCbNzi1ZiKmGnbhmCG2Ce=EkA@mail.gmail.com>
Subject: [git pull] ARM Device tree support
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

As per discussion attached below.  Please pull this tree adding device
tree support to ARM, plus some other minor device tree changes.

Thanks,
g.

The following changes since commit 4a7df24ddc7097cd789a7527187826552ea0765e:

  Merge branch 'for-linus/2640/i2c' of
git://git.fluff.org/bjdooks/linux (2011-05-24 16:39:23 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 devicetree/arm-next

Andres Salomon (1):
      of/flattree: minor cleanups

Grant Likely (6):
      dt/flattree: explicitly pass command line pointer to
early_init_dt_scan_chosen
      arm/dt: Make __vet_atags also accept a dtb image
      arm/dt: Allow CONFIG_OF on ARM
      arm/dt: consolidate atags setup into setup_machine_atags
      arm/dt: probe for platforms via the device tree
      dt: add documentation of ARM dt boot interface

 Documentation/arm/Booting                       |   33 +++++-
 Documentation/devicetree/booting-without-of.txt |   48 +++++++-
 arch/arm/Kconfig                                |    7 +
 arch/arm/include/asm/mach/arch.h                |    9 ++
 arch/arm/include/asm/prom.h                     |   37 ++++++
 arch/arm/include/asm/setup.h                    |    4 +
 arch/arm/kernel/Makefile                        |    1 +
 arch/arm/kernel/devtree.c                       |  145 +++++++++++++++++++++++
 arch/arm/kernel/head-common.S                   |   24 +++-
 arch/arm/kernel/head.S                          |    8 +-
 arch/arm/kernel/setup.c                         |   90 +++++++++-----
 arch/arm/mm/init.c                              |   11 ++
 arch/microblaze/kernel/prom.c                   |    2 +-
 arch/mips/include/asm/prom.h                    |    3 -
 arch/mips/kernel/prom.c                         |    3 +-
 arch/powerpc/kernel/prom.c                      |    2 +-
 drivers/of/fdt.c                                |    8 +-
 17 files changed, 375 insertions(+), 60 deletions(-)
 create mode 100644 arch/arm/include/asm/prom.h
 create mode 100644 arch/arm/kernel/devtree.c


On Tue, May 24, 2011 at 12:42 PM, Nicolas Pitre
<nicolas.pitre@linaro.org> wrote:
> On Mon, 23 May 2011, Grant Likely wrote:
>
>> Hi Russell,
>>
>> How do you want to handle merging the ARM DT support?  Do you want to
>> pull it into your tree, or would you like me to ask Linus to pull
>> directly?  As you can see, It does include a couple of pre-requisite
>> cross-arch cleanups that I normally push to Linus directly.
>
> I don't think that Linus would object to you pushing that to him
> directly, given that Russell has already agreed to those patches going
> in this cycle.
>
> Whatever the path, it is however important that they do get in _this_
> cycle.  Most people are just too nervous committing themselves to DT if
> the basic stuff doesn't hit mainline.  And if we are serious about
> _trying_ to change the state of things in ARM land by going the DT route
> then we must have this in mainline as soon as possible.
>
>
> Nicolas
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
