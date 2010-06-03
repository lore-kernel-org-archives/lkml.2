Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933732Ab0FCDHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 23:07:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59839 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933620Ab0FCDHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 23:07:18 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 2 Jun 2010 21:06:54 -0600
X-Google-Sender-Auth: jfHCrWV6_qESp5aQAJQiwSeBe1M
Message-ID: <AANLkTikNcAvyHf1yHPweNBVSCSPNmq-JaEOgYW2FYUGJ@mail.gmail.com>
Subject: [git pull] (updated) OF-related build breakage fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
       Anatolij Gustschin <agust@denx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated pull request.  Added more fixes from Anatolij of the same sort.

g.

The following changes since commit aef4b9aaae1decc775778903922bd0075cce7a88:
  Linus Torvalds (1):
        Merge branch 'next' of git://git.kernel.org/.../benh/powerpc

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 merge

Alexandre Bounine (1):
      of/powerpc: fix 85xx RapidIO device node pointer

Anatolij Gustschin (12):
      of/spi: mpc512x_psc_spi.c: Fix build failures
      of/mtd/nand: mpc5121_nfc.c: Fix build failures
      of/dma: mpc512x_dma.c: Fix build failures
      of/pcmcia: m8xx_pcmcia.c: Fix build failures
      of/video: fix build breakage in FB drivers
      of/mtd: nand: fix build breakage in drivers
      of/dma: fix build breakage in ppc4xx adma driver
      of/crypto: crypto4xx_core.c: fix build breakage
      of/usb: fsl_qe_udc.c: fix build breakage
      of/net: fs_enet/mii-bitbang.c: fix build breakage
      of/edac: fix build breakage in drivers
      of/watchdog: gef_wdt.c: fix build breakage

Grant Likely (3):
      of/usb: fix build error due to of_node pointer move
      of/spi: Fix build failure on spi_ppc4xx.c
      of/rtc: rtc-mpc5121.c: Fix build failures

Michael Guntsche (1):
      watchdog: Fix build failure with OF changes

 arch/powerpc/sysdev/fsl_rio.c        |    2 +-
 drivers/crypto/amcc/crypto4xx_core.c |    6 +++---
 drivers/dma/mpc512x_dma.c            |   10 +++++-----
 drivers/dma/ppc4xx/adma.c            |    4 ++--
 drivers/edac/mpc85xx_edac.c          |   12 ++++++------
 drivers/edac/ppc4xx_edac.c           |    6 +++---
 drivers/mtd/nand/fsl_upm.c           |   17 +++++++++--------
 drivers/mtd/nand/mpc5121_nfc.c       |    8 ++++----
 drivers/mtd/nand/socrates_nand.c     |    4 ++--
 drivers/net/fs_enet/mii-bitbang.c    |    4 ++--
 drivers/pcmcia/m8xx_pcmcia.c         |    4 ++--
 drivers/rtc/rtc-mpc5121.c            |   14 ++++++++------
 drivers/spi/mpc512x_psc_spi.c        |   12 ++++++------
 drivers/spi/spi_ppc4xx.c             |    2 +-
 drivers/usb/gadget/fsl_qe_udc.c      |    4 ++--
 drivers/usb/host/ehci-xilinx-of.c    |    2 +-
 drivers/video/bw2.c                  |    2 +-
 drivers/video/cg14.c                 |    2 +-
 drivers/video/cg3.c                  |    2 +-
 drivers/video/leo.c                  |    2 +-
 drivers/video/mb862xx/mb862xxfb.c    |    2 +-
 drivers/video/p9100.c                |    2 +-
 drivers/video/tcx.c                  |    2 +-
 drivers/watchdog/gef_wdt.c           |    2 +-
 drivers/watchdog/mpc8xxx_wdt.c       |    2 +-
 25 files changed, 66 insertions(+), 63 deletions(-)


On Wed, Jun 2, 2010 at 2:24 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Hi Linus,
>
> Here's a set of build fixes related to the of_node and of_match_table
> device changes.  All trivial fixes.
>
> Thanks,
> g.
>
> The following changes since commit aef4b9aaae1decc775778903922bd0075cce7a88:
>  Linus Torvalds (1):
>        Merge branch 'next' of git://git.kernel.org/.../benh/powerpc
>
> are available in the git repository at:
>
>  git://git.secretlab.ca/git/linux-2.6 merge
>
> Alexandre Bounine (1):
>      of/powerpc: fix 85xx RapidIO device node pointer
>
> Anatolij Gustschin (3):
>      of/spi: mpc512x_psc_spi.c: Fix build failures
>      of/mtd/nand: mpc5121_nfc.c: Fix build failures
>      of/dma: mpc512x_dma.c: Fix build failures
>
> Grant Likely (3):
>      of/usb: fix build error due to of_node pointer move
>      of/spi: Fix build failure on spi_ppc4xx.c
>      of/rtc: rtc-mpc5121.c: Fix build failures
>
> Michael Guntsche (1):
>      watchdog: Fix build failure with OF changes
>
>  arch/powerpc/sysdev/fsl_rio.c     |    2 +-
>  drivers/dma/mpc512x_dma.c         |   10 +++++-----
>  drivers/mtd/nand/mpc5121_nfc.c    |    8 ++++----
>  drivers/rtc/rtc-mpc5121.c         |   14 ++++++++------
>  drivers/spi/mpc512x_psc_spi.c     |   12 ++++++------
>  drivers/spi/spi_ppc4xx.c          |    2 +-
>  drivers/usb/host/ehci-xilinx-of.c |    2 +-
>  drivers/watchdog/mpc8xxx_wdt.c    |    2 +-
>  8 files changed, 27 insertions(+), 25 deletions(-)
>
> --
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
