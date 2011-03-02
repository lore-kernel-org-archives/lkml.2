Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab1CBQuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:50:22 -0500
Received: from adelie.canonical.com ([91.189.90.139]:48170 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1CBQuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:50:20 -0500
Message-ID: <4D6E7548.807@canonical.com>
Date: Wed, 02 Mar 2011 17:50:16 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.32.30
References: <20110302145828.GA4999@kroah.com>
In-Reply-To: <20110302145828.GA4999@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 03:58 PM, Greg KH wrote:
> I'm announcing the release of the 2.6.32.30 kernel.
> 
> All users of the 2.6.32 kernel series must upgrade.
> 
> Many thanks again to Maximilian Attems who dug around in a lot of
> different distro kernels and forwarded to me the original git commit ids
> that should be applied to this tree.  Red Hat didn't make this very
> easy due to their "one giant patch" format, and his skill is helping
> everyone out here.  It's much appreciated.
> 
> The updated 2.6.32.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
> and can be browsed at the normal kernel.org git web browser:
>         http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary
> 
> thanks,
> 
> greg k-h
> 
> ------------
> 
>  Makefile                                   |    2 
>  arch/arm/kernel/signal.c                   |    4 
>  arch/s390/include/asm/processor.h          |    5 
>  arch/s390/kernel/traps.c                   |   37 ---
>  arch/x86/include/asm/acpi.h                |    1 
>  arch/x86/include/asm/pvclock.h             |    1 
>  arch/x86/kernel/acpi/boot.c                |   14 +
>  arch/x86/kernel/early-quirks.c             |   16 -
>  arch/x86/kernel/hpet.c                     |   12 +
>  arch/x86/kernel/pvclock.c                  |    5 
>  arch/x86/xen/time.c                        |    2 
>  drivers/block/pktcdvd.c                    |    2 
>  drivers/isdn/hisax/config.c                |   18 +
>  drivers/isdn/hisax/hisax.h                 |    1 
>  drivers/md/dm-raid1.c                      |    2 
>  drivers/md/dm-region-hash.c                |    5 
>  drivers/md/md.c                            |    3 
>  drivers/media/dvb/ttpci/av7110_ca.c        |    2 
>  drivers/media/radio/radio-aimslab.c        |    1 
>  drivers/message/fusion/mptctl.c            |    8 
>  drivers/message/fusion/mptscsih.c          |    7 
>  drivers/net/benet/be.h                     |    2 
>  drivers/net/benet/be_main.c                |   18 -
>  drivers/net/bonding/bond_ipv6.c            |    9 
>  drivers/net/ixgbe/ixgbe_82599.c            |    1 
>  drivers/net/ixgbe/ixgbe_main.c             |    3 
>  drivers/net/ixgbe/ixgbe_type.h             |    1 
>  drivers/net/wireless/p54/p54pci.c          |   14 -
>  drivers/platform/x86/acer-wmi.c            |    4 
>  drivers/platform/x86/asus_acpi.c           |    8 
>  drivers/platform/x86/tc1100-wmi.c          |    2 
>  drivers/scsi/device_handler/scsi_dh_alua.c |    2 
>  drivers/staging/usbip/vhci.h               |    6 
>  drivers/staging/usbip/vhci_hcd.c           |   54 ++++-
>  drivers/staging/usbip/vhci_rx.c            |   15 -
>  drivers/usb/core/hcd-pci.c                 |    4 
>  drivers/usb/core/quirks.c                  |    8 
>  drivers/usb/host/ohci-hcd.c                |    9 
>  drivers/usb/host/ohci-pci.c                |   18 +
>  drivers/usb/host/ohci.h                    |    1 
>  drivers/usb/host/pci-quirks.c              |   18 +
>  drivers/usb/host/xhci-ring.c               |   36 ++-
>  drivers/usb/musb/omap2430.c                |    1 
>  drivers/usb/serial/sierra.c                |    3 
>  drivers/usb/serial/visor.c                 |   12 +
>  fs/ecryptfs/inode.c                        |    2 
>  fs/eventpoll.c                             |   95 +++++++++
>  fs/file_table.c                            |    2 
>  fs/gfs2/bmap.c                             |    2 
>  fs/nfs/file.c                              |    2 
>  fs/nfsd/nfs4xdr.c                          |    8 
>  fs/nfsd/vfs.c                              |    2 
>  fs/ocfs2/stack_user.c                      |    2 
>  fs/partitions/ldm.c                        |    5 
>  fs/partitions/mac.c                        |   17 -
>  fs/proc/array.c                            |    5 
>  fs/read_write.c                            |    2 
>  fs/splice.c                                |   24 +-
>  fs/xfs/linux-2.6/xfs_export.c              |   11 -
>  fs/xfs/linux-2.6/xfs_ioctl.c               |    7 
>  fs/xfs/linux-2.6/xfs_ioctl32.c             |   15 -
>  fs/xfs/quota/xfs_qm.c                      |   18 -
>  fs/xfs/quota/xfs_qm_syscalls.c             |   27 +-
>  fs/xfs/xfs_ialloc.c                        |  150 ++++++++-------
>  fs/xfs/xfs_iget.c                          |   10 -
>  fs/xfs/xfs_inode.c                         |    5 
>  fs/xfs/xfs_inode.h                         |    6 
>  fs/xfs/xfs_itable.c                        |  284 ++++-------------------------
>  fs/xfs/xfs_itable.h                        |   17 -
>  fs/xfs/xfs_log_recover.c                   |    2 
>  fs/xfs/xfs_mount.c                         |    2 
>  fs/xfs/xfs_rtalloc.c                       |    4 
>  fs/xfs/xfs_trans_inode.c                   |    2 
>  fs/xfs/xfs_vnodeops.c                      |    2 
>  include/linux/cred.h                       |   21 --
>  kernel/cred.c                              |   41 +++-
>  kernel/irq/manage.c                        |    2 
>  kernel/power/snapshot.c                    |    7 
>  lib/swiotlb.c                              |    6 
>  net/core/filter.c                          |   64 +++---
>  net/ipv4/tcp.c                             |    2 
>  net/sctp/auth.c                            |    8 
>  net/sunrpc/cache.c                         |    4 
>  net/x25/x25_link.c                         |    4 
>  security/selinux/hooks.c                   |    6 
>  sound/pci/hda/hda_intel.c                  |    1 
>  sound/usb/caiaq/audio.c                    |    2 
>  sound/usb/caiaq/midi.c                     |    2 
>  88 files changed, 669 insertions(+), 628 deletions(-)
> 
> 
> Ajit Khaparde (1):
>       be2net: Maintain tx and rx counters in driver
> 
> Alan Stern (2):
>       OHCI: work around for nVidia shutdown problem
>       USB: add quirks entry for Keytouch QWERTY Panel
> 
> Andreas Herrmann (1):
>       x86 quirk: Fix polarity for IRQ0 pin2 override on SB800 systems
> 
> Apollon Oikonomopoulos (1):
>       x25: decrement netdev reference counts on unload
> 
> Ben Hutchings (1):
>       bonding/vlan: Avoid mangled NAs on slaves without VLAN tag insertion
> 
> Brian King (1):
>       scsi_dh_alua: Add IBM Power Virtual SCSI ALUA device to dev list
> 
> Changli Gao (1):
>       sendfile(): check f_op.splice_write() rather than f_op.sendpage()
> 
> Christian Lamparter (1):
>       p54pci: update receive dma buffers before and after processing
> 
> Christoph Hellwig (1):
>       xfs: always use iget in bulkstat
> 
> Dan Carpenter (1):
>       av7110: check for negative array offset
> 
> Dan Rosenberg (2):
>       sctp: Fix out-of-bounds reading in sctp_asoc_get_hmac()
>       Fix pktcdvd ioctl dev_minor range check
> 
> Dave Chinner (4):
>       xfs: validate untrusted inode numbers during lookup
>       xfs: rename XFS_IGET_BULKSTAT to XFS_IGET_UNTRUSTED
>       xfs: remove block number from inode lookup code
>       xfs: fix untrusted inode number lookup
> 
> David Henningsson (1):
>       ALSA: HDA: Add position_fix quirk for an Asus device
> 
> David Howells (1):
>       CRED: Fix get_task_cred() and task_state() to not resurrect dead credentials
> 
> David S. Miller (4):
>       filter: make sure filters dont read uninitialized memory
>       tcp: Increase TCP_MAXSEG socket option minimum.
>       tcp: Make TCP_MAXSEG minimum more correct.
>       x25: Do not reference freed memory.
> 
> Davide Libenzi (1):
>       epoll: prevent creating circular epoll structures
> 
> Don Skidmore (1):
>       ixgbe: add support for 82599 based Express Module X520-P2
> 

> FUJITA Tomonori (1):
>       swiotlb: fix wrong panic
>

This one breaks compilation of 64bit for me as swiotlb_tbl_unmap_single() does
not exist. It does not look like it is a simple single patch that would get it
back to 2.6.32.

-Stefan

> Geert Uytterhoeven (1):
>       radio-aimslab.c needs #include <linux/delay.h>
> 
> Greg Kroah-Hartman (1):
>       Linux 2.6.32.30
> 
> J. R. Okajima (1):
>       NFS: fix the return value of nfs_file_fsync()
> 
> Jeremy Fitzhardinge (1):
>       x86/pvclock: Zero last_value on resume
> 
> Johan Hovold (1):
>       usb: musb: omap2430: fix kernel panic on reboot
> 
> Jon Thomas (1):
>       sierra: add new ID for Airprime/Sierra USB IP modem
> 
> Kashyap, Desai (2):
>       mptfusion: mptctl_release is required in mptctl.c
>       mptfusion: Fix Incorrect return value in mptscsih_dev_reset
> 
> Konstantin Khorenko (1):
>       NFSD: memory corruption due to writing beyond the stat array
> 
> Li Zefan (1):
>       sunrpc/cache: fix module refcnt leak in a failure path
> 
> Maciej Szmigiero (2):
>       USB: Add Samsung SGH-I500/Android modem ID switch to visor driver
>       USB: Add quirk for Samsung Android phone modem
> 
> Martin Schwidefsky (1):
>       s390: remove task_show_regs
> 
> Matthew Garrett (1):
>       acer-wmi: Fix capitalisation of GUID
> 
> Max Vozeler (4):
>       staging: usbip: vhci: update reference count for usb_device
>       staging: usbip: vhci: give back URBs from in-flight unlink requests
>       staging: usbip: vhci: refuse to enqueue for dead connections
>       staging: usbip: vhci: use urb->dev->portnum to find port
> 
> Mike Christie (1):
>       scsi_dh_alua: add netapp to dev list
> 
> Mikulas Patocka (1):
>       dm raid1: fail writes if errors are not handled and log fails
> 
> Milton Miller (1):
>       ixgbe: prevent speculative processing of descriptors before ready
> 
> NeilBrown (2):
>       nfsd: correctly handle return value from nfsd_map_name_to_*
>       md: correctly handle probe of an 'mdp' device.
> 
> Paul Zimmerman (4):
>       xhci: Avoid BUG() in interrupt context
>       xhci: Clarify some expressions in the TRB math
>       xhci: Fix errors in the running total calculations in the TRB math
>       xhci: Fix an error in count_sg_trbs_needed()
> 
> Russell King (1):
>       ARM: Ensure predictable endian state on signal handler entry
> 
> Shaohua Li (1):
>       x86, hpet: Disable per-cpu hpet timer if ARAT is supported
> 
> Stanislaw Gruszka (1):
>       PM / Hibernate: Return error code when alloc_image_page() fails
> 
> Steven Whitehouse (1):
>       GFS2: Fix bmap allocation corner-case bug
> 
> Takahiro Yasui (1):
>       dm raid1: fix null pointer dereference in suspend
> 
> Takashi Iwai (1):
>       ALSA: caiaq - Fix possible string-buffer overflow
> 
> Tetsuo Handa (3):
>       CRED: Fix kernel panic upon security_file_alloc() failure.
>       CRED: Fix BUG() upon security_cred_alloc_blank() failure
>       CRED: Fix memory and refcount leaks upon security_prepare_creds() failure
> 
> Thomas Gleixner (2):
>       isdn: hisax: Replace the bogus access to irq stats
>       genirq: Disable the SHIRQ_DEBUG call in request_threaded_irq for now
> 
> Timo Warns (2):
>       fs/partitions: Validate map_count in Mac partition tables
>       ldm: corrupted partition table can cause kernel oops
> 
> Tyler Hicks (1):
>       eCryptfs: Copy up lower inode attrs in getattr
> 
> Vasiliy Kulikov (3):
>       platform: x86: acer-wmi: world-writable sysfs threeg file
>       platform: x86: asus_acpi: world-writable procfs files
>       platform: x86: tc1100-wmi: world-writable sysfs wireless and jogdial files
> 
> dann frazier (1):
>       ocfs2_connection_find() returns pointer to bad structure
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

