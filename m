Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305Ab2KVWVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:21:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:49344 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519Ab2KVSi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 000/171] 3.4.20-stable review
Date: Wed, 21 Nov 2012 16:39:06 -0800
Message-Id: <20121122004033.298367941@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.20 release.
There are 171 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Nov 24 00:36:21 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.20-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.20-rc1

Felipe Balbi <balbi@ti.com>
    Revert "serial: omap: fix software flow control"

Igor Murzov <e-mail@date.by>
    ACPI video: Ignore errors after _DOD evaluation.

Alex Elder <elder@inktank.com>
    ceph: avoid 32-bit page index overflow

Sage Weil <sage@inktank.com>
    libceph: check for invalid mapping

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: Fix oops when handling mdsmap that decreases max_mds

Sage Weil <sage@inktank.com>
    libceph: avoid NULL kref_put when osd reset races with alloc_msg

Alex Elder <elder@inktank.com>
    rbd: reset BACKOFF if unable to re-queue

Alex Elder <elder@inktank.com>
    libceph: only kunmap kmapped pages

Jim Schutt <jaschut@sandia.gov>
    libceph: avoid truncation due to racing banners

Sage Weil <sage@inktank.com>
    libceph: delay debugfs initialization until we learn global_id

Sylvain Munaut <tnt@246tNt.com>
    libceph: fix crypto key null deref, memory leak

Sage Weil <sage@inktank.com>
    libceph: recheck con state after allocating incoming message

Sage Weil <sage@inktank.com>
    libceph: change ceph_con_in_msg_alloc convention to be less weird

Sage Weil <sage@inktank.com>
    libceph: avoid dropping con mutex before fault

Sage Weil <sage@inktank.com>
    libceph: verify state after retaking con lock after dispatch

Sage Weil <sage@inktank.com>
    libceph: revoke mon_client messages on session restart

Sage Weil <sage@inktank.com>
    libceph: fix handling of immediate socket connect failure

Sage Weil <sage@inktank.com>
    libceph: clear all flags on con_close

Sage Weil <sage@inktank.com>
    libceph: clean up con flags

Sage Weil <sage@inktank.com>
    libceph: replace connection state bits with states

Sage Weil <sage@inktank.com>
    libceph: drop unnecessary CLOSED check in socket state change callback

Sage Weil <sage@inktank.com>
    libceph: close socket directly from ceph_con_close()

Sage Weil <sage@inktank.com>
    libceph: drop gratuitous socket close calls in con_work

Sage Weil <sage@inktank.com>
    libceph: move ceph_con_send() closed check under the con mutex

Sage Weil <sage@inktank.com>
    libceph: move msgr clear_standby under con mutex protection

Sage Weil <sage@inktank.com>
    libceph: fix fault locking; close socket on lossy fault

Sage Weil <sage@inktank.com>
    libceph: reset connection retry on successfully negotiation

Sage Weil <sage@inktank.com>
    libceph: protect ceph_con_open() with mutex

Sage Weil <sage@inktank.com>
    libceph: (re)initialize bio_iter on start of message receive

Sage Weil <sage@inktank.com>
    libceph: resubmit linger ops when pg mapping changes

Sage Weil <sage@inktank.com>
    libceph: fix mutex coverage for ceph_con_close

Sage Weil <sage@inktank.com>
    libceph: report socket read/write error message

Guanjun He <gjhe@suse.com>
    libceph: prevent the race of incoming work during teardown

Sage Weil <sage@inktank.com>
    libceph: initialize msgpool message types

Sage Weil <sage@inktank.com>
    libceph: allow sock transition from CONNECTING to CLOSED

Sage Weil <sage@inktank.com>
    libceph: initialize mon_client con only once

Sage Weil <sage@inktank.com>
    libceph: set peer name on con_open, not init

Alex Elder <elder@inktank.com>
    libceph: add some fine ASCII art

Alex Elder <elder@inktank.com>
    libceph: small changes to messenger.c

Alex Elder <elder@inktank.com>
    libceph: distinguish two phases of connect sequence

Alex Elder <elder@inktank.com>
    libceph: separate banner and connect writes

Alex Elder <elder@inktank.com>
    libceph: define and use an explicit CONNECTED state

Alex Elder <elder@inktank.com>
    libceph: clear NEGOTIATING when done

Alex Elder <elder@inktank.com>
    libceph: clear CONNECTING in ceph_con_close()

Alex Elder <elder@inktank.com>
    libceph: don't touch con state in con_close_socket()

Alex Elder <elder@inktank.com>
    libceph: just set SOCK_CLOSED when state changes

Alex Elder <elder@inktank.com>
    libceph: don't change socket state on sock event

Alex Elder <elder@inktank.com>
    libceph: SOCK_CLOSED is a flag, not a state

Alex Elder <elder@inktank.com>
    libceph: don't use bio_iter as a flag

Alex Elder <elder@inktank.com>
    libceph: move init of bio_iter

Alex Elder <elder@inktank.com>
    libceph: move init_bio_*() functions up

Alex Elder <elder@inktank.com>
    libceph: don't mark footer complete before it is

Alex Elder <elder@inktank.com>
    libceph: encapsulate advancing msg page

Alex Elder <elder@inktank.com>
    libceph: encapsulate out message data setup

Sage Weil <sage@inktank.com>
    libceph: drop ceph_con_get/put helpers and nref member

Sage Weil <sage@inktank.com>
    libceph: use con get/put methods

Dan Carpenter <dan.carpenter@oracle.com>
    libceph: fix NULL dereference in reset_connection()

Sage Weil <sage@inktank.com>
    libceph: transition socket state prior to actual connect

Xi Wang <xi.wang@gmail.com>
    libceph: fix overflow in osdmap_apply_incremental()

Xi Wang <xi.wang@gmail.com>
    libceph: fix overflow in osdmap_decode()

Xi Wang <xi.wang@gmail.com>
    libceph: fix overflow in __decode_pool_names()

Alex Elder <elder@inktank.com>
    libceph: make ceph_con_revoke_message() a msg op

Alex Elder <elder@inktank.com>
    libceph: make ceph_con_revoke() a msg operation

Alex Elder <elder@inktank.com>
    libceph: have messages take a connection reference

Alex Elder <elder@inktank.com>
    libceph: have messages point to their connection

Alex Elder <elder@inktank.com>
    libceph: tweak ceph_alloc_msg()

Alex Elder <elder@inktank.com>
    libceph: fully initialize connection in con_init()

Alex Elder <elder@inktank.com>
    libceph: init monitor connection when opening

Sage Weil <sage@inktank.com>
    libceph: drop connection refcounting for mon_client

Alex Elder <elder@inktank.com>
    libceph: embed ceph connection structure in mon_client

Alex Elder <elder@inktank.com>
    libceph: set CLOSED state bit in con_init

Alex Elder <elder@inktank.com>
    libceph: provide osd number when creating osd

Alex Elder <elder@inktank.com>
    libceph: start tracking connection socket state

Alex Elder <elder@inktank.com>
    libceph: start separating connection flags from state

Alex Elder <elder@inktank.com>
    libceph: embed ceph messenger structure in ceph_client

Alex Elder <elder@inktank.com>
    libceph: rename kvec_reset and kvec_add functions

Alex Elder <elder@inktank.com>
    libceph: rename socket callbacks

Alex Elder <elder@inktank.com>
    libceph: kill bad_proto ceph connection op

Alex Elder <elder@inktank.com>
    libceph: eliminate connection state "DEAD"

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: check PG_Private flag before accessing page->private

Yan, Zheng <zheng.z.yan@intel.com>
    rbd: Fix ceph_snap_context size calculation

Josh Durgin <josh.durgin@dreamhost.com>
    rbd: store snapshot id instead of index

Josh Durgin <josh.durgin@dreamhost.com>
    rbd: protect read of snapshot sequence number

Alex Elder <elder@dreamhost.com>
    rbd: don't hold spinlock during messenger flush

Sage Weil <sage@inktank.com>
    libceph: fix messenger retry

Sage Weil <sage@inktank.com>
    libceph: flush msgr queue during mon_client shutdown

Yan, Zheng <zheng.z.yan@intel.com>
    rbd: Clear ceph_msg->bio_iter for retransmitted message

Sage Weil <sage@inktank.com>
    libceph: use con get/put ops from osd_client

Alex Elder <elder@inktank.com>
    libceph: osd_client: don't drop reply reference too early

Sage Weil <sage@inktank.com>
    libceph: fix pg_temp updates

Sage Weil <sage@inktank.com>
    libceph: avoid unregistering osd request when not registered

Alex Elder <elder@inktank.com>
    ceph: add auth buf in prepare_write_connect()

Alex Elder <elder@inktank.com>
    ceph: rename prepare_connect_authorizer()

Alex Elder <elder@inktank.com>
    ceph: return pointer from prepare_connect_authorizer()

Alex Elder <elder@inktank.com>
    ceph: use info returned by get_authorizer

Alex Elder <elder@inktank.com>
    ceph: have get_authorizer methods return pointers

Alex Elder <elder@inktank.com>
    ceph: ensure auth ops are defined before use

Alex Elder <elder@inktank.com>
    ceph: messenger: reduce args to create_authorizer

Alex Elder <elder@inktank.com>
    ceph: define ceph_auth_handshake type

Alex Elder <elder@inktank.com>
    ceph: messenger: check return from get_authorizer

Alex Elder <elder@inktank.com>
    ceph: messenger: rework prepare_connect_authorizer()

Alex Elder <elder@inktank.com>
    ceph: messenger: check prepare_write_connect() result

Alex Elder <elder@inktank.com>
    ceph: don't set WRITE_PENDING too early

Alex Elder <elder@inktank.com>
    ceph: drop msgr argument from prepare_write_connect()

Alex Elder <elder@inktank.com>
    ceph: messenger: send banner in process_connect()

Alex Elder <elder@inktank.com>
    ceph: messenger: reset connection kvec caller

Alex Elder <elder@inktank.com>
    libceph: don't reset kvec in prepare_write_banner()

Alex Elder <elder@inktank.com>
    ceph: messenger: change read_partial() to take "end" arg

Alex Elder <elder@inktank.com>
    ceph: messenger: update "to" in read_partial() caller

Alex Elder <elder@inktank.com>
    ceph: messenger: use read_partial() in read_partial_message()

Alex Elder <elder@dreawmhost.com>
    ceph: osd_client: fix endianness bug in osd_req_encode_op()

Sage Weil <sage@inktank.com>
    crush: fix memory leak when destroying tree buckets

Sage Weil <sage@inktank.com>
    crush: fix tree node weight lookup

Sage Weil <sage@inktank.com>
    crush: be more tolerant of nonsensical crush maps

Sage Weil <sage@inktank.com>
    crush: adjust local retry threshold

Sage Weil <sage@inktank.com>
    crush: clean up types, const-ness

Dave Jones <davej@redhat.com>
    selinux: fix sel_netnode_insert() suspicious rcu dereference

Jan Kara <jack@suse.cz>
    reiserfs: Protect reiserfs_quota_write() with write lock

Jan Kara <jack@suse.cz>
    reiserfs: Move quota calls out of write lock

Jan Kara <jack@suse.cz>
    reiserfs: Protect reiserfs_quota_on() with write lock

Jan Kara <jack@suse.cz>
    reiserfs: Fix lock ordering during remount

Bryan Schumaker <bjschuma@netapp.com>
    NFS: Wait for session recovery to finish before returning

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: fix overlay on i830M

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/signal: set correct address space control

Mirko Lindner <mlindner@marvell.com>
    sky2: Fix for interrupt handler

Tim Sally <tsally@atomicpeace.com>
    eCryptfs: check for eCryptfs cipher support at mount

Tyler Hicks <tyhicks@canonical.com>
    eCryptfs: Copy up POSIX ACL and read-only flags from lower mount

Jan Safrata <jan.nikitenko@gmail.com>
    usb: use usb_serial_put in usb_serial_probe errors

Ulrich Weber <ulrich.weber@sophos.com>
    netfilter: nf_nat: don't check for port change on ICMP tuples

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
    netfilter: Mark SYN/ACK packets as invalid from original direction

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
    netfilter: Validate the sequence number of dataless ACK packets as well

Nathan Walp <faceprint@faceprint.com>
    r8169: allow multicast packets on sub-8168f chipset.

Cyril Brulebois <kibi@debian.org>
    r8169: Fix WoL on RTL8168d/8111d.

Mojiong Qiu <qiumojiong@gmail.com>
    xen/events: fix RCU warning, or Call idle notifier after irq_enter()

Michal Schmidt <mschmidt@redhat.com>
    r8169: use unlimited DMA burst for TX

Hugh Dickins <hughd@google.com>
    tmpfs: change final i_blocks BUG to WARNING

Tom Herbert <therbert@google.com>
    net-rps: Fix brokeness causing OOO packets

Jiri Pirko <jiri@resnulli.us>
    net: correct check in dev_addr_del()

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: setsockopt(IPIPPROTO_IPV6, IPV6_MINHOPCOUNT) forgot to set return value

Xi Wang <xi.wang@gmail.com>
    ipv4: avoid undefined behavior in do_ip_setsockopt()

Andreas Schwab <schwab@linux-m68k.org>
    m68k: fix sigset_t accessor functions

Johannes Berg <johannes.berg@intel.com>
    wireless: allow 40 MHz on world roaming channels 12/13

Michal Hocko <mhocko@suse.cz>
    memcg: oom: fix totalpages calculation for memory.swappiness==0

Zhao Yakui <yakui.zhao@intel.com>
    ttm: Clear the ttm page allocated from high memory zone correctly

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix logic error in atombios_encoders.c

Dan Williams <dcbw@redhat.com>
    USB: option: add Alcatel X220/X500D USB IDs

Dan Williams <dcbw@redhat.com>
    USB: option: add Novatel E362 and Dell Wireless 5800 USB IDs

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/gup: add missing TASK_SIZE check to get_user_pages_fast()

Colin Cross <ccross@android.com>
    Revert "Staging: Android alarm: IOCTL command encoding fix"

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBIFS: introduce categorized lprops counter

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBIFS: fix mounting problems after power cuts

Misael Lopez Cruz <misael.lopez@ti.com>
    ASoC: dapm: Use card_list during DAPM shutdown

Eric Millbrandt <emillbrandt@dekaresearch.com>
    ASoC: wm8978: pll incorrectly configured when codec is master

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add a missing quirk entry for iMac 9,1

Kailang Yang <kailang@realtek.com>
    ALSA: hda - Add new codec ALC668 and ALC900 (default name ALC1150)

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix invalid connections in VT1802 codec

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix empty DAC filling in patch_via.c

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Force to reset IEC958 status bits for AD codecs

Daniel J Blueman <daniel@quora.org>
    ALSA: HDA: Fix digital microphone on CS420x

Alexander Stein <alexander.stein@systec-electronic.com>
    ALSA: hda: Cirrus: Fix coefficient index for beep configuration

Jacob Keller <jacob.e.keller@intel.com>
    ptp: update adjfreq callback description

Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
    crypto: cryptd - disable softirqs in cryptd_queue_worker to prevent data corruption

Jeff Layton <jlayton@redhat.com>
    cifs: fix potential buffer overrun in cifs.idmap handling code

Rusty Russell <rusty@rustcorp.com.au>
    module: fix out-by-one error in kallsyms

Eric Paris <eparis@redhat.com>
    fanotify: fix missing break

Huang Ying <ying.huang@intel.com>
    PCI/PM: Fix deadlock when unbinding device if parent in D3cold

Felix Fietkau <nbd@openwrt.org>
    mac80211: call skb_dequeue/ieee80211_free_txskb instead of __skb_queue_purge

Johannes Berg <johannes.berg@intel.com>
    mac80211: don't send null data packet when not associated

Arik Nemtsov <arik@wizery.com>
    mac80211: sync acccess to tx_filtered/ps_tx_buf queues

Dave Chinner <dchinner@redhat.com>
    xfs: drop buffer io reference when a bad bio is built

Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>
    mm: bugfix: set current->reclaim_state to NULL while returning from kswapd()


-------------

Diffstat:

 Documentation/cgroups/memory.txt              |    4 +
 Makefile                                      |    4 +-
 arch/arm/plat-omap/include/plat/omap-serial.h |    4 +-
 arch/m68k/include/asm/signal.h                |    6 +-
 arch/s390/include/asm/compat.h                |    2 +-
 arch/s390/include/asm/ptrace.h                |    4 +-
 arch/s390/kernel/compat_signal.c              |   14 +-
 arch/s390/kernel/signal.c                     |   14 +-
 arch/s390/mm/gup.c                            |    2 +-
 crypto/cryptd.c                               |   11 +-
 drivers/acpi/video.c                          |   11 +-
 drivers/block/rbd.c                           |   37 +-
 drivers/gpu/drm/i915/intel_overlay.c          |   14 +-
 drivers/gpu/drm/radeon/atombios_encoders.c    |    2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c          |    5 +-
 drivers/net/ethernet/marvell/sky2.c           |    4 +-
 drivers/net/ethernet/realtek/r8169.c          |    7 +-
 drivers/pci/bus.c                             |    3 -
 drivers/pci/pcie/aer/aerdrv_core.c            |   20 +-
 drivers/staging/android/android_alarm.h       |    4 +-
 drivers/tty/serial/omap-serial.c              |   12 +-
 drivers/usb/serial/option.c                   |    9 +
 drivers/usb/serial/usb-serial.c               |    6 +-
 drivers/xen/events.c                          |    2 +-
 fs/ceph/addr.c                                |   32 +-
 fs/ceph/debugfs.c                             |    1 +
 fs/ceph/mds_client.c                          |   67 +-
 fs/ceph/mds_client.h                          |    5 +-
 fs/cifs/cifsacl.c                             |   49 +-
 fs/ecryptfs/main.c                            |   23 +-
 fs/nfs/nfs4proc.c                             |    3 +-
 fs/notify/fanotify/fanotify.c                 |    1 +
 fs/reiserfs/inode.c                           |   10 +-
 fs/reiserfs/stree.c                           |    4 +
 fs/reiserfs/super.c                           |   60 +-
 fs/ubifs/find.c                               |   12 +-
 fs/ubifs/lprops.c                             |    6 +
 fs/ubifs/ubifs.h                              |    3 +
 fs/xfs/xfs_buf.c                              |   14 +-
 include/linux/ceph/auth.h                     |   12 +-
 include/linux/ceph/libceph.h                  |    2 +-
 include/linux/ceph/messenger.h                |   76 +-
 include/linux/ceph/mon_client.h               |    2 +-
 include/linux/ceph/msgpool.h                  |    3 +-
 include/linux/ceph/osd_client.h               |   13 +-
 include/linux/ceph/osdmap.h                   |    6 +-
 include/linux/crush/crush.h                   |    7 +-
 include/linux/crush/mapper.h                  |    6 +-
 include/linux/ptp_clock_kernel.h              |    3 +-
 kernel/module.c                               |   27 +-
 mm/memcontrol.c                               |   21 +-
 mm/shmem.c                                    |    2 +-
 mm/vmscan.c                                   |    2 +
 net/ceph/auth_none.c                          |   15 +-
 net/ceph/auth_x.c                             |   15 +-
 net/ceph/ceph_common.c                        |   28 +-
 net/ceph/crush/crush.c                        |   14 +-
 net/ceph/crush/mapper.c                       |   66 +-
 net/ceph/crypto.c                             |    1 +
 net/ceph/crypto.h                             |    3 +-
 net/ceph/debugfs.c                            |    4 +
 net/ceph/messenger.c                          | 1103 +++++++++++++++----------
 net/ceph/mon_client.c                         |  135 ++-
 net/ceph/msgpool.c                            |    7 +-
 net/ceph/osd_client.c                         |  175 ++--
 net/ceph/osdmap.c                             |   44 +-
 net/core/dev.c                                |    4 +-
 net/core/dev_addr_lists.c                     |    3 +-
 net/ipv4/ip_sockglue.c                        |   35 +-
 net/ipv4/netfilter/nf_nat_standalone.c        |    6 +-
 net/ipv6/ipv6_sockglue.c                      |    1 +
 net/mac80211/ieee80211_i.h                    |    2 +
 net/mac80211/sta_info.c                       |   11 +-
 net/mac80211/status.c                         |    9 +
 net/mac80211/tx.c                             |    9 +-
 net/mac80211/util.c                           |    2 +
 net/netfilter/nf_conntrack_proto_tcp.c        |   29 +-
 net/wireless/reg.c                            |    5 +-
 security/selinux/netnode.c                    |    3 +-
 sound/pci/hda/patch_analog.c                  |    1 +
 sound/pci/hda/patch_cirrus.c                  |   16 +-
 sound/pci/hda/patch_realtek.c                 |    3 +
 sound/pci/hda/patch_via.c                     |   25 +-
 sound/soc/codecs/wm8978.c                     |    2 +-
 sound/soc/soc-dapm.c                          |    2 +-
 85 files changed, 1506 insertions(+), 945 deletions(-)


