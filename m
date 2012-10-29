Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503Ab2J2UIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:08:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:42471 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758150Ab2J2UIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:08:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/34] 3.0.50-stable review
Date: Mon, 29 Oct 2012 13:07:31 -0700
Message-Id: <20121029200420.550338074@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.50 release.
There are 34 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Oct 31 20:03:41 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.50-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Sjoerd Simons <sjoerd.simons@collabora.co.uk>
    drm/i915: no lvds quirk for Zotac ZDBOX SD ID12/ID13

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: amplc_pc236: fix invalid register access during detach

Yinghai Lu <yinghai@kernel.org>
    x86, mm: Undo incorrect revert in arch/x86/mm/init.c

Jacob Shin <jacob.shin@amd.com>
    x86, mm: Find_early_table_space based on ranges that are actually being mapped

Andreas Herrmann <andreas.herrmann3@amd.com>
    cpufreq / powernow-k8: Remove usage of smp_processor_id() in preemptible code

Piotr Haber <phaber@broadcom.com>
    bcma: fix unregistration of cores

Stanislaw Gruszka <sgruszka@redhat.com>
    mac80211: check if key has TKIP type before updating IV

Bo Shen <voice.shen@atmel.com>
    ARM: at91/i2c: change id to let i2c-gpio work

Michael S. Tsirkin <mst@redhat.com>
    vhost: fix mergeable bufs on BE hosts

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Fix potential NULL ptr deref in command cancellation.

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: remove invalid disconnect handling

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: remove NULL-urb submission

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix port-device leak in error path

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix urb leak at release

Johan Hovold <jhovold@gmail.com>
    USB: sierra: fix memory leak in probe error path

Johan Hovold <jhovold@gmail.com>
    USB: sierra: fix memory leak in attach error path

Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
    USB: serial: Fix memory leak in sierra_release()

Johan Hovold <jhovold@gmail.com>
    USB: opticon: fix memory leak in error path

Johan Hovold <jhovold@gmail.com>
    USB: opticon: fix DMA from stack

Johan Hovold <jhovold@gmail.com>
    USB: whiteheat: fix memory leak in error path

Octavian Purdila <octavian.purdila@intel.com>
    usb hub: send clear_tt_buffer_complete events when canceling TT clear work

Michael Shigorin <mike@osdn.org.ua>
    usb-storage: add unusual_devs entry for Casio EX-N1 digital camera

Anisse Astier <anisse@astier.eu>
    ehci: Add yet-another Lucid nohandoff pci quirk

Anisse Astier <anisse@astier.eu>
    ehci: fix Lucid nohandoff pci quirk to be more generic with BIOS versions

Geert Uytterhoeven <geert@linux-m68k.org>
    sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of strcat()

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Prevent races in xs_abort_connection()

Trond Myklebust <Trond.Myklebust@netapp.com>
    Revert "SUNRPC: Ensure we close the socket on EPIPE errors too..."

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Clear the connect flag when socket state is TCP_CLOSE_WAIT

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Get rid of the xs_error_report socket callback

Will Deacon <will.deacon@arm.com>
    ARM: 7559/1: smp: switch away from the idmap before updating init_mm.mm_count

Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
    genalloc: stop crashing the system when destroying a pool

Jan Luebbe <jlu@pengutronix.de>
    drivers/rtc/rtc-imxdi.c: add missing spin lock initialization

Kees Cook <keescook@chromium.org>
    fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing error check

Kees Cook <keescook@chromium.org>
    gen_init_cpio: avoid stack overflow when expanding


-------------

Diffstat:

 Makefile                                     |  4 +-
 arch/arm/kernel/smp.c                        | 14 ++++--
 arch/arm/mach-at91/at91rm9200_devices.c      |  2 +-
 arch/arm/mach-at91/at91sam9260_devices.c     |  2 +-
 arch/arm/mach-at91/at91sam9261_devices.c     |  2 +-
 arch/arm/mach-at91/at91sam9263_devices.c     |  2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c      |  2 +-
 arch/x86/mm/init.c                           | 69 ++++++++++++++++------------
 drivers/bcma/main.c                          |  5 +-
 drivers/cpufreq/powernow-k8.c                |  9 +---
 drivers/gpu/drm/i915/intel_lvds.c            |  8 ++++
 drivers/rtc/rtc-imxdi.c                      |  2 +
 drivers/staging/comedi/drivers/amplc_pc236.c |  2 +-
 drivers/usb/core/hub.c                       |  7 ++-
 drivers/usb/host/pci-quirks.c                |  9 +++-
 drivers/usb/host/xhci-ring.c                 | 11 +++++
 drivers/usb/serial/mos7840.c                 | 30 ++----------
 drivers/usb/serial/opticon.c                 | 11 ++++-
 drivers/usb/serial/sierra.c                  | 26 ++++++++---
 drivers/usb/serial/whiteheat.c               |  1 +
 drivers/usb/storage/unusual_devs.h           |  6 +++
 drivers/vhost/net.c                          |  3 +-
 fs/compat_ioctl.c                            |  2 +
 fs/sysfs/dir.c                               | 16 +++----
 lib/genalloc.c                               |  2 +-
 net/mac80211/wpa.c                           |  3 +-
 net/sunrpc/xprtsock.c                        | 41 ++++-------------
 usr/gen_init_cpio.c                          | 43 +++++++++--------
 28 files changed, 181 insertions(+), 153 deletions(-)


