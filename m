Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab1EZLXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:23:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:58035 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab1EZLXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:23:32 -0400
Date: Thu, 26 May 2011 13:23:30 +0200
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] trivial __TIME__ and __DATE__ removal
Message-ID: <20110526112330.GA5325@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This series removes most of the remaining occurences of __TIME__ and
__DATE__ in the kernel source. Two more patches will be sent by
subsystem maintainers:

    nand/denali: Drop __TIME__ usage
    x86: Do not set the root_dev field in bzImage

Afterwards, a build with

export KBUILD_TIMESTAMP=<some fixed date>
export KBUILD_BUILD_USER=tux
export KBUILD_BUILD_HOST=machine

will produce identical results if the source is the same. A script
testing this is at http://userweb.kernel.org/~mmarek/test-reproducible.sh .

Michal

The following changes since commit 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d:

  Linux 2.6.39-rc1 (2011-03-29 12:09:47 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git trivial

Michal Marek (18):
      cyclades: Drop __TIME__ usage
      nozomi: Drop __TIME__ usage
      media/radio-maxiradio: Drop __TIME__ usage
      media/cx231xx: Drop __TIME__ usage
      aacraid: Drop __TIME__ usage
      scsi/in2000: Drop __TIME__ usage
      scsi/wd33c93: Drop __TIME__ usage
      rio: Drop __DATE__ usage
      edac: Drop __DATE__ usage
      pmcraid: Drop __DATE__ usage
      baycom: Drop __TIME__ usage
      hdlcdrv: Drop __TIME__ usage
      parport: Drop __TIME__ usage
      wan/pc300: Drop __TIME__ usage
      dlm: Drop __TIME__ usage
      atm: Drop __TIME__ usage
      isdn/diva: Drop __TIME__ usage
      gfs2: Drop __TIME__ usage

 drivers/edac/amd76x_edac.c                   |    2 +-
 drivers/edac/amd8111_edac.c                  |    2 +-
 drivers/edac/amd8131_edac.c                  |    2 +-
 drivers/edac/cpc925_edac.c                   |    2 +-
 drivers/edac/e752x_edac.c                    |    2 +-
 drivers/edac/e7xxx_edac.c                    |    2 +-
 drivers/edac/edac_module.c                   |    2 +-
 drivers/edac/i5000_edac.c                    |    2 +-
 drivers/edac/i5400_edac.c                    |    2 +-
 drivers/edac/i7300_edac.c                    |    2 +-
 drivers/edac/i7core_edac.c                   |    2 +-
 drivers/edac/i82860_edac.c                   |    2 +-
 drivers/edac/i82875p_edac.c                  |    2 +-
 drivers/edac/i82975x_edac.c                  |    2 +-
 drivers/edac/mpc85xx_edac.h                  |    2 +-
 drivers/edac/mv64x60_edac.h                  |    2 +-
 drivers/edac/ppc4xx_edac.c                   |    2 +-
 drivers/edac/r82600_edac.c                   |    2 +-
 drivers/isdn/hardware/eicon/divasfunc.c      |    5 ++---
 drivers/media/radio/radio-maxiradio.c        |    3 +--
 drivers/media/video/cx231xx/cx231xx-avcore.c |    2 +-
 drivers/net/hamradio/baycom_epp.c            |    2 +-
 drivers/net/hamradio/baycom_par.c            |    2 +-
 drivers/net/hamradio/baycom_ser_fdx.c        |    2 +-
 drivers/net/hamradio/baycom_ser_hdx.c        |    2 +-
 drivers/net/hamradio/hdlcdrv.c               |    2 +-
 drivers/net/wan/pc300_drv.c                  |    3 +--
 drivers/parport/parport_ip32.c               |    1 -
 drivers/scsi/aacraid/linit.c                 |    3 +--
 drivers/scsi/in2000.c                        |    2 +-
 drivers/scsi/pmcraid.c                       |    9 ++++-----
 drivers/scsi/pmcraid.h                       |    1 -
 drivers/scsi/wd33c93.c                       |    7 +++----
 drivers/staging/generic_serial/rio/rioinit.c |    2 +-
 drivers/tty/cyclades.c                       |    3 +--
 drivers/tty/nozomi.c                         |    3 +--
 fs/dlm/main.c                                |    2 +-
 fs/gfs2/main.c                               |    2 +-
 net/atm/lec.c                                |    2 +-
 net/atm/mpc.c                                |    2 +-
 40 files changed, 44 insertions(+), 54 deletions(-)
