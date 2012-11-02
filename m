Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763193Ab2KBRNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:13:30 -0400
Received: from mail.kernel.org ([198.145.19.201]:33234 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932557Ab2KBRHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:07:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/24] 3.6.6-stable review
Date: Fri,  2 Nov 2012 10:06:48 -0700
Message-Id: <20121102170247.406319110@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.6.6 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Nov  4 17:02:39 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.6.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.6.6-rc1

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau: headless mode by default if pci class != vga display

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau: fix suspend/resume when in headless mode

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau: silence modesetting spam on pre-gf8 chipsets

Jiri Slaby <jslaby@suse.cz>
    HID: microsoft: fix invalid rdesc for 3k kbd

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix double-free of se_cmd in target_complete_tmr_failure

Bernhard Kohl <bernhard.kohl@nsn.com>
    target: reintroduce some obsolete SCSI-2 commands

Roland Dreier <roland@purestorage.com>
    qla2xxx: Update target lookup session tables when a target session changes

Paul Bolle <pebolle@tiscali.nl>
    USB: io_edgeport: remove unused variable

Johan Hovold <jhovold@gmail.com>
    USB: iuu_phoenix: fix backported patches

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix port-data memory leak

Alex Elder <elder@inktank.com>
    ceph: avoid 32-bit page index overflow

Sage Weil <sage@inktank.com>
    libceph: check for invalid mapping

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: Fix oops when handling mdsmap that decreases max_mds

David Zafman <david.zafman@inktank.com>
    ceph: fix dentry reference leak in encode_fh()

Sage Weil <sage@inktank.com>
    libceph: avoid NULL kref_put when osd reset races with alloc_msg

Alex Elder <elder@inktank.com>
    rbd: reset BACKOFF if unable to re-queue

Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
    floppy: properly handle failure on add_disk loop

Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
    floppy: do put_disk on current dr if blk_init_queue fails

Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
    floppy: don't call alloc_ordered_workqueue inside the alloc_disk loop

NeilBrown <neilb@suse.de>
    md/raid1: Fix assembling of arrays containing Replacements.

Mathias Nyman <mathias.nyman@linux.intel.com>
    gpiolib: Don't return -EPROBE_DEFER to sysfs, or for invalid gpios

Dan Carpenter <dan.carpenter@oracle.com>
    gpio-timberdale: fix a potential wrapping issue

Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
    blkcg: Fix use-after-free of q->root_blkg and q->root_rl.blkg

Eric Sandeen <sandeen@redhat.com>
    ext4: fix unjournaled inode bitmap modification


-------------

Diffstat:

 Makefile                                |   4 +-
 block/blk-cgroup.c                      |   7 ++
 drivers/block/floppy.c                  |  27 +++--
 drivers/gpio/gpio-timberdale.c          |   4 +-
 drivers/gpio/gpiolib.c                  |  10 +-
 drivers/gpu/drm/nouveau/nouveau_drv.c   |  20 ++--
 drivers/gpu/drm/nouveau/nouveau_state.c |   4 +-
 drivers/gpu/drm/nouveau/nv04_dac.c      |   8 +-
 drivers/gpu/drm/nouveau/nv04_dfp.c      |   6 +-
 drivers/gpu/drm/nouveau/nv04_tv.c       |   4 +-
 drivers/hid/hid-microsoft.c             |  18 ++-
 drivers/md/raid1.c                      |   2 +-
 drivers/scsi/qla2xxx/qla_target.c       |  25 ++--
 drivers/scsi/qla2xxx/qla_target.h       |   1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c      |  73 ++++++++++++
 drivers/target/target_core_sbc.c        |  18 +++
 drivers/target/target_core_transport.c  |   1 -
 drivers/usb/serial/io_edgeport.c        |   1 -
 drivers/usb/serial/iuu_phoenix.c        |   3 +-
 drivers/usb/serial/mos7840.c            | 198 ++++++++++++--------------------
 fs/ceph/addr.c                          |  11 +-
 fs/ceph/export.c                        |   2 +
 fs/ceph/mds_client.c                    |   3 +-
 fs/ext4/ialloc.c                        |  19 ++-
 include/linux/ceph/osd_client.h         |   2 +-
 include/linux/ceph/osdmap.h             |   6 +-
 net/ceph/messenger.c                    |   6 +-
 net/ceph/osd_client.c                   |  32 ++++--
 net/ceph/osdmap.c                       |  18 ++-
 29 files changed, 310 insertions(+), 223 deletions(-)


