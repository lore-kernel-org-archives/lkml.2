Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1HPRqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:46:20 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:43367 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1HPRqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:46:18 -0400
MIME-Version: 1.0
In-Reply-To: <20110812210626.GA4725@kroah.com>
References: <20110812210626.GA4725@kroah.com>
Date: Tue, 16 Aug 2011 13:46:16 -0400
Message-ID: <CACqU3MWri2+MMT8qX4UXGUL-H-bk6Hy7dg00VubU6PLsMVUg9g@mail.gmail.com>
Subject: Re: [00/90] 3.0.2-stable review
From: Arnaud Lacombe <lacombar@gmail.com>
To: Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7GHkYLT030328

Hi,

On Fri, Aug 12, 2011 at 5:06 PM, Greg KH <gregkh@suse.de> wrote:
> This is the start of the stable review cycle for the 3.0.2 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
>
> Responses should be made by Monday, August 15, 2011, 20:00:00 UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>        kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.2-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
It seems that this release has not yet reached the -allstable tree,
moreover, the tree seem to not have seen any upgrade from Linus tree
for 4 days. Is there anything broken ?

Thanks,
 - Arnaud

>  Makefile                                        |    4 +-
>  arch/cris/arch-v10/drivers/sync_serial.c        |    6 +-
>  arch/cris/arch-v10/kernel/irq.c                 |    3 +
>  arch/cris/include/asm/thread_info.h             |    6 +-
>  arch/parisc/include/asm/atomic.h                |    4 +-
>  arch/parisc/include/asm/futex.h                 |   66 ++++-
>  arch/parisc/include/asm/unistd.h                |    3 +-
>  arch/parisc/kernel/syscall_table.S              |    1 +
>  arch/powerpc/kernel/prom_init.c                 |    6 +-
>  arch/powerpc/platforms/pseries/dtl.c            |    2 +-
>  arch/powerpc/platforms/pseries/kexec.c          |   11 +
>  arch/powerpc/platforms/pseries/lpar.c           |    2 +-
>  arch/powerpc/platforms/pseries/plpar_wrappers.h |    4 +-
>  arch/sparc/include/asm/bitops_64.h              |   49 +---
>  arch/sparc/include/asm/elf_64.h                 |   63 ++---
>  arch/sparc/include/asm/hypervisor.h             |   14 +
>  arch/sparc/include/asm/spitfire.h               |    1 +
>  arch/sparc/include/asm/tsb.h                    |   51 ++--
>  arch/sparc/include/asm/xor_64.h                 |    3 +-
>  arch/sparc/kernel/cpu.c                         |    8 +
>  arch/sparc/kernel/cpumap.c                      |    1 +
>  arch/sparc/kernel/ds.c                          |   31 ++-
>  arch/sparc/kernel/entry.h                       |   14 +
>  arch/sparc/kernel/head_64.S                     |   33 +++-
>  arch/sparc/kernel/hvapi.c                       |    7 +
>  arch/sparc/kernel/hvcalls.S                     |    7 +
>  arch/sparc/kernel/kernel.h                      |   15 +
>  arch/sparc/kernel/ktlb.S                        |   24 +-
>  arch/sparc/kernel/mdesc.c                       |   30 ++-
>  arch/sparc/kernel/pcr.c                         |   11 +-
>  arch/sparc/kernel/perf_event.c                  |    3 +-
>  arch/sparc/kernel/setup_64.c                    |  186 +++++++++++++
>  arch/sparc/kernel/sparc_ksyms_64.c              |   11 +
>  arch/sparc/kernel/sstate.c                      |    9 +-
>  arch/sparc/kernel/unaligned_64.c                |   15 +-
>  arch/sparc/kernel/vmlinux.lds.S                 |   21 ++-
>  arch/sparc/lib/Makefile                         |    4 +-
>  arch/sparc/lib/NG2page.S                        |   61 ----
>  arch/sparc/lib/NGpage.S                         |  114 +++++---
>  arch/sparc/lib/ffs.S                            |   84 ++++++
>  arch/sparc/lib/hweight.S                        |   51 ++++
>  arch/sparc/mm/init_64.c                         |   42 +++-
>  arch/x86/xen/Makefile                           |    2 +-
>  arch/x86/xen/enlighten.c                        |    8 +
>  arch/x86/xen/vga.c                              |   67 +++++
>  arch/x86/xen/xen-ops.h                          |   11 +
>  crypto/md5.c                                    |   92 +------
>  drivers/char/random.c                           |  334 +----------------------
>  drivers/gpu/drm/drm_edid.c                      |   24 ++-
>  drivers/gpu/drm/i915/i915_dma.c                 |    6 +-
>  drivers/gpu/drm/i915/i915_irq.c                 |    3 +
>  drivers/gpu/drm/i915/intel_display.c            |    8 +-
>  drivers/gpu/drm/i915/intel_panel.c              |    4 +
>  drivers/gpu/drm/i915/intel_ringbuffer.c         |    3 +
>  drivers/gpu/drm/radeon/radeon_connectors.c      |   54 ++++-
>  drivers/gpu/drm/radeon/radeon_device.c          |    5 +-
>  drivers/gpu/drm/radeon/radeon_display.c         |    9 +
>  drivers/gpu/drm/radeon/radeon_i2c.c             |   32 ++-
>  drivers/gpu/drm/radeon/radeon_mode.h            |    6 +-
>  drivers/isdn/i4l/isdn_net.c                     |    3 +
>  drivers/net/Makefile                            |    1 +
>  drivers/net/bonding/bond_main.c                 |    6 +-
>  drivers/net/bonding/bond_sysfs.c                |  133 +++++-----
>  drivers/net/e1000e/lib.c                        |    3 +-
>  drivers/net/gianfar_ptp.c                       |    9 +-
>  drivers/net/ifb.c                               |    2 +-
>  drivers/net/macvlan.c                           |    2 +-
>  drivers/net/niu.c                               |    4 +-
>  drivers/net/phy/dp83640.c                       |    5 +-
>  drivers/net/r8169.c                             |    1 +
>  drivers/net/sis190.c                            |   12 +-
>  drivers/net/tun.c                               |    1 +
>  drivers/net/veth.c                              |    2 +
>  drivers/net/wan/hdlc_fr.c                       |    5 +-
>  drivers/net/wireless/airo.c                     |    1 +
>  drivers/net/wireless/ath/ath9k/ar9002_hw.c      |    6 +-
>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c  |    6 +-
>  drivers/net/wireless/ath/ath9k/ar9003_hw.c      |    6 +-
>  drivers/net/wireless/ath/ath9k/ar9003_phy.h     |    2 +-
>  drivers/net/wireless/ath/ath9k/hw.c             |   11 +-
>  drivers/net/wireless/ath/ath9k/hw.h             |    3 +-
>  drivers/net/wireless/ath/ath9k/init.c           |    2 +
>  drivers/net/wireless/ath/ath9k/pci.c            |   27 ++
>  drivers/net/wireless/hostap/hostap_main.c       |    1 +
>  drivers/net/wireless/iwlegacy/iwl-3945.c        |    6 +-
>  drivers/net/wireless/iwlegacy/iwl-4965.c        |    8 +-
>  drivers/net/wireless/iwlwifi/iwl-5000.c         |    1 +
>  drivers/net/wireless/iwlwifi/iwl-core.h         |    2 +
>  drivers/net/wireless/iwlwifi/iwl-power.c        |    3 +-
>  drivers/net/wireless/rt2x00/rt2800lib.c         |    3 +-
>  drivers/net/wireless/rt2x00/rt2x00mac.c         |    5 +-
>  drivers/net/wireless/rtlwifi/pci.c              |   20 +-
>  drivers/platform/x86/asus-wmi.c                 |   17 +-
>  drivers/scsi/mpt2sas/mpt2sas_base.c             |   65 ++---
>  drivers/scsi/mpt2sas/mpt2sas_base.h             |   53 ++++-
>  drivers/scsi/mpt2sas/mpt2sas_ctl.c              |   10 +-
>  drivers/scsi/mpt2sas/mpt2sas_debug.h            |    2 +-
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c            |   12 +-
>  drivers/scsi/mpt2sas/mpt2sas_transport.c        |   24 +-
>  drivers/staging/ath6kl/os/linux/ar6000_drv.c    |    1 +
>  fs/cifs/cifsfs.c                                |    4 +
>  fs/cifs/inode.c                                 |   14 +-
>  fs/cifs/transport.c                             |    2 +
>  fs/ecryptfs/main.c                              |   23 ++-
>  fs/ecryptfs/read_write.c                        |   18 +-
>  fs/ext3/namei.c                                 |    6 +-
>  fs/ext4/namei.c                                 |    6 +-
>  include/drm/drm_crtc.h                          |    1 +
>  include/drm/i915_drm.h                          |    2 +-
>  include/linux/cryptohash.h                      |    5 +
>  include/linux/if.h                              |    2 +
>  include/linux/mm.h                              |   12 +-
>  include/linux/random.h                          |   11 -
>  include/net/ipv6.h                              |   12 +-
>  include/net/secure_seq.h                        |   20 ++
>  include/net/transp_v6.h                         |    2 +
>  include/xen/interface/xen.h                     |   39 +++
>  kernel/futex.c                                  |   54 +++-
>  lib/Makefile                                    |    2 +-
>  lib/md5.c                                       |   95 +++++++
>  net/8021q/vlan_dev.c                            |    2 +-
>  net/bluetooth/bnep/netdev.c                     |    1 +
>  net/core/Makefile                               |    2 +-
>  net/core/link_watch.c                           |    2 +-
>  net/core/pktgen.c                               |    8 +-
>  net/core/secure_seq.c                           |  184 +++++++++++++
>  net/dccp/ipv4.c                                 |    1 +
>  net/dccp/ipv6.c                                 |    9 +-
>  net/ethernet/eth.c                              |    1 +
>  net/ipv4/devinet.c                              |   16 +-
>  net/ipv4/gre.c                                  |   21 +-
>  net/ipv4/icmp.c                                 |   14 +-
>  net/ipv4/igmp.c                                 |    2 +-
>  net/ipv4/inet_hashtables.c                      |    1 +
>  net/ipv4/inetpeer.c                             |    1 +
>  net/ipv4/ip_output.c                            |    6 +-
>  net/ipv4/ipmr.c                                 |    2 +-
>  net/ipv4/netfilter/nf_nat_proto_common.c        |    1 +
>  net/ipv4/route.c                                |    6 +-
>  net/ipv4/tcp_ipv4.c                             |    1 +
>  net/ipv6/af_inet6.c                             |    2 +
>  net/ipv6/inet6_hashtables.c                     |    1 +
>  net/ipv6/ip6_output.c                           |   40 +++-
>  net/ipv6/tcp_ipv6.c                             |    1 +
>  net/ipv6/udp.c                                  |    2 +-
>  net/l2tp/l2tp_eth.c                             |    2 +-
>  net/mac80211/iface.c                            |    1 +
>  net/netfilter/ipvs/ip_vs_ctl.c                  |    1 +
>  net/sched/sch_sfq.c                             |    7 +-
>  net/socket.c                                    |   73 +++---
>  net/xfrm/xfrm_algo.c                            |    4 +-
>  sound/core/timer.c                              |    2 +
>  sound/soc/codecs/sgtl5000.c                     |  128 +++-------
>  sound/usb/caiaq/input.c                         |    2 +-
>  sound/usb/endpoint.c                            |    2 +-
>  sound/usb/mixer.c                               |   25 +-
>  sound/usb/mixer.h                               |    1 +
>  157 files changed, 1967 insertions(+), 1173 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
