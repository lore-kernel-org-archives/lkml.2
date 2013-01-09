Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab3AIUfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:35:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:40788 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab3AIUfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:35:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/47] 3.0.58-stable review
Date: Wed,  9 Jan 2013 12:34:55 -0800
Message-Id: <20130109201729.435233560@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, there are still a lot of patches submitted for inclusion in the
stable releases that I have not gotten to yet.  I wanted to get this
release out now, instead of delaying for a week or so while I dig
through all of the pending patches.

This is the start of the stable review cycle for the 3.0.58 release.
There are 47 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jan 11 20:16:47 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.58-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.58-rc1

Alexander Stein <alexander.stein@systec-electronic.com>
    can: Do not call dev_put if restart timer is running upon close

Michal Hocko <mhocko@suse.cz>
    mm: limit mmu_gather batching to fix soft lockups on !CONFIG_PREEMPT

Tony Prisk <linux@prisktech.co.nz>
    drivers/rtc/rtc-vt8500.c: fix handling of data passed in struct rtc_time

Tony Prisk <linux@prisktech.co.nz>
    drivers/rtc/rtc-vt8500.c: correct handling of CR_24H bitfield

Corey Minyard <cminyard@mvista.com>
    CRIS: fix I/O macros

Gustavo Padovan <gustavo.padovan@collabora.co.uk>
    Bluetooth: cancel power_on work when unregistering the device

Marcos Chaparro <marcos@mrkindustries.com.ar>
    Bluetooth: ath3k: Add support for VAIO VPCEH [0489:e027]

Andy Lutomirski <luto@amacapital.net>
    PCI: Reduce Ricoh 0xe822 SD card reader base clock frequency to 50MHz

David Woodhouse <dwmw2@infradead.org>
    solos-pci: fix double-free of TX skb in DMA mode

Al Viro <viro@ZenIV.linux.org.uk>
    ARM: missing ->mmap_sem around find_vma() in swp_emulate.c

Will Deacon <will.deacon@arm.com>
    ARM: mm: use pteval_t to represent page protection values

Eric Dumazet <edumazet@google.com>
    tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation

Eric Dumazet <edumazet@google.com>
    tcp: tcp_replace_ts_recent() should not be called from tcp_validate_incoming()

Eric Dumazet <edumazet@google.com>
    tcp: refine SYN handling in tcp_validate_incoming

Eric Dumazet <edumazet@google.com>
    tcp: implement RFC 5961 4.2

Eric Dumazet <edumazet@google.com>
    tcp: implement RFC 5961 3.2

Stefan Hasko <hasko.stevo@gmail.com>
    net: sched: integer overflow fix

Dave Kleikamp <dave.kleikamp@oracle.com>
    sparc: huge_ptep_set_* functions need to call set_huge_pte_at()

Steven Rostedt <srostedt@redhat.com>
    ftrace: Do not function trace inlined functions

Andre Przywara <andre.przywara@amd.com>
    x86, amd: Disable way access filter on Piledriver CPUs

Tejun Heo <tj@kernel.org>
    cgroup: remove incorrect dget/dput() pair in cgroup_create_dir()

Russell Webb <russell.webb@linux.intel.com>
    xhci: Add Lynx Point LP to list of Intel switchable hosts

Thomas Gleixner <tglx@linutronix.de>
    genirq: Always force thread affinity

Peter Popovec <popovec@oko.fei.tuke.sk>
    Input: walkera0701 - fix crash on startup

Xi Wang <xi.wang@gmail.com>
    nfs: fix null checking in nfs_get_option_str()

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix oops on unusual readlike compound

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFS: Fix calls to drop_nlink()

NeilBrown <neilb@suse.de>
    NFS: avoid NULL dereference in nfs_destroy_server

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / scan: Do not use dummy HID for system bus ACPI nodes

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: gadget: phonet: free requests in pn_bind()'s error path

Christian Lamparter <chunkeey@googlemail.com>
    p54usb: add USBIDs for two more p54usb devices

Tomasz Guszkowski <tsg@o2.pl>
    p54usb: add USB ID for T-Com Sinus 154 data II

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix missing autopm for MIDI input

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Avoid autopm calls after disconnection

Hugh Dickins <hughd@google.com>
    tmpfs mempolicy: fix /proc/mounts corrupting memory

Christoffer Dall <cdall@cs.columbia.edu>
    mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED

Will Deacon <will.deacon@arm.com>
    virtio: force vring descriptors to be allocated from lowmem

Ondrej Zary <linux@rainbow-software.org>
    x86, 8042: Enable A20 using KBC to fix S3 resume on some MSI laptops

Kees Cook <keescook@chromium.org>
    exec: do not leave bprm->interp on stack

Alan Cox <alan@lxorguk.ukuu.org.uk>
    pnpacpi: fix incorrect TEST_ALPHA() test

Jay Purohit <jspurohit@velocitylimitless.com>
    usb/ipheth: Add iPhone 5 support

Alexander Shiyan <shc_work@mail.ru>
    irda: sir_dev: Fix copy/paste typo

Alan Cox <alan@linux.intel.com>
    ne2000: add the right platform device

Tommi Rantala <tt.rantala@gmail.com>
    sctp: fix -ENOMEM result with invalid user space pointer in sendto() syscall

Tommi Rantala <tt.rantala@gmail.com>
    sctp: fix memory leak in sctp_datamsg_from_user() when copy from user space fails

nikolay@redhat.com <nikolay@redhat.com>
    bonding: fix race condition in bonding_store_slaves_active

Sarveshwar Bandi <sarveshwar.bandi@emulex.com>
    bonding: Bonding driver does not consider the gso_max_size/gso_max_segs setting of slave devices.


-------------

Diffstat:

 Documentation/networking/ip-sysctl.txt |  5 ++
 Makefile                               |  4 +-
 arch/arm/kernel/swp_emulate.c          |  2 +
 arch/arm/mm/mmu.c                      |  2 +-
 arch/cris/include/asm/io.h             | 39 +++++++++++---
 arch/sparc/include/asm/hugetlb.h       | 10 +++-
 arch/x86/kernel/cpu/amd.c              | 14 +++++
 drivers/acpi/scan.c                    |  2 +-
 drivers/atm/solos-pci.c                |  5 +-
 drivers/bluetooth/ath3k.c              |  1 +
 drivers/bluetooth/btusb.c              |  1 +
 drivers/input/joystick/walkera0701.c   |  7 +--
 drivers/input/serio/i8042-x86ia64io.h  |  9 ++++
 drivers/net/bonding/bond_main.c        |  7 +++
 drivers/net/bonding/bond_sysfs.c       |  2 +
 drivers/net/can/dev.c                  |  3 +-
 drivers/net/irda/sir_dev.c             |  2 +-
 drivers/net/ne.c                       |  1 +
 drivers/net/usb/ipheth.c               |  5 ++
 drivers/net/wireless/p54/p54usb.c      |  4 ++
 drivers/pci/quirks.c                   |  7 ++-
 drivers/pnp/pnpacpi/core.c             |  2 +-
 drivers/rtc/rtc-vt8500.c               | 11 ++--
 drivers/usb/gadget/f_phonet.c          |  8 ++-
 drivers/usb/host/ehci-pci.c            |  3 +-
 drivers/usb/host/pci-quirks.c          |  4 +-
 drivers/virtio/virtio_ring.c           |  7 +++
 fs/binfmt_misc.c                       |  5 +-
 fs/binfmt_script.c                     |  4 +-
 fs/exec.c                              | 15 ++++++
 fs/nfs/client.c                        |  3 +-
 fs/nfs/dir.c                           | 11 ++--
 fs/nfs/super.c                         |  2 +-
 fs/nfsd/nfs4xdr.c                      | 11 +++-
 include/asm-generic/tlb.h              |  9 ++++
 include/linux/binfmts.h                |  1 +
 include/linux/compiler-gcc.h           |  5 ++
 include/linux/page-flags.h             |  8 ++-
 include/linux/pci_ids.h                |  1 +
 include/linux/snmp.h                   |  3 +-
 include/net/tcp.h                      |  1 +
 kernel/cgroup.c                        |  2 -
 kernel/irq/manage.c                    | 23 ++++++++-
 mm/memory.c                            |  5 ++
 mm/mempolicy.c                         | 64 ++++++++++-------------
 net/bluetooth/hci_core.c               |  2 +
 net/ipv4/proc.c                        |  3 +-
 net/ipv4/sysctl_net_ipv4.c             |  7 +++
 net/ipv4/tcp_input.c                   | 93 +++++++++++++++++++++++++---------
 net/sched/sch_htb.c                    |  2 +-
 net/sctp/chunk.c                       | 20 +++++---
 net/sctp/socket.c                      |  4 +-
 sound/usb/midi.c                       | 91 +++++++++++++++++++++------------
 53 files changed, 407 insertions(+), 155 deletions(-)


