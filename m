Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab1ESSYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:24:34 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44162 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933783Ab1ESSHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:07:44 -0400
X-Sasl-enc: ZIMIsQIYoSAfM1lL0Jnn6ZSefN+L7/Ks00m7VnxGqH0D 1305828463
Date: Thu, 19 May 2011 11:06:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/71] 2.6.38.7-stable review
Message-ID: <20110519180626.GA16555@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.38.7 release.
There are 71 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Sunday, May 22 2011, 18:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.38.7-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                   |    2 +-
 arch/arm/boot/compressed/Makefile          |    2 +-
 arch/arm/boot/compressed/vmlinux.lds.in    |    1 +
 arch/powerpc/kernel/ptrace.c               |   12 ++-
 arch/x86/include/asm/apicdef.h             |    1 +
 arch/x86/include/asm/uv/uv_bau.h           |   17 +++-
 arch/x86/kernel/cpu/amd.c                  |    4 +-
 arch/x86/kernel/cpu/mcheck/mce_amd.c       |    1 +
 arch/x86/kernel/cpu/mcheck/therm_throt.c   |   12 ++-
 arch/x86/kernel/ptrace.c                   |   36 +++++--
 arch/x86/platform/uv/tlb_uv.c              |   92 +++++++++++-----
 drivers/ata/libata-eh.c                    |    2 +-
 drivers/cdrom/cdrom.c                      |    6 +-
 drivers/gpu/drm/i915/intel_display.c       |    4 +-
 drivers/gpu/drm/i915/intel_dp.c            |   17 +++-
 drivers/gpu/drm/i915/intel_lvds.c          |    3 +
 drivers/gpu/drm/radeon/evergreen.c         |   17 ++--
 drivers/gpu/drm/radeon/evergreend.h        |    5 +
 drivers/gpu/drm/radeon/radeon_atombios.c   |   18 +++-
 drivers/gpu/drm/radeon/radeon_kms.c        |    3 +
 drivers/media/video/cx88/cx88-input.c      |    2 +-
 drivers/media/video/v4l2-device.c          |    5 +-
 drivers/mmc/core/host.c                    |    9 +-
 drivers/net/Kconfig                        |    8 ++-
 drivers/net/Makefile                       |    6 +-
 drivers/net/can/sja1000/sja1000.c          |    2 +-
 drivers/net/can/slcan.c                    |    4 +-
 drivers/net/ehea/ehea_ethtool.c            |   21 +++--
 drivers/net/ehea/ehea_main.c               |    6 +-
 drivers/net/hydra.c                        |   14 ++--
 drivers/net/ne-h8300.c                     |   16 ++--
 drivers/net/pch_gbe/pch_gbe_main.c         |   23 +++--
 drivers/net/slip.c                         |    4 +-
 drivers/net/usb/ipheth.c                   |   14 ++-
 drivers/net/vmxnet3/vmxnet3_drv.c          |   10 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c      |    3 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    6 +
 drivers/net/wireless/iwlwifi/iwl-core.h    |    2 +
 drivers/net/wireless/iwlwifi/iwl-legacy.c  |    7 ++
 drivers/net/wireless/iwlwifi/iwl-rx.c      |    8 +-
 drivers/net/wireless/libertas/cmd.c        |    6 +-
 drivers/net/zorro8390.c                    |   12 +-
 drivers/platform/x86/thinkpad_acpi.c       |    6 +-
 drivers/rapidio/switches/idt_gen2.c        |    9 ++
 drivers/rapidio/switches/idtcps.c          |    6 +
 drivers/rapidio/switches/tsi57x.c          |    6 +
 drivers/rtc/rtc-s3c.c                      |   13 ++-
 drivers/scsi/megaraid/megaraid_sas_base.c  |    3 +
 drivers/scsi/sd.c                          |   63 +++---------
 fs/block_dev.c                             |   27 +++--
 fs/cifs/cifs_unicode.c                     |   49 ++++-----
 fs/cifs/cifs_unicode.h                     |    2 +-
 fs/cifs/connect.c                          |  130 +++++++++++++----------
 fs/cifs/sess.c                             |   19 +---
 fs/partitions/efi.c                        |    6 +
 fs/proc/task_mmu.c                         |   12 ++-
 include/drm/radeon_drm.h                   |    1 +
 include/linux/bootmem.h                    |    2 +
 include/linux/mm.h                         |   24 ++++-
 include/linux/mmc/host.h                   |    1 +
 include/linux/ptrace.h                     |   13 ++-
 include/linux/sched.h                      |    3 +
 kernel/exit.c                              |    2 +-
 kernel/power/suspend.c                     |    4 +-
 kernel/power/user.c                        |    5 +-
 kernel/ptrace.c                            |   17 +++
 kernel/time/clocksource.c                  |    4 +-
 kernel/time/tick-broadcast.c               |   12 ++-
 mm/memory.c                                |   16 ++--
 mm/mmap.c                                  |   11 ++-
 mm/page_alloc.c                            |    7 +-
 mm/shmem.c                                 |  155 ++++++++++++++++------------
 net/core/dev.c                             |   10 +-
 net/dccp/options.c                         |    2 +
 net/ipv4/ip_fragment.c                     |   33 +++---
 sound/soc/codecs/ssm2602.c                 |    2 +-
 sound/soc/codecs/uda134x.c                 |    2 -
 78 files changed, 703 insertions(+), 418 deletions(-)
