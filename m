Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1LUCZC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 21:25:02 -0500
Received: from void.printf.net ([89.145.121.20]:54779 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab1LUCY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 21:24:59 -0500
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MMC fixes for 3.2
Date: Tue, 20 Dec 2011 21:24:47 -0500
Message-ID: <m2k45q3bm8.fsf@bob.laptop.org>
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

to receive three fixes for MMC for 3.2:

  * Revert automatic enabling of SDIO runtime PM (added in -rc1), after
    finding that this has caused a regression for a few setups that we
    don't know how to fix yet.  We'll try again in a later release.
  * Silence PCI suspend WARN_ON()s that appeared in -rc1 regarding
    legacy PM support.  This patch is what makes the diffstat large.
  * Fix the type of a module_param in the vub300 driver.

These have been tested in linux-next, and there are no merge conflicts.
Thanks.


The following changes since commit 49df78074963c97e25debc3c67b72f059111607d:

  mmc: core: Fix deadlock when the CONFIG_MMC_UNSAFE_RESUME is not defined (2011-12-10 16:18:39 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

for you to fetch changes up to 61074287c2965edf0fc75b54ae8f4ce99f182669:

  mmc: vub300: fix type of firmware_rom_wait_states module parameter (2011-12-19 15:56:09 -0800)

- ----------------------------------------------------------------
Manuel Lauss (1):
      mmc: sdhci: remove "state" argument from sdhci_suspend_host

Ohad Ben-Cohen (1):
      Revert "mmc: enable runtime PM by default"

Rusty Russell (1):
      mmc: vub300: fix type of firmware_rom_wait_states module parameter

 drivers/mmc/core/host.c            |   11 -----------
 drivers/mmc/host/sdhci-cns3xxx.c   |    5 +----
 drivers/mmc/host/sdhci-dove.c      |    5 +----
 drivers/mmc/host/sdhci-esdhc-imx.c |    5 +----
 drivers/mmc/host/sdhci-of-esdhc.c  |    5 +----
 drivers/mmc/host/sdhci-of-hlwd.c   |    5 +----
 drivers/mmc/host/sdhci-pci.c       |   26 +++++++++++++-------------
 drivers/mmc/host/sdhci-pltfm.c     |   18 +++++++++++-------
 drivers/mmc/host/sdhci-pltfm.h     |    6 ++++--
 drivers/mmc/host/sdhci-pxav2.c     |    5 +----
 drivers/mmc/host/sdhci-pxav3.c     |    5 +----
 drivers/mmc/host/sdhci-s3c.c       |   21 ++++++++++++++-------
 drivers/mmc/host/sdhci-tegra.c     |    5 +----
 drivers/mmc/host/sdhci.c           |    2 +-
 drivers/mmc/host/sdhci.h           |    2 +-
 drivers/mmc/host/vub300.c          |    2 +-
 16 files changed, 53 insertions(+), 75 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO8UCZAAoJEHNBYZ7TNxYMSJIQAIbASQ0kezY5hLMyaf9mtInc
s1o0UrKRAVhmjnqUvpQY3/woG2ABszrmjYAbHlGEVPe7/XPztPSXh4myjags+Jri
K13omUqsGUaq1JJUk0/z0tQe8ixlaZTArfQpSCiaMUDZ8eO+p5eWNx0m0ZktBdUy
VJAsk7HMg4Kvi4DUHplPnO9erbu0XZaTj93hpDLk3R7wpipkjDtb5p43Wt8KMVk3
SwMbhQ6jdJbFwqh6D1GjFKTcIYOjNYluNHHwjI+rpzIElIkJmyK9eyORo9C9aEyD
Oy7ap8934jYPEae9YApnPUwjDSWeH+VvAWY3vXEuPGGDlvZ1mQEHJ7vvpnqG9nvv
u3CD7A0v4eXwAoaWxtCFfN+YlvLu8O+JYFmky/QlUfiUtWZH/miU8XWslofBrbT5
h2gUn6wcjdNPFM1jshuSOoZS8IQt0XnQGsAaI/ChPDRA3Mx6JSvL/Fh8i2kyjh1I
i751Y6WJoYVBGecFtfrjzEbCjKaKUPGnM+JIlvYKpzskmszxxR2tvd/x3EFUyDUL
OD9BLzpJJRueOB1cMamdo3aJ8YEb/28to/Om2AeidWSD7Gaj0N7lu85CQpNxLmhm
jySjWtaDAQYmMjMxR3jNrNirb47AkbkzMeToFCc78F/RpEZu1EJPVxQ+qX7P5BVT
vTwVHvdvob0frPRyBPCs
=exRR
-----END PGP SIGNATURE-----

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
