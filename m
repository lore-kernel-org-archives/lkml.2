Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750838Ab2DCLO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:14:26 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38409 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab2DCLOY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:14:24 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.129.146]
In-Reply-To: <1332173578-27422-1-git-send-email-j-pihet@ti.com>
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com>
Date: Tue, 3 Apr 2012 13:14:23 +0200
Message-ID: <CAORVsuWJrEjUi11dyQZCnn-6BwOg9cN94G44JWpYvCtB8LbxKw@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] PM: Create the AVS class of drivers
From: Jean Pihet <jean.pihet@newoldbits.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>
Cc: Jean Pihet <j-pihet@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony, Rafael,

Here is a gentle ping on this series.
Do you think this can go in the next rc?

Regards,
Jean

On Mon, Mar 19, 2012 at 5:12 PM,  <jean.pihet@newoldbits.com> wrote:
> From: Jean Pihet <j-pihet@ti.com>
>
> AVS is a power management technique which controls the operating
> voltage of a device in order to optimize (i.e. reduce) its power
> consumption. The voltage is adapted depending on static factors
> (chip manufacturing process) and dynamic factors (temperature
> depending performance).
> AVS is also called SmartReflex on OMAP devices.
>
> To that end, create the AVS framework in drivers/power/avs and
> move the OMAP SmartReflex code to the new directory.
>
> In preparation to the move of the OMAP code the following changes have been
> made:
> - split the include files into generic and platform specific code,
> - fill in platform data from the device initialization code and pass
>  it to the driver,
> - create CONFIG_AVS* config options accordingly.
>
> The platform integration data for SmartReflex is passed from hwmod
> and the voltage layer to the driver using pdata.
>
>
> Tested on OMAP3 Beagleboard using omap2plus_defconfig with the
> CONFIG_POWER_AVS* options set.
> Based on master branch of the l-o git tree (3.3.0-rc6) [1], commit
> 85244e0edd240da2004bb2ab7cbcbc67a336f20d.
>
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git
>
>
> History:
> v2: rework after the comments on MLs
>  . Keep the OMAP Kconfig options in the arch dir (Rafael),
>  . Move the shared header file from plat-omap to
>    include/linux/power/ (Tony)
>
> v1: initial revision
>
>
> Jean Pihet (9):
>  ARM: OMAP3+: voltage: export functions to plat/voltage.h
>  ARM: OMAP2+: SmartReflex: move the driver specific macros in
>    include/linux/power
>  ARM: OMAP3+: SmartReflex: class drivers should use struct omap_sr *
>  ARM: OMAP2+: smartreflex: Use the names from hwmod data instead of
>    voltage domains.
>  ARM: OMAP3: hwmod: rename the smartreflex entries
>  ARM: OMAP2+: SmartReflex: introduce a busy loop condition test macro
>  ARM: OMAP2+: SmartReflex: Use per-OPP data structure
>  ARM: OMAP2+: SmartReflex: add POWER_AVS Kconfig options
>  ARM: OMAP: SmartReflex: Move smartreflex driver to drivers/
>
>  arch/arm/mach-omap2/Makefile               |    4 +-
>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |   12 +-
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    3 +-
>  arch/arm/mach-omap2/pm.h                   |    2 +-
>  arch/arm/mach-omap2/smartreflex-class3.c   |   60 --
>  arch/arm/mach-omap2/smartreflex.c          | 1165 ----------------------------
>  arch/arm/mach-omap2/smartreflex.h          |  256 ------
>  arch/arm/mach-omap2/sr_device.c            |   38 +-
>  arch/arm/mach-omap2/voltage.h              |    1 -
>  arch/arm/mach-omap2/vp.h                   |    2 -
>  arch/arm/plat-omap/Kconfig                 |   30 +-
>  arch/arm/plat-omap/include/plat/voltage.h  |    3 +
>  drivers/power/Kconfig                      |    2 +
>  drivers/power/Makefile                     |    2 +
>  drivers/power/avs/Kconfig                  |   12 +
>  drivers/power/avs/Makefile                 |    2 +
>  drivers/power/avs/smartreflex-class3.c     |   61 ++
>  drivers/power/avs/smartreflex.c            | 1118 ++++++++++++++++++++++++++
>  drivers/power/avs/smartreflex.h            |  238 ++++++
>  include/linux/power/smartreflex.h          |   97 +++
>  20 files changed, 1590 insertions(+), 1518 deletions(-)
>  delete mode 100644 arch/arm/mach-omap2/smartreflex-class3.c
>  delete mode 100644 arch/arm/mach-omap2/smartreflex.c
>  delete mode 100644 arch/arm/mach-omap2/smartreflex.h
>  create mode 100644 drivers/power/avs/Kconfig
>  create mode 100644 drivers/power/avs/Makefile
>  create mode 100644 drivers/power/avs/smartreflex-class3.c
>  create mode 100644 drivers/power/avs/smartreflex.c
>  create mode 100644 drivers/power/avs/smartreflex.h
>  create mode 100644 include/linux/power/smartreflex.h
>
> --
> 1.7.5.4
>
