Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab1J1Mlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:41:37 -0400
Received: from void.printf.net ([89.145.121.20]:44801 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706Ab1J1Mlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:41:35 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: MMC updates for 3.2-rc1
Date: Fri, 28 Oct 2011 08:41:25 -0400
Message-ID: <m2fwide1ai.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to receive MMC updates for 3.2.  There are currently no merge conflicts,
and the patches have been tested in linux-next.  Thanks.

Does the below method of verifying a signed pull request work well for you?
Would you prefer signed git tags?  To summarize, if you:

 % git checkout 41ebe9c # rewind to the mainline commit I branched at
 % git pull git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc for-linus
 % git rev-parse HEAD
 a6029e1f75bb484c1f5bc68b6a8572e4024795bc

and the top-most commit hash you see matches the one above, then git has
guaranteed that the commits I'm sending you are the commits I intended
to send you, and this mail carrying a good gpg signature from my key
guarantees that the hash above is unaltered.


MMC highlights are:

Core:
 * Enable runtime PM by default (but not for SDHCI hosts, which must
   claim support explicitly).
 * Add support for the random fault injection framework, enabled with
   CONFIG_FAIL_MMC_REQUEST and the "fail_mmc_request" boot param.

Drivers:
 * Support for many features new in eMMC 4.5:  Hardware reset, Power
   Class selection, General Purpose partitions, Power Off Notify,
   Sanitize command, Discard command, Cache control, HPI Send.
 * We now put eMMCs into sleep (CMD5) mode before suspend, saving power.   
 * We now recognize SDIO 3.0 cards.
 * Freescale i.MX: added support for ADMA2.
 * Freescale i.MX: Added support for the uSDHC controller in imx6q. 
 * sdhci-tegra: added support for Device Tree probing.
 

The following changes since commit 41ebe9cde738a972d05c7282e09f5ed54cff0e8d:

  Merge branch 'master' of git://git.infradead.org/users/linville/wireless-next into for-davem (2011-10-17 15:05:26 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

for you to fetch changes up to a6029e1f75bb484c1f5bc68b6a8572e4024795bc:

  mmc: fix compile error when CONFIG_BLOCK is not enabled (2011-10-27 09:11:34 -0400)

- ----------------------------------------------------------------
Aaron Lu (1):
      mmc: core: add sd uhs string for mmc_ios_show

Adrian Hunter (11):
      mmc: core: add eMMC hardware reset support
      mmc: sdhci: add eMMC hardware reset support
      mmc: sdhci-pci: add eMMC hardware reset support
      mmc: mmc-test: add eMMC hardware reset test
      mmc: block: add eMMC hardware reset support
      mmc: block: fix boot partition switch error path
      mmc: block: support no access to boot partitions
      mmc: core: move ->request() call from atomic context
      mmc: sdhci-pci: add runtime pm support
      mmc: omap_hsmmc: ensure pbias configuration is always done
      mmc: sdhci-pci: add flag for devices that can support runtime PM

Alexander Tarasikov (2):
      mmc: msm_sdcc: Fix a typo in MSM SDCC driver gpio setup
      msm: Implement init_card operation for MSM SDCC

Andrei Warkentin (1):
      mmc: core: ext_csd.raw_* used in comparison but never set

Balaji T K (1):
      mmc: core: Put eMMC in Sleep mode before suspend

Bing Zhao (1):
      mmc: recognise SDIO cards with SDIO_CCCR_REV 3.00

Daniel Drake (2):
      mmc: enable runtime PM by default
      mmc: core: add a short delay in mmc_power_off

Girish K S (3):
      mmc: core: eMMC 4.5 Power Class Selection Feature
      mmc: replace printk with appropriate display macro
      mmc: core: Add Power Off Notify Feature eMMC 4.5

Grant Likely (1):
      mmc: sdhci-tegra: Add Device Tree probing support

Guennadi Liakhovetski (1):
      mmc: sh_mmcif: simplify platform data

Jaehoon Chung (3):
      mmc: sdhci-s3c: fix potential NULL dereference
      mmc: dw_mmc: modify DATA register offset
      mmc: core: support HPI send command

Kyungmin Park (2):
      mmc: core: mmc sanitize feature support for v4.5
      mmc: core: new discard feature support at eMMC v4.5

Ludovic Desroches (8):
      mmc: atmel-mci: change namespace
      mmc: atmel-mci: change atmci_readl and atmci_writel macros
      mmc: atmel-mci: indentation
      mmc: atmel-mci: add pdc support and runtime capabilities detection
      mmc: atmel-mci: change atmci_start_command to atmci_send_command
      mmc: atmel-mci: use ATMEL_PDC_SCND_BUF_OFF instead of a literal value
      mmc: atmel-mci: correct sg buffer size evaluation
      mmc: atmel-mci: fix a potential issue about pending PDC interrupts

Namjae Jeon (2):
      mmc: core: general purpose MMC partition support.
      mmc: fix compile error when CONFIG_BLOCK is not enabled

Nicolas Ferre (1):
      mmc: at91_mci: remove the use of irq_to_gpio

Paul Gortmaker (1):
      mmc: Add module.h to drivers/mmc users assuming implicit presence.

Paul Walmsley (2):
      mmc: core: add workaround for controllers with broken multiblock reads
      mmc: omap_hsmmc: if multiblock reads are broken, disable them

Per Forlin (8):
      fault-inject: export fault injection functions
      mmc: core: add random fault injection
      fault-inject: add documentation on MMC IO fault injection
      mmc: core: clarify how to use post_req in case of errors
      mmc: mmci: simplify err check in mmci_post_request
      fault-inject: export setup_fault_attr()
      mmc: add module param to set fault injection attributes
      fault-injection: update documentation with the mmc module param

Richard Zhu (1):
      mmc: sdhci-esdhc-imx: Enable ADMA2

Sahitya Tummala (5):
      mmc: msm_sdcc: Handle error cases in probe
      mmc: msm_sdcc: Enable SDC host->clk only after setting the rate.
      msm: mmc: Remove "pio_irq" resource
      mmc: msm_sdcc: Use MCI_INT_MASK0 for PIO interrupts
      mmc: msm_sdcc: Change initialization order of busclk_timer in probe

Sascha Hauer (1):
      mmc: Kconfig: remove i.MX individual SoC dependency

Seungwon Jeon (4):
      mmc: core: Add default timeout value for CMD6
      mmc: core: Modify the timeout value for writing power class
      mmc: core: Add cache control for eMMC4.5 device
      mmc: core: Cleanup eMMC4.5 conditionals

Shashidhar Hiremath (1):
      mmc: dw_mmc: Support SDIO interrupts for all slots

Shawn Guo (1):
      mmc: sdhci-esdhc-imx: add basic imx6q usdhc support

Simon Horman (4):
      mmc: tmio: Cache interrupt masks
      mmc: tmio: Provide separate interrupt handlers
      mmc: sdhi: Allow named IRQs to use specific handlers
      ARM: shmobile: ag5evm, ap4: Named SDHI IRQ sources

Stefan Nilsson XK (2):
      mmc: sdio: Workaround for dev with broken CMD53
      mmc: core: Set correct bus mode before card init

Stephen Rothwell (1):
      mmc: using module_param requires the inclusion of moduleparam.h

Stephen Warren (1):
      mmc: sdhci-tegra: Add 8-bit support to device tree binding.

Subhash Jadavani (2):
      mmc: msm_sdcc: Handle dma resource not present case
      mmc: sd: Handle SD3.0 cards not supporting UHS-I bus speed mode

Tanmay Upadhyay (1):
      mmc: sdhci-pxa: Check pdata before using its members

Thomas Abraham (1):
      mmc: sdhci-s3c: add default controller configuration

Ulf Hansson (2):
      mmc: core: Fix hangs related to insert/remove of cards
      mmc: core: Prevent too long response times for suspend

Venkatraman S (2):
      mmc: queue: declare mmc_alloc_sg as static
      mmc: fix integer assignments to pointer

Viresh Kumar (1):
      mmc: sdhci-spear: Don't set power gpio to 1 on probe

Xu lei (1):
      mmc: sdhci-of-esdhc: Access Freescale eSDHC registers as 32-bit

Yong Zhang (1):
      mmc: irq: Remove IRQF_DISABLED

 .../devicetree/bindings/mmc/nvidia-sdhci.txt       |   27 +
 Documentation/fault-injection/fault-injection.txt  |    8 +-
 arch/arm/mach-at91/at91sam9260_devices.c           |    2 +-
 arch/arm/mach-msm/devices-msm7x00.c                |   24 -
 arch/arm/mach-msm/devices-qsd8x50.c                |   24 -
 arch/arm/mach-msm/include/mach/mmc.h               |    9 +-
 arch/arm/mach-shmobile/board-ag5evm.c              |    6 +
 arch/arm/mach-shmobile/board-mackerel.c            |    6 +
 arch/arm/plat-omap/include/plat/mmc.h              |   19 +-
 drivers/mmc/card/block.c                           |  310 +++++---
 drivers/mmc/card/mmc_test.c                        |   65 ++-
 drivers/mmc/card/queue.c                           |    8 +-
 drivers/mmc/card/sdio_uart.c                       |   10 +-
 drivers/mmc/core/bus.c                             |    6 +-
 drivers/mmc/core/core.c                            |  426 +++++++++-
 drivers/mmc/core/core.h                            |    1 +
 drivers/mmc/core/debugfs.c                         |   28 +
 drivers/mmc/core/host.c                            |   11 +
 drivers/mmc/core/mmc.c                             |  287 +++++++-
 drivers/mmc/core/mmc_ops.c                         |   39 +-
 drivers/mmc/core/mmc_ops.h                         |    1 +
 drivers/mmc/core/quirks.c                          |   11 +
 drivers/mmc/core/sd.c                              |   49 +-
 drivers/mmc/core/sd_ops.c                          |    8 +-
 drivers/mmc/core/sdio.c                            |   11 +-
 drivers/mmc/core/sdio_bus.c                        |    2 +-
 drivers/mmc/core/sdio_cis.c                        |    4 +-
 drivers/mmc/core/sdio_irq.c                        |    6 +-
 drivers/mmc/core/sdio_ops.c                        |    9 +-
 drivers/mmc/host/Kconfig                           |   16 +-
 drivers/mmc/host/at91_mci.c                        |    6 +-
 drivers/mmc/host/atmel-mci-regs.h                  |  220 +++---
 drivers/mmc/host/atmel-mci.c                       |  823 +++++++++++++-------
 drivers/mmc/host/au1xmmc.c                         |   10 +-
 drivers/mmc/host/dw_mmc.c                          |  104 ++-
 drivers/mmc/host/dw_mmc.h                          |   15 +-
 drivers/mmc/host/imxmmc.c                          |    2 +-
 drivers/mmc/host/mmc_spi.c                         |    1 +
 drivers/mmc/host/mmci.c                            |    4 +-
 drivers/mmc/host/msm_sdcc.c                        |   86 ++-
 drivers/mmc/host/msm_sdcc.h                        |    6 +-
 drivers/mmc/host/mvsdio.c                          |   14 +-
 drivers/mmc/host/mxcmmc.c                          |    2 +-
 drivers/mmc/host/mxs-mmc.c                         |    1 +
 drivers/mmc/host/omap_hsmmc.c                      |   32 +-
 drivers/mmc/host/pxamci.c                          |    2 +-
 drivers/mmc/host/s3cmci.c                          |    4 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   80 ++-
 drivers/mmc/host/sdhci-of-esdhc.c                  |   19 +-
 drivers/mmc/host/sdhci-of-hlwd.c                   |    1 +
 drivers/mmc/host/sdhci-pci.c                       |  268 +++++++-
 drivers/mmc/host/sdhci-pltfm.c                     |    1 +
 drivers/mmc/host/sdhci-pxav2.c                     |    5 +-
 drivers/mmc/host/sdhci-pxav3.c                     |    1 +
 drivers/mmc/host/sdhci-s3c.c                       |   34 +-
 drivers/mmc/host/sdhci-spear.c                     |    3 +-
 drivers/mmc/host/sdhci-tegra.c                     |   55 +-
 drivers/mmc/host/sdhci.c                           |  358 +++++++--
 drivers/mmc/host/sdhci.h                           |    7 +-
 drivers/mmc/host/sdricoh_cs.c                      |    1 +
 drivers/mmc/host/sh_mmcif.c                        |   21 +-
 drivers/mmc/host/sh_mobile_sdhi.c                  |   99 ++-
 drivers/mmc/host/tifm_sd.c                         |   19 +-
 drivers/mmc/host/tmio_mmc.c                        |    4 +-
 drivers/mmc/host/tmio_mmc.h                        |    7 +
 drivers/mmc/host/tmio_mmc_pio.c                    |  151 +++--
 drivers/mmc/host/via-sdmmc.c                       |    3 +-
 drivers/mmc/host/wbsd.c                            |   22 +-
 include/linux/atmel-mci.h                          |    4 +-
 include/linux/atmel_pdc.h                          |    2 +
 include/linux/mmc/card.h                           |   58 ++-
 include/linux/mmc/core.h                           |    9 +
 include/linux/mmc/dw_mmc.h                         |    4 +
 include/linux/mmc/host.h                           |   29 +
 include/linux/mmc/mmc.h                            |   38 +-
 include/linux/mmc/sdhci.h                          |    8 +
 include/linux/mmc/sdio.h                           |    2 +
 include/linux/mmc/sh_mmcif.h                       |    4 +-
 include/linux/mmc/sh_mobile_sdhi.h                 |    4 +
 lib/Kconfig.debug                                  |   11 +
 lib/fault-inject.c                                 |    5 +-
 81 files changed, 3093 insertions(+), 1009 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOqqI3AAoJEHNBYZ7TNxYMNqIQALY9K/Vk0RUPjBwEr33xxoKf
886YYDJa4YqCM2CoW+IaLFqwM3C6Q4r4Rr2GdOt8ZE9qYBN9r12Qrh9CrvryxWge
t7d1xejBQdffGBj21yD7qoxwTlgKe8pmndopUECpd5KiDzofz7iH0FDbenMrZeV/
oirWmC9UXMASSGWfAjSpRxxlBE+TjhbTaR8NvByt9ajQrMrbDesouoeQMOwb7Y7W
jacki46uMCWwFrhDCu7HRJSbD8Ec3Hhu4wqKzsNSfkZBaM4+0JHtEB8lYR+rs3gG
8HFOy8QAl4mV1G0iTvLbJviBw+s6/Jj9bzqg9I8rEV2H9WSDavpsGKZQPWaJHL1s
0I3HdZI3kSjDwv8bYxBOOm18dlB9fq4zUU89IFCdzxh2J7SV9RBzsL0j6CV68jjC
0c5LzUoXcAuFa62kF/uZrQiMzwaVpSok0W2GDvcNCa78BDSLAzywxApB0P+7KmKe
ZRVeNbxdlskf2zWJ2vRu45ZrId3ecC6WyFZngu87DZyWU/C2/T7/J5XoO3ZaXBBf
fisjLDCoNG3wmCvUJezsXwYcbTChiTkG6BhQTOjJX+p+eMWh0nYg4faXKXCVO83R
oIAbygJ+qrsP3fRhx//g/HscIUkbmAdlD2mT1HR0IKWb+WyF73rCaL7AjhhZGXNd
EKaVF3EaRNAoDLSmCiOI
=6DVp
-----END PGP SIGNATURE-----

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
