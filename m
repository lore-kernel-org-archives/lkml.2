Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab2KOEJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:09:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:48223 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab2KOEJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:09:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/38] 3.0.52-stable review
Date: Wed, 14 Nov 2012 20:09:57 -0800
Message-Id: <20121115040932.918082372@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.52 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Nov 17 04:09:25 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.52-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.52-rc1

Roland Dreier <roland@purestorage.com>
    intel-iommu: Fix AB-BA lockdep report

Dave Chinner <dchinner@redhat.com>
    xfs: fix reading of wrapped log data

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: remove unused variable

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: clear the entire sdvo infoframe buffer

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: fixup infoframe support for sdvo

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Fix hibernation device reset

Thomas Gleixner <tglx@linutronix.de>
    futex: Handle futex_pi OWNER_DIED take over correctly

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: send unsolicited neighbour advertisements to all-nodes

Tom Parkin <tparkin@katalix.com>
    l2tp: fix oops in l2tp_eth_create() error path

Jesper Dangaard Brouer <brouer@redhat.com>
    net: fix divide by zero in tcp algorithm illinois

Hemant Kumar <hemantk@codeaurora.org>
    net: usb: Fix memory leak on Tx data path

Li RongQing <roy.qing.li@gmail.com>
    ipv6: Set default hoplimit as zero.

Eric Dumazet <edumazet@google.com>
    tcp: fix FIONREAD/SIOCINQ

Eric Dumazet <edumazet@google.com>
    netlink: use kfree_rcu() in netlink_release()

Zijie Pan <zijie.pan@6wind.com>
    sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpreter()

Takashi Iwai <tiwai@suse.de>
    ALSA: Avoid endless sleep after disconnect

Takashi Iwai <tiwai@suse.de>
    ALSA: Add a reference counter to card instance

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix races at disconnection in mixer_quirks.c

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Use rwsem for disconnect protection

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix races at disconnection

Takashi Iwai <tiwai@suse.de>
    ALSA: PCM: Fix some races at disconnection

Jean Delvare <khali@linux-fr.org>
    hwmon: (w83627ehf) Force initial bank selection

Ilija Hadzic <ilijahadzic@gmail.com>
    drm: restore open_count if drm_setup fails

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFS: Fix Oopses in nfs_lookup_revalidate and nfs4_lookup_revalidate

NeilBrown <neilb@suse.de>
    NFS: fix bug in legacy DNS resolver.

J. Bruce Fields <bfields@redhat.com>
    nfsd: add get_uint for u32's

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: nfs4_locku_done must release the sequence id

Ben Hutchings <ben@decadent.org.uk>
    nfs: Show original device name verbatim in /proc/*/mount{s,info}

Scott Mayhew <smayhew@redhat.com>
    nfsv3: Make v3 mounts fail with ETIMEDOUTs instead EIO on mountd timeouts

Antonio Quartulli <ordex@autistici.org>
    mac80211: fix SSID copy on IBSS JOIN

Johannes Berg <johannes.berg@intel.com>
    mac80211: check management frame header length

Egbert Eich <eich@suse.de>
    DRM/Radeon: Fix Load Detection on legacy primary DAC.

Javier Cardona <javier@cozybit.com>
    mac80211: don't inspect Sequence Control field on control frames

Johannes Berg <johannes.berg@intel.com>
    wireless: drop invalid mesh address extension frames

Felix Fietkau <nbd@openwrt.org>
    cfg80211: fix antenna gain handling

Roland Dreier <roland@purestorage.com>
    target: Don't return success from module_init() if setup fails

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2800: validate step value for temperature compensation

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix stale pointers potentially causing access to free'd skbs


-------------

Diffstat:

 Makefile                                        |  4 +-
 drivers/gpu/drm/drm_fops.c                      |  5 +-
 drivers/gpu/drm/i915/intel_drv.h                |  2 +-
 drivers/gpu/drm/i915/intel_sdvo.c               | 59 ++++++++++++++++------
 drivers/gpu/drm/i915/intel_sdvo_regs.h          |  2 +
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |  1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c             |  5 ++
 drivers/hwmon/w83627ehf.c                       |  1 +
 drivers/net/usb/usbnet.c                        |  3 ++
 drivers/net/wireless/ath/ath9k/xmit.c           |  2 +
 drivers/net/wireless/rt2x00/rt2800lib.c         |  2 +-
 drivers/pci/intel-iommu.c                       |  4 +-
 drivers/target/target_core_configfs.c           |  3 +-
 drivers/usb/serial/mos7840.c                    |  1 -
 fs/nfs/dir.c                                    |  4 +-
 fs/nfs/dns_resolve.c                            |  5 +-
 fs/nfs/internal.h                               |  5 +-
 fs/nfs/mount_clnt.c                             |  2 +-
 fs/nfs/namespace.c                              | 19 ++++++--
 fs/nfs/nfs4namespace.c                          |  3 +-
 fs/nfs/nfs4proc.c                               |  1 +
 fs/nfs/super.c                                  |  2 +-
 fs/nfsd/export.c                                |  6 +--
 fs/xfs/xfs_log_recover.c                        |  2 +-
 include/linux/sunrpc/cache.h                    | 16 ++++++
 include/sound/core.h                            |  3 ++
 kernel/futex.c                                  | 41 ++++++++--------
 net/ipv4/tcp.c                                  |  8 ++-
 net/ipv4/tcp_illinois.c                         |  8 +--
 net/ipv6/ndisc.c                                |  3 +-
 net/ipv6/route.c                                |  4 +-
 net/l2tp/l2tp_eth.c                             |  1 +
 net/mac80211/ibss.c                             |  2 +-
 net/mac80211/rx.c                               | 16 ++++--
 net/netlink/af_netlink.c                        | 19 ++++++--
 net/sctp/sm_sideeffect.c                        |  3 +-
 net/wireless/core.c                             |  3 +-
 net/wireless/util.c                             | 11 +++--
 sound/core/control.c                            |  5 ++
 sound/core/hwdep.c                              | 12 ++++-
 sound/core/init.c                               | 50 +++++++++++--------
 sound/core/oss/mixer_oss.c                      | 10 +++-
 sound/core/oss/pcm_oss.c                        |  6 +++
 sound/core/pcm.c                                | 13 ++++-
 sound/core/pcm_native.c                         | 33 ++++++++++---
 sound/core/rawmidi.c                            | 26 +++++++++-
 sound/core/sound.c                              | 11 ++++-
 sound/core/sound_oss.c                          | 10 +++-
 sound/usb/card.c                                | 12 +++--
 sound/usb/card.h                                |  1 +
 sound/usb/mixer.c                               | 65 ++++++++++++++++---------
 sound/usb/mixer_quirks.c                        | 37 ++++++++++++--
 sound/usb/pcm.c                                 | 35 +++++++++----
 sound/usb/proc.c                                |  4 +-
 sound/usb/urb.c                                 |  9 ++--
 sound/usb/usbaudio.h                            |  2 +-
 56 files changed, 451 insertions(+), 171 deletions(-)


