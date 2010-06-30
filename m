Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab0F3LWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 07:22:44 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:35528 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab0F3LWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 07:22:40 -0400
Message-ID: <4C2B28F3.7000006@linux.vnet.ibm.com>
Date: Wed, 30 Jun 2010 16:52:27 +0530
From: divya <dipraksh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: LKML <linux-kernel@vger.kernel.org>, Ron Minnich <rminnich@sandia.gov>,
       Latchesar Ionkov <lucho@ionkov.net>
Subject: Oops while running fs_racer test on a POWER6 box against latest git
Content-Type: multipart/mixed;
 boundary="------------050707020305090106030504"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050707020305090106030504
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

While running fs_racer test from LTP on a POWER6 box against latest git(2.6.35-rc3-git4 - commitid 984bc9601f64fd)
came across the following warning followed by multiple oops.

------------[ cut here ]------------

Badness at kernel/mutex-debug.c:64
NIP: c0000000000be9e8 LR: c0000000000be9cc CTR: 0000000000000000
REGS: c00000010be8f6f0 TRAP: 0700   Not tainted  (2.6.35-rc3-git4-autotest)
MSR: 8000000000029032<EE,ME,CE,IR,DR>    CR: 24224422  XER: 00000012
TASK = c00000010727cf00[8211] 'fs_racer_file_c' THREAD: c00000010be8bb50 CPU: 2
GPR00: 0000000000000000 c00000010be8f970 c000000000d3d798 0000000000000001
GPR04: c00000010be8fa70 c00000010be8c000 c00000010727d9f8 0000000000000000
GPR08: c0000000043042f0 c0000000016534e8 000000000000017a c000000000c29a1c
GPR12: 0000000028228424 c00000000f600500 c00000010be8fc40 0000000020000000
GPR16: fffffffffffff000 c000000109c73000 c00000010be8fc30 0000000000010442
GPR20: 0000000000000000 0000000000000000 00000000000001b6 c00000010dd12250
GPR24: c00000000017c08c c00000010727cf00 c00000010dd12278 c00000010dd12210
GPR28: 0000000000000001 c00000010be8c000 c000000000ca2008 c00000010be8fa70
NIP [c0000000000be9e8] .mutex_remove_waiter+0xa4/0x130
LR [c0000000000be9cc] .mutex_remove_waiter+0x88/0x130
Call Trace:
[c00000010be8f970] [c00000010be8fa00] 0xc00000010be8fa00 (unreliable)
[c00000010be8fa00] [c00000000064a9f0] .mutex_lock_nested+0x384/0x430
Instruction dump:
e81f0010 e93d0000 7fa04800 41fe0028 482e96e5 60000000 2fa30000 419e0018
e93e8008 80090000 2f800000 409e0008<0fe00000>   e93e8000 80090000 2f800000
Unable to handle kernel paging request for unknown fault
Faulting instruction address: 0xc00000000008d0f4
Oops: Kernel access of bad area, sig: 7 [#1]
SMP NR_CPUS=1024 NUMA
Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
pSeries
last sysfs file: /sys/devices/system/cpu/cpu19/cache/index1/shared_cpu_map
Modules linked in: ipv6 fuse loop dm_mod sr_mod cdrom ibmveth sg
sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt scsi_mod
NIP: c00000000008d0f4 LR: c00000000008d0d0 CTR: 0000000000000000
REGS: c00000010978f900 TRAP: 0600   Tainted: G        W    (2.6.35-rc3-git4-autotest)
MSR: 8000000000009032
Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
EE,ME,IR,DR>    CR: 24022442  XER: 00000012
DAR: c000000000648f54, DSISR: 0000000040010000
TASK = c0000001096e4900[7353] 'fs_racer_file_s' THREAD: c00000010978c000 CPU: 10
GPR00: 0000000000004000 c00000010978fb80 c000000000d3d798 0000000000000001
GPR04: c00000000083539e c000000001610228 0000000000000000 c0000000054c6880
GPR08: 00000000000006a5 c000000000648f54 0000000000000007 00000000049b0000
GPR12: 0000000000000000 c00000000f601900 00000000ffffffff ffffffffffffffff
GPR16: 000000004b7dc520 0000000000000000 0000000000000000 c00000010978fea0
GPR20: 00000fffcca7e7a0 00000fffcca7e7a0 00000fffabf7dfd0 00000fffabf7dfd0
GPR24: 0000000000000000 0000000001200011 c000000000e1c0a8 c000000000648ed4
GPR28: 0000000000000000 c0000001096e4900 c000000000ca0458 c00000010725d400
NIP [c00000000008d0f4] .copy_process+0x310/0xf40
LR [c00000000008d0d0] .copy_process+0x2ec/0xf40
Call Trace:
[c00000010978fb80] [c00000000008d0d0] .copy_process+0x2ec/0xf40 (unreliable)
[c00000010978fc80] [c00000000008deb4] .do_fork+0x190/0x3cc
[c00000010978fdc0] [c000000000011ef4] .sys_clone+0x58/0x70
[c00000010978fe30] [c0000000000087f0] .ppc_clone+0x8/0xc
Instruction dump:
419e0010 7fe3fb78 480774cd 60000000 801f0014 e93f0008 7800b842 39290080
78004800 60000042 901f0014 38004000<7d6048a8>   7d6b0078 7d6049ad 40c2fff4

Kernel version 2.6.34-rc3-git3 works fine.

Thanks
Divya



--------------050707020305090106030504
Content-Type: text/x-log;
 name="2.6.34-rc3-git4.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="2.6.34-rc3-git4.log"

Using 007dfade bytes for initrd buffer
Please wait, loading kernel...
Allocated 01800000 bytes for kernel @ 01e00000
   Elf64 kernel loaded...
Loading ramdisk...
ramdisk loaded 007dfade @ 03600000
OF stdout device is: /vdevice/vty@30000000
Preparing to boot Linux version 2.6.35-rc3-git4-autotest (root@p55alp2) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Wed Jun 30 08:47:11 IST 2010
Max number of cores passed to firmware: 0x0000000000000200
Calling ibm,client-architecture-support... not implemented
command line: root=/dev/sda5 IDENT=1277868480
memory layout at init:
  memory_limit : 0000000000000000 (16 MB aligned)
  alloc_bottom : 0000000003de0000
  alloc_top    : 0000000010000000
  alloc_top_hi : 00000001f0000000
  rmo_top      : 0000000010000000
  ram_top      : 00000001f0000000
instantiating rtas at 0x000000000f6a0000... done
boot cpu hw idx 0000000000000000
starting cpu hw idx 0000000000000002... done
starting cpu hw idx 0000000000000004... done
starting cpu hw idx 0000000000000006... done
starting cpu hw idx 0000000000000008... done
starting cpu hw idx 000000000000000a... done
starting cpu hw idx 000000000000000c... done
starting cpu hw idx 000000000000000e... done
starting cpu hw idx 0000000000000010... done
starting cpu hw idx 0000000000000012... done
copying OF device tree...
Building dt strings...
Building dt structure...
Device tree strings 0x0000000003df0000 ->  0x0000000003df1135
Device tree struct  0x0000000003e00000 ->  0x0000000003e10000
Calling quiesce...
returning from prom_init
Phyp-dump not supported on this hardware
Using pSeries machine description
Using 1TB segments
Found initrd at 0xc000000003600000:0xc000000003ddfade
bootconsole [udbg0] enabled
Partition configured for 20 cpus.
CPU maps initialized for 2 threads per core
Starting Linux PPC64 #1 SMP Wed Jun 30 08:47:11 IST 2010
-----------------------------------------------------
ppc64_pft_size                = 0x1b
physicalMemorySize            = 0x1f0000000
htab_hash_mask                = 0xfffff
-----------------------------------------------------
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.35-rc3-git4-autotest (root@p55alp2) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Wed Jun 30 08:47:11 IST 2010
[boot]0012 Setup Arch
EEH: No capable adapters found
PPC64 nvram contains 7168 bytes
Zone PFN ranges:
  DMA      0x00000000 ->  0x0001f000
  Normal   empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 ->  0x00011000
    1: 0x00011000 ->  0x0001f000
[boot]0015 Setup Done
PERCPU: Embedded 29 pages/cpu @c000000003f00000 s1861120 r0 d39424 u2097152
pcpu-alloc: s1861120 r0 d39424 u2097152 alloc=2*1048576
pcpu-alloc: [0] 00 [0] 01 [0] 02 [0] 03 [0] 04 [0] 05 [0] 06 [0] 07
pcpu-alloc: [0] 08 [0] 09 [0] 10 [0] 11 [0] 12 [0] 13 [0] 14 [0] 15
pcpu-alloc: [0] 16 [0] 17 [0] 18 [0] 19
Built 2 zonelists in Node order, mobility grouping on.  Total pages: 126867
Policy zone: DMA
Kernel command line: root=/dev/sda5 IDENT=1277868480
PID hash table entries: 4096 (order: -1, 32768 bytes)
freeing bootmem node 0
freeing bootmem node 1
Memory: 8014272k/8126464k available (11392k kernel code, 112192k reserved, 2752k data, 8893k bss, 2304k init)
SLUB: Genslabs=18, HWalign=128, Order=0-3, MinObjects=0, CPUs=20, Nodes=256
Hierarchical RCU implementation.
        RCU torture testing starts during boot.
        Verbose stalled-CPUs detection is disabled.
NR_IRQS:512 nr_irqs:512
[boot]0020 XICS Init
[boot]0021 XICS Done
clocksource: timebase mult[155e24d] shift[22] registered
Console: colour dummy device 80x25
console [hvc0] enabled, bootconsole disabled
console [hvc0] enabled, bootconsole disabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 6335 kB
 per task-struct memory footprint: 2688 bytes
allocated 5079040 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 1048576 (order: 7, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 6, 4194304 bytes)
Mount-cache hash table entries: 4096
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys blkio
Processor 1 found.
Processor 2 found.
Processor 3 found.
Processor 4 found.
Processor 5 found.
Processor 6 found.
Processor 7 found.
Processor 8 found.
Processor 9 found.
Processor 10 found.
Processor 11 found.
Processor 12 found.
Processor 13 found.
Processor 14 found.
Processor 15 found.
Processor 16 found.
Processor 17 found.
Processor 18 found.
Processor 19 found.
Brought up 20 CPUs
NET: Registered protocol family 16
IBM eBus Device Driver
POWER5+/++ performance monitor hardware support registered
PCI: Probing PCI hardware
bio: create slab<bio-0>  at 0
vgaarb: loaded
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Switching to clocksource timebase
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 3, 524288 bytes)
TCP established hash table entries: 262144 (order: 6, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 6, 4718592 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 4096 (order: 3, 655360 bytes)
UDP-Lite hash table entries: 4096 (order: 3, 655360 bytes)
NET: Registered protocol family 1
Unpacking initramfs...
Freeing initrd memory: 8062k freed
IOMMU table initialized, virtual merging enabled
audit: initializing netlink socket (disabled)
type=2000 audit(1277868538.520:1): initialized
Kprobe smoke test started
Kprobe smoke test passed successfully
rcu-torture:--- Start of test: nreaders=40 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3
HugeTLB registered 16 MB page size, pre-allocated 0 pages
HugeTLB registered 16 GB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
Btrfs loaded
msgmni has been set to 15668
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
Generic RTC Driver v1.07
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
pmac_zilog: 0.6 (Benjamin Herrenschmidt<benh@kernel.crashing.org>)
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
IBM eHEA ethernet device driver (Release EHEA_0105)
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
mice: PS/2 mouse device common for all mice
EDAC MC: Ver: 2.1.0 Jun 30 2010
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP cubic registered
NET: Registered protocol family 15
registered taskstats version 1
Freeing unused kernel memory: 2304k freed
doing fast boot
SCSI subsystem initialized
ibmvscsi 30000003: SRP_VERSION: 16.a
scsi0 : IBM POWER Virtual SCSI Adapter 1.5.8
ibmvscsi 30000003: partner initialization complete
ibmvscsi 30000003: host srp version: 16.a, host partition p55avios (1), OS 3, max io 262144
ibmvscsi 30000003: Client reserve enabled
ibmvscsi 30000003: sent SRP login
ibmvscsi 30000003: SRP_LOGIN succeeded
scsi 0:0:1:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
scsi 0:0:2:0: CD-ROM            AIX      VOPTA                 PQ: 0 ANSI: 4
Creating device nodes with udev
udevd version 128 started
sd 0:0:1:0: [sda] 146800640 512-byte logical blocks: (75.1 GB/70.0 GiB)
sd 0:0:1:0: [sda] Write Protect is off
sd 0:0:1:0: [sda] Cache data unavailable
sd 0:0:1:0: [sda] Assuming drive cache: write through
sd 0:0:1:0: [sda] Cache data unavailable
sd 0:0:1:0: [sda] Assuming drive cache: write through
 sda: sda1 sda2 sda3<  sda5 sda6>
sd 0:0:1:0: [sda] Cache data unavailable
sd 0:0:1:0: [sda] Assuming drive cache: write through
sd 0:0:1:0: [sda] Attached SCSI disk
Boot logging started on /dev/hvc0(/dev/console) at Wed Jun 30 03:28:59 2010
resume device  not found (ignoring)
Waiting for device /dev/sda5 to appear:  ok
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
fsck 1.41.1 (01-Sep-2008)
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/sda5
/dev/sda5: clean, 339391/2097152 files, 4231791/8379888 blocks
fsck succeeded. Mounting root device read-write.
Mounting root /dev/sda5
mount -o rw,acl,user_xattr -t ext3 /dev/sda5 /root
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda5): using internal journal
EXT3-fs (sda5): mounted filesystem with writeback data mode
mount: can't find /root/proc in /etc/fstab or /etc/mtab
INIT: version 2.86 booting
System Boot Control: Running /etc/init.d/boot
Mounting procfs at /proc7[?25l[80C[10D[1;32mdone[m8[?25h
Mounting sysfs at /sys7[?25l[80C[10D[1;32mdone[m8[?25h
Mounting debugfs at /sys/kernel/debug7[?25l[80C[10D[1;32mdone[m8[?25h
Remounting tmpfs at /dev7[?25l[80C[10D[1;32mdone[m8[?25h
Initializing /dev7[?25l[80C[10D[1;32mdone[m8[?25h
Mounting devpts at /dev/pts7[?25l[80C[10D[1;32mdone[m8[?25h
Starting udevd: udevd version 128 started
7[?25l[80C[10D[1;32mdone[m8[?25h
Loading drivers, configuring devices: sd 0:0:1:0: Attached scsi generic sg0 type 0
scsi 0:0:2:0: Attached scsi generic sg1 type 5
sr0: scsi-1 drive
Uniform CD-ROM driver Revision: 3.20
7[?25l[80C[10D[1;32mdone[m8[?25h
Loading required kernel modules
7[?25l[1A[80C[10D[1;32mdone[m8[?25hActivating swap-devices in /etc/fstab...
Adding 8385856k swap on /dev/sda2.  Priority:-1 extents:1 across:8385856k
7[?25l[1A[80C[10D[1;32mdone[m8[?25hSetting up the hardware clock7[?25l[80C[10D[1;32mdone[m8[?25h
Activating device mapper...
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
7[?25l[80C[10D[1;32mdone[m8[?25h
Checking file systems...
fsck 1.41.1 (01-Sep-2008)
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /data] fsck.ext3 -a /dev/sda6
/dev/sda6: clean, 12/1966080 files, 906609/7863808 blocks
7[?25l[1A[80C[10D[1;32mdone[m8[?25h7[?25l[80C[10D[1;32mdone[m8[?25h
Mounting local file systems...
/proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
debugfs on /sys/kernel/debug type debugfs (rw)
udev on /dev type tmpfs (rw)
loop: module loaded
devpts on /dev/pts type devpts (rw,mode=0620,gid=5)
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda6): using internal journal
EXT3-fs (sda6): mounted filesystem with writeback data mode
/dev/sda6 on /data type ext3 (rw,acl,user_xattr)
7[?25l[1A[80C[10D[1;32mdone[m8[?25hfuse init (API version 7.14)
Loading fuse module 7[?25l[80C[10D[1;32mdone[m8[?25h
Mounting fuse control filesystem7[?25l[80C[10D[1;32mdone[m8[?25h
Setting current sysctl status from /etc/sysctl.conf7[?25l[80C[10D[1;32mdone[m8[?25h
Activating remaining swap-devices in /etc/fstab...
7[?25l[1A[80C[10D[1;32mdone[m8[?25hEnabling syn flood protection[80C[10D[1;32mdone[m
Disabling IP forwarding7[?25l[80C[10D[1;32mdone[m8[?25h
7[?25l[80C[10D[1;32mdone[m8[?25h
Creating /var/log/boot.msg
7[?25l[1A[80C[10D[1;32mdone[m8[?25hshowconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
Turning quota on
Checking quotas. This may take some time.
7[?25l[80C[10D[1;32mdone[m8[?25h
ATTENTION: You have modified /etc/resolv.conf.  Leaving it untouched...
You can find my version in /etc/resolv.conf.netconfig ...
Mounting securityfs on /sys/kernel/security [80C[10D[1;32mdone[m
Loading AppArmor module [80C[10D[1;31mfailed[m
Setting up hostname 'p55alp2'7[?25l[80C[10D[1;32mdone[m8[?25h
Setting up loopback interface     lo
    lo        IP address: 127.0.0.1/8
              IP address: 127.0.0.2/8
7[?25l[80C[10D[1;32mdone[m8[?25h
Loading kdump
Then try loading kdump kernel
Memory for crashkernel is not reserved
Please reserve memory by passing "crashkernel=X@Y" parameter to the kernel
7[?25l[80C[10D[1;31mfailed[m8[?25h
System Boot Control: The system has been [80C[10D[1mset up[m
Failed features: [80C[31D[1;31mboot.apparmor boot.kdump[m
System Boot Control: Running /etc/init.d/boot.local
7[?25l[1A[80C[10D[1;32mdone[m8[?25hINIT: Entering runlevel: 3
Boot logging started on /dev/hvc0(/dev/console) at Wed Jun 30 08:59:10 2010
Master Resource Control: previous runlevel: N, switching to runlevel: [80C[10D[1m3[m
Initializing random number generator7[?25l[80C[10D[1;32mdone[m8[?25h
Starting D-Bus daemon7[?25l[80C[10D[1;32mdone[m8[?25h
Starting syslog services7[?25l[80C[10D[1;32mdone[m8[?25h
Loading CPUFreq modules (CPUFreq not supported)
Starting HAL daemon7[?25l[80C[10D[1;32mdone[m8[?25h
Setting up (localfs) network interfaces:
    lo
    lo        IP address: 127.0.0.1/8
              IP address: 127.0.0.2/8
7[?25l[1A[80C[10D[1;32mdone[m8[?25h    eth0      name: Virtual Ethernet card 0
    eth0      IP address: 9.124.111.212/24
7[?25l[1A[80C[10D[1;32mdone[m8[?25hSetting up service (localfs) network  .  .  .  .  .  .  .  .  .  .7[?25l[80C[10D[1;32mdone[m8[?25h
Mount CIFS File Systems [80C[10D[1munused[m
Starting rpcbind 7[?25l[80C[10D[1;32mdone[m8[?25h
Starting auditd 7[?25l[80C[10D[1;32mdone[m8[?25h
Not starting NFS client services - no NFS found in /etc/fstab:[80C[10D[1munused[m
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Loading console font lat9w-16.psfu  -m trivial G0:loadable
7[?25l[1A[80C[10D[1;32mdone[m8[?25hLoading keymap assuming iso-8859-15 euro
Loading /usr/share/kbd/keymaps/i386/qwerty/us.map.gz
7[?25l[1A[80C[10D[1;32mdone[m8[?25hLoading compose table latin1.add7[?25l[80C[10D[1;32mdone[m8[?25h
Start Unicode mode
7[?25l[1A[80C[10D[1;32mdone[m8[?25hStarting Name Service Cache Daemon7[?25l[80C[10D[1;32mdone[m8[?25h
Starting cupsd7[?25l[80C[10D[1;32mdone[m8[?25h
Starting rtas_errd (platform error handling) daemon: 7[?25l[80C[10D[1;32mdone[m8[?25h
Starting irqbalance 7[?25l[80C[10D[1;32mdone[m8[?25h
Starting ipr initialization daemon [80C[10D[1;32mdone[m
Checking ipr microcode levels
Completed ipr microcode updates [80C[10D[1;32mdone[m
Starting SSH daemon7[?25l[80C[10D[1;32mdone[m8[?25h
Starting smartd [80C[10D[1munused[m
Starting ipr dump daemon [80C[10D[1;32mdone[m
Setting up (remotefs) network interfaces:
Setting up service (remotefs) network  .  .  .  .  .  .  .  .  .  .7[?25l[80C[10D[1;32mdone[m8[?25h
Starting INET services. (xinetd)7[?25l[80C[10D[1;32mdone[m8[?25h
Starting mail service (Postfix)7[?25l[80C[10D[1;32mdone[m8[?25h
Starting CRON daemon7[?25l[80C[10D[1;32mdone[m8[?25h
Master Resource Control: runlevel 3 has been [80C[10D[1mreached[m
Skipped services in runlevel 3: [80C[30D[1;33msmbfs nfs smartd splash[m
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel


Welcome to SUSE Linux Enterprise Server 11 (ppc64) - Kernel 2.6.35-rc3-git4-autotest (console).


p55alp2 login:-- 0:conmux-control -- time-stamp -- Jun/29/10 20:31:38 --
-- 0:conmux-control -- time-stamp -- Jun/29/10 21:10:16 --
 ------------[ cut here ]------------
Badness at kernel/mutex-debug.c:64
NIP: c0000000000be9e8 LR: c0000000000be9cc CTR: 0000000000000000
REGS: c00000010be8f6f0 TRAP: 0700   Not tainted  (2.6.35-rc3-git4-autotest)
MSR: 8000000000029032<EE,ME,CE,IR,DR>   CR: 24224422  XER: 00000012
TASK = c00000010727cf00[8211] 'fs_racer_file_c' THREAD: c00000010be8bb50 CPU: 2
GPR00: 0000000000000000 c00000010be8f970 c000000000d3d798 0000000000000001
GPR04: c00000010be8fa70 c00000010be8c000 c00000010727d9f8 0000000000000000
GPR08: c0000000043042f0 c0000000016534e8 000000000000017a c000000000c29a1c
GPR12: 0000000028228424 c00000000f600500 c00000010be8fc40 0000000020000000
GPR16: fffffffffffff000 c000000109c73000 c00000010be8fc30 0000000000010442
GPR20: 0000000000000000 0000000000000000 00000000000001b6 c00000010dd12250
GPR24: c00000000017c08c c00000010727cf00 c00000010dd12278 c00000010dd12210
GPR28: 0000000000000001 c00000010be8c000 c000000000ca2008 c00000010be8fa70
NIP [c0000000000be9e8] .mutex_remove_waiter+0xa4/0x130
LR [c0000000000be9cc] .mutex_remove_waiter+0x88/0x130
Call Trace:
[c00000010be8f970] [c00000010be8fa00] 0xc00000010be8fa00 (unreliable)
[c00000010be8fa00] [c00000000064a9f0] .mutex_lock_nested+0x384/0x430
Instruction dump:
e81f0010 e93d0000 7fa04800 41fe0028 482e96e5 60000000 2fa30000 419e0018
e93e8008 80090000 2f800000 409e0008<0fe00000>  e93e8000 80090000 2f800000
Unable to handle kernel paging request for unknown fault
Faulting instruction address: 0xc00000000008d0f4
Oops: Kernel access of bad area, sig: 7 [#1]
SMP NR_CPUS=1024 NUMA
Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
pSeries
last sysfs file: /sys/devices/system/cpu/cpu19/cache/index1/shared_cpu_map
Modules linked in: ipv6 fuse loop dm_mod sr_mod cdrom ibmveth sg sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt scsi_mod
NIP: c00000000008d0f4 LR: c00000000008d0d0 CTR: 0000000000000000
REGS: c00000010978f900 TRAP: 0600   Tainted: G        W    (2.6.35-rc3-git4-autotest)
MSR: 8000000000009032
Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
<
Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
EE,ME,IR,DR>   CR: 24022442  XER: 00000012
DAR: c000000000648f54, DSISR: 0000000040010000
TASK = c0000001096e4900[7353] 'fs_racer_file_s' THREAD: c00000010978c000 CPU: 10
GPR00: 0000000000004000 c00000010978fb80 c000000000d3d798 0000000000000001
GPR04: c00000000083539e c000000001610228 0000000000000000 c0000000054c6880
GPR08: 00000000000006a5 c000000000648f54 0000000000000007 00000000049b0000
GPR12: 0000000000000000 c00000000f601900 00000000ffffffff ffffffffffffffff
GPR16: 000000004b7dc520 0000000000000000 0000000000000000 c00000010978fea0
GPR20: 00000fffcca7e7a0 00000fffcca7e7a0 00000fffabf7dfd0 00000fffabf7dfd0
GPR24: 0000000000000000 0000000001200011 c000000000e1c0a8 c000000000648ed4
GPR28: 0000000000000000 c0000001096e4900 c000000000ca0458 c00000010725d400
NIP [c00000000008d0f4] .copy_process+0x310/0xf40
LR [c00000000008d0d0] .copy_process+0x2ec/0xf40
Call Trace:
[c00000010978fb80] [c00000000008d0d0] .copy_process+0x2ec/0xf40 (unreliable)
[c00000010978fc80] [c00000000008deb4] .do_fork+0x190/0x3cc
[c00000010978fdc0] [c000000000011ef4] .sys_clone+0x58/0x70
[c00000010978fe30] [c0000000000087f0] .ppc_clone+0x8/0xc
Instruction dump:
419e0010 7fe3fb78 480774cd 60000000 801f0014 e93f0008 7800b842 39290080
78004800 60000042 901f0014 38004000<7d6048a8>  7d6b0078 7d6049ad 40c2fff4
Oops: Unrecoverable FP Unavailable Exception, sig: 6 [#2]
SMP NR_CPUS=1024 NUMA pSeries
last sysfs file: /sys/devices/system/cpu/cpu19/cache/index1/shared_cpu_map
Modules linked in: ipv6 fuse loop dm_mod sr_mod cdrom ibmveth sg sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt scsi_mod
NIP: c000000000648ed4 LR: c000000000648ed4 CTR: 0000000000000000
REGS: c00000010979b870 TRAP: 0800   Tainted: G      D W    (2.6.35-rc3-git4-autotest)
MSR: 8000000000001032<ME,IR,DR>   CR: 24042422  XER: 00000012
TASK = c0000001096c4e00[7356] 'fs_racer_file_c' THREAD: c000000109798000 CPU: 4
GPR00: c000000000648ed4 c00000010979baf0 c000000000d3d798 c00000010aeb0c00
GPR04: c0000001096c5320 c000000000087028 0000000024042424 c0000000000129c4
GPR08: c00000010979b890 c000000000000000 c000000000086fcc c0000000048c5780
GPR12: 0000000028000428 c00000000f600a00 0000000000000001 c00000010979bb60
GPR16: 0000000000000004 c000000000de2550 0000000000000000 c000000109798080
GPR20: c0000000000939b0 0000000000000000 c000000109798000 c000000000b15780
GPR24: c0000001096c51c0 0000000000000002 0000000100034ba6 c0000001096c4e00
GPR28: c00000010b904e00 c0000000044c5780 c000000000c9fb00 c000000109e70500
NIP [c000000000648ed4] .schedule+0x620/0x770
LR [c000000000648ed4] .schedule+0x620/0x770
Call Trace:
[c00000010979baf0] [c000000000648ed4] .schedule+0x620/0x770 (unreliable)
[c00000010979bc00] [c0000000000939b0] .do_wait+0x19c/0x220
[c00000010979bcc0] [c000000000093b04] .SyS_wait4+0xd0/0x108
[c00000010979bdc0] [c00000000009138c] .SyS_waitpid+0x1c/0x30
[c00000010979be30] [c0000000000085b4] syscall_exit+0x0/0x40
Instruction dump:
2fa00000 409e000c f81b02a8 fbfd0878 387d0018 e8be8940 38800001 4ba79469
60000000 7f84e378 7f63db78 4b9c99b1<c0000001>  0725d400 c0000000 00c29830
Oops: Unrecoverable FP Unavailable Exception, sig: 6 [#3]
SMP NR_CPUS=1024 NUMA pSeries
last sysfs file: /sys/devices/system/cpu/cpu19/cache/index1/shared_cpu_map
Modules linked in: ipv6 fuse loop dm_mod sr_mod cdrom ibmveth sg sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt scsi_mod
NIP: c000000000648ed4 LR: c000000000648ed4 CTR: 0000000000000000
REGS: c0000001097cb870 TRAP: 0800   Tainted: G      D W    (2.6.35-rc3-git4-autotest)
MSR: 8000000000001032<ME,IR,DR>   CR: 24042422  XER: 00000010
TASK = c0000001096d5f00[7345] 'fs_racer_dir_cr' THREAD: c0000001097c8000 CPU: 5
GPR00: c000000000648ed4 c0000001097cbaf0 c000000000d3d798 c000000107175a00
GPR04: c0000001096d6420 c000000000087028 0000000024042424 c0000000000129c4
GPR08: c0000001097cb890 c000000000000000 c000000000086fcc c000000004ac5780
GPR12: c00000010c2ac000 c00000000f600c80 0000000000000001 c0000001097cbb60
GPR16: 0000000000000004 c000000000de2550 0000000000000000 c0000001097c8080
GPR20: c0000000000939b0 0000000000000000 c0000001097c8000 c000000000b15780
GPR24: c0000001096d62c0 0000000000000005 0000000100034ba6 c0000001096d5f00
GPR28: c00000010eb8ea00 c000000004ac5780 c000000000c9fb00 c0000001098faf00
NIP [c000000000648ed4] .schedule+0x620/0x770
LR [c000000000648ed4] .schedule+0x620/0x770
Call Trace:
[c0000001097cbaf0] [c000000000648ed4] .schedule+0x620/0x770 (unreliable)
[c0000001097cbc00] [c0000000000939b0] .do_wait+0x19c/0x220
[c0000001097cbcc0] [c000000000093b04] .SyS_wait4+0xd0/0x108
[c0000001097cbdc0] [c00000000009138c] .SyS_waitpid+0x1c/0x30
[c0000001097cbe30] [c0000000000085b4] syscall_exit+0x0/0x40
Instruction dump:
2fa00000 409e000c f81b02a8 fbfd0878 387d0018 e8be8940 38800001 4ba79469
60000000 7f84e378 7f63db78 4b9c99b1<c0000001>  0725d400 c0000000 00c29830
Oops: Unrecoverable FP Unavailable Exception, sig: 6 [#4]
SMP NR_CPUS=1024 NUMA pSeries
last sysfs file: /sys/devices/system/cpu/cpu19/cache/index1/shared_cpu_map
Modules linked in: ipv6 fuse loop dm_mod sr_mod cdrom ibmveth sg sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt scsi_mod
NIP: c000000000648ed4 LR: c000000000648ed4 CTR: c000000000078dac
REGS: c00000010e4d7ac0 TRAP: 0800   Tainted: G      D W    (2.6.35-rc3-git4-autotest)
MSR: 8000000000001032<ME,IR,DR>   CR: 24000022  XER: 00000001
TASK = c00000010eb98600[0] 'swapper' THREAD: c00000010e4d4000 CPU: 9
GPR00: c000000000648ed4 c00000010e4d7d40 c000000000d3d798 c000000109307500
GPR04: c00000010eb98b20 c000000000087028 0000000024000024 c0000000000129c4
GPR08: c00000010e4d7ae0 c000000000000000 c000000000086fcc c0000000052c5780
GPR12: 0000000044000028 c00000000f601680 0000000000000001 c00000010e4d7db0
GPR16: 0000000000000004 c000000000de2550 0000000000000000 c00000010e4d4080
GPR20: c0000000000140bc 0000000000000000 c00000010e4d4000 c000000000b15780
GPR24: c00000010eb989c8 0000000000000009 0000000000001680 c00000010eb98600
GPR28: c000000109307500 c0000000052c5780 c000000000c9fb00 c000000109376900
NIP [c000000000648ed4] .schedule+0x620/0x770
LR [c000000000648ed4] .schedule+0x620/0x770
Call Trace:
[c00000010e4d7d40] [c000000000648ed4] .schedule+0x620/0x770 (unreliable)
[c00000010e4d7e50] [c0000000000140bc] .cpu_idle+0x1a4/0x1ac
[c00000010e4d7ee0] [c000000000656530] .start_secondary+0x378/0x3b0
[c00000010e4d7f90] [c0000000000082d8] .start_secondary_prolog+0x10/0x14
Instruction dump:
2fa00000 409e000c f81b02a8 fbfd0878 387d0018 e8be8940 38800001 4ba79469
60000000 7f84e378 7f63db78 4b9c99b1<c0000001>  0725d400 c0000000 00c29830
Oops: Unrecoverable FP Unavailable Exception, sig: 6 [#5]
SMP NR_CPUS=1024 NUMA pSeries
last sysfs file: /sys/devices/system/cpu/cpu19/cache/index1/shared_cpu_map
Modules linked in: ipv6 fuse loop dm_mod sr_mod cdrom ibmveth sg sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt scsi_mod
NIP: c000000000648ed4 LR: c000000000648ed4 CTR: c000000000078dac
REGS: c000000000d3fa30 TRAP: 0800   Tainted: G      D W    (2.6.35-rc3-git4-autotest)
MSR: 8000000000001032<ME,IR,DR>   CR: 24000022  XER: 00000012
TASK = c000000000c67710[0] 'swapper' THREAD: c000000000d3c000 CPU: 0
GPR00: c000000000648ed4 c000000000d3fcb0 c000000000d3d798 c0000001096c7500
GPR04: c000000000c67c30 c000000000087028 0000000024000024 c0000000000129c4
GPR08: c000000000d3fa50 c000000000000000 c000000000086fcc c0000000040c5780
GPR12: 0000000042042428 c00000000f600000 0000000000000001 c000000000d3fd20
GPR16: 0000000000000004 c000000000de2550 0000000000000000 c000000000d3c080
GPR20: c0000000000140bc 0000000000000000 c000000000d3c000 c000000000b15780
GPR24: c000000000c67ad8 0000000000000000 0000000001e00000 c000000000c67710
GPR28: c000000107275a00 c0000000040c5780 c000000000c9fb00 c0000001098f9100
NIP [c000000000648ed4] .schedule+0x620/0x770
LR [c000000000648ed4] .schedule+0x620/0x770
Call Trace:
[c000000000d3fcb0] [c000000000648ed4] .schedule+0x620/0x770 (unreliable)
[c000000000d3fdc0] [c0000000000140bc] .cpu_idle+0x1a4/0x1ac
[c000000000d3fe50] [c000000000009d84] .rest_init+0xd8/0x114
[c000000000d3fee0] [c0000000008e0dec] .start_kernel+0x544/0x564
[c000000000d3ff90] [c000000000008434] .start_here_common+0x1c/0x68
Instruction dump:
2fa00000 409e000c f81b02a8 fbfd0878 387d0018 e8be8940 38800001 4ba79469
60000000 7f84e378 7f63db78 4b9c99b1<c0000001>  0725d400 c0000000 00c29830
Oops: Unrecoverable FP Unavailable Exception, sig: 6 [#6]
SMP NR_CPUS=1024 NUMA pSeries
last sysfs file: /sys/devices/system/cpu/cpu19/cache/index1/shared_cpu_map
Modules linked in: ipv6 fuse loop dm_mod sr_mod cdrom ibmveth sg sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt scsi_mod
NIP: c000000000648ed4 LR: c000000000648ed4 CTR: c0000000000813e0
REGS: c00000010ed639c0 TRAP: 0800   Tainted: G      D W    (2.6.35-rc3-git4-autotest)
MSR: 8000000000001032<ME,IR,DR>   CR: 24000022  XER: 00000012
TASK = c00000010ecd3800[42] 'migration/13' THREAD: c00000010ed60000 CPU: 13
GPR00: c000000000648ed4 c00000010ed63c40 c000000000d3d798 c00000010edcc300
GPR04: c00000010ecd3d20 c000000000087028 0000000024000028 c0000000000129c4
GPR08: c00000010ed639e0 c000000000000000 c000000000086fcc c000000005ac5780
GPR12: 0000000044224424 c00000000f602080 0000000000000001 c00000010ed63cb0
GPR16: 0000000000000004 c000000000de2550 0000000000000000 c00000010ed60080
GPR20: c0000000000e8a64 0000000000000000 c00000010ed60000 c000000000b15780
GPR24: c00000010ecd3bc0 000000000000000d c000000005ac4250 c00000010ecd3800
GPR28: c00000010a12e500 c000000005ac5780 c000000000c9fb00 c00000010a222800
NIP [c000000000648ed4] .schedule+0x620/0x770
LR [c000000000648ed4] .schedule+0x620/0x770
Call Trace:
[c00000010ed63c40] [c000000000648ed4] .schedule+0x620/0x770 (unreliable)
[c00000010ed63d50] [c0000000000e8a64] .cpu_stopper_thread+0x1e4/0x1ec
[c00000010ed63ea0] [c0000000000acc48] .kthread+0xa8/0xb4
[c00000010ed63f90] [c00000000002c698] .kernel_thread+0x54/0x70
Instruction dump:
2fa00000 409e000c f81b02a8 fbfd0878 387d0018 e8be8940 38800001 4ba79469
60000000 7f84e378 7f63db78 4b9c99b1<c0000001>  0725d400 c0000000 00c29830
Oops: Unrecoverable FP Unavailable Exception, sig: 6 [#7]
SMP NR_CPUS=1024 NUMA pSeries
last sysfs file: /sys/devices/system/cpu/cpu19/cache/index1/shared_cpu_map
Modules linked in: ipv6 fuse loop dm_mod sr_mod cdrom ibmveth sg sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt scsi_mod
NIP: c000000000648ed4 LR: c000000000648ed4 CTR: 0000000000000000
REGS: c00000010aadb270 TRAP: 0800   Tainted: G      D W    (2.6.35-rc3-git4-autotest)
MSR: 8000000000001032<ME,IR,DR>   CR: 24022422  XER: 00000000
TASK = c00000010aa5d400[8227] 'fs_racer_file_s' THREAD: c00000010aad8000 CPU: 7
GPR00: c000000000648ed4 c00000010aadb4f0 c000000000d3d798 c00000010809ad00
GPR04: c00000010aa5d920 c000000000087028 0000000024022424 c0000000000129c4
GPR08: c00000010aadb290 c000000000000000 c000000000086fcc c000000004ec5780
GPR12: 0000000028000428 c00000000f601180 0000000000000001 c00000010aadb560
GPR16: 0000000000000004 c000000000de2550 0000000000000000 c00000010aad8080
GPR20: c0000000006490b0 0000000000000000 c00000010aad8000 c000000000b15780
GPR24: c00000010aa5d7c0 0000000000000009 0000000100034b9d c00000010aa5d400
GPR28: c00000010eb98600 c0000000052c5780 c000000000c9fb00 c00000010ab53c00
NIP [c000000000648ed4] .schedule+0x620/0x770
LR [c000000000648ed4] .schedule+0x620/0x770
Call Trace:
[c00000010aadb4f0] [c000000000648ed4] .schedule+0x620/0x770 (unreliable)
[c00000010aadb600] [c0000000006490b0] .io_schedule+0x8c/0x108
[c00000010aadb690] [c000000000118408] .sync_page+0x78/0x94
[c00000010aadb710] [c0000000006495bc] .__wait_on_bit_lock+0x9c/0x140
[c00000010aadb7d0] [c000000000118344] .__lock_page+0x74/0x98
[c00000010aadb8b0] [c000000000118f00] .filemap_fault+0x114/0x430
[c00000010aadb980] [c000000000133d18] .__do_fault+0xa4/0x628
[c00000010aadba90] [c000000000136774] .handle_mm_fault+0x404/0x91c
[c00000010aadbb90] [c00000000064e4a0] .do_page_fault+0x42c/0x6b4
[c00000010aadbe30] [c000000000005628] handle_page_fault+0x20/0x74
Instruction dump:
2fa00000 409e000c f81b02a8 fbfd0878 387d0018 e8be8940 38800001 4ba79469
60000000 7f84e378 7f63db78 4b9c99b1<c0000001>  0725d400 c0000000 00c29830
---[ end trace 6d7478f9c45fb038 ]---
Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
Oops: Unrecoverable FP Unavailable Exception, sig: 6 [#8]
SMP NR_CPUS=1024 NUMA pSeries
last sysfs file: /sys/devices/system/cpu/cpu19/cache/index1/shared_cpu_map
Modules linked in: ipv6 fuse loop dm_mod sr_mod cdrom ibmveth sg sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt scsi_mod
NIP: c000000000648ed4 LR: c000000000648ed4 CTR: c00000000007e3f0
REGS: c00000010efaba00 TRAP: 0800   Tainted: G      D W    (2.6.35-rc3-git4-autotest)
MSR: 8000000000001032<ME,IR,DR>   CR: 24000022  XER: 00000006
TASK = c00000010ef18600[73] 'events/10' THREAD: c00000010efa8000 CPU: 10
GPR00: c000000000648ed4 c00000010efabc80 c000000000d3d798 c0000001096e4900
GPR04: c00000010ef18b20 c000000000087028 0000000024000028 c0000000000129c4
GPR08: c00000010efaba20 c000000000000000 c000000000086fcc c0000000054c5780
GPR12: 0000000028022428 c00000000f601900 0000000000000001
Unrecoverable FP Unavailable Exception 800 at c000000000648ed4
c00000010efabcf0
GPR16: 0000000000000004 c000000000de2550 0000000000000000 c00000010efa8080
GPR20: c0000000000a7658 0000000000000000 c00000010efa8000 c000000000b15780
GPR24: c00000010ef189c0 000000000000000a c0000000054c6ac0 c00000010ef18600
GPR28: c00000010b873300 c0000000054c5780 c000000000c9fb00 c000000109b20500
NIP [c000000000648ed4] .schedule+0x620/0x770
LR [c000000000648ed4] .schedule+0x620/0x770
Call Trace:
[c00000010efabc80] [c000000000648ed4] .schedule+0x620/0x770 (unreliable)
[c00000010efabd90] [c0000000000a7658] .worker_thread+0xf0/0x34c
[c00000010efabea0] [c0000000000acc48] .kthread+0xa8/0xb4
[c00000010efabf90] [c00000000002c698] .kernel_thread+0x54/0x70
Instruction dump:
2fa00000 409e000c f81b02a8 fbfd0878 387d0018 e8be8940 38800001 4ba79469
60000000 7f84e378 7f63db78 4b9c99b1<c0000001>  0725d400 c0000000 00c29830
Oops: Unrecoverable FP Unavailable Exception, sig: 6 [#9]
SMP NR_CPUS=1024 NUMA pSeries
last sysfs file: /sys/devices/system/cpu/cpu19/cache/index1/shared_cpu_map
Modules linked in: ipv6 fuse loop dm_mod sr_mod cdrom ibmveth sg sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt scsi_mod
NIP: c000000000648ed4 LR: c000000000648ed4 CTR: 0000000000000000
REGS: c000000108adb870 TRAP: 0800   Tainted: G      D W    (2.6.35-rc3-git4-autotest)
MSR: 8000000000001032<ME,IR,DR>   CR: 24042422  XER: 00000001
---[ end trace 6d7478f9c45fb039 ]---
TASK = c000000108a3cf00[7339] 'fs_racer.sh' THREAD: c000000108ad8000 CPU: 19
GPR00: c000000000648ed4 c000000108adbaf0 c000000000d3d798 c00000010ebb0c00
   ---[ end trace 6d7478f9c45fb03a ]---
---[ end trace 6d7478f9c45fb03b ]---
Kernel panic - not syncing: Attempted to kill the idle task!
Call Trace:
[c00000010e4d7790] [c000000000011c30] .show_stack+0x6c/0x16c (unreliable)
[c00000010e4d7840] [c0000000006514a0] .panic+0x94/0x140
[c00000010e4d78d0] [c000000000093ea8] .do_exit+0x98/0x71c
[c00000010e4d79b0] [c00000000002a568] .die+0x27c/0x2ac
[c00000010e4d7a50] [c000000000005110] fp_unavailable_common+0x110/0x180
--- Exception: 800 at .schedule+0x620/0x770
    LR = .schedule+0x620/0x770
[c00000010e4d7e50] [c0000000000140bc] .cpu_idle+0x1a4/0x1ac
[c00000010e4d7ee0] [c000000000656530] .start_secondary+0x378/0x3b0
[c00000010e4d7f90] [c0000000000082d8] .start_secondary_prolog+0x10/0x14
Rebooting in 180 seconds..
---[ end trace 6d7478f9c45fb03c ]---
Kernel panic - not syncing: Attempted to kill the idle task!
Call Trace:
[c000000000d3f700] [c000000000011c30] .show_stack+0x6c/0x16c (unreliable)
[c000000000d3f7b

BUG: spinlock lockup on CPU#5, fs_racer_dir_cr/7345, c000000004ac5780
Call Trace:
[c0000001097cabf0] [c000000000011c30] .show_stack+0x6c/0x16c (unreliable)
[c0000001097caca0] [c0000000003ad784] .do_raw_spin_lock+0x13c/0x184
[c0000001097cad40] [c00000000064c44c] ._raw_spin_lock+0x74/0xa4
[c0000001097cadd0] [c00000000008b804] .scheduler_tick+0x54/0x3a8
[c0000001097cae70] [c00000000009e148] .update_process_times+0x5c/0x88
[c0000001097caf10] [c0000000000bd2fc] .tick_sched_timer+0xa4/0xf0
[c0000001097cafb0] [c0000000000b0d84] .__run_hrtimer+0xac/0x11c
[c0000001097cb050] [c0000000000b1098] .hrtimer_interrupt+0x108/0x258
[c0000001097cb140] [c000000000029230] .timer_interrupt+0xe4/0x138
[c0000001097cb1d0] [c000000000003718] decrementer_common+0x118/0x180
--- Exception: 901 at .raw_local_irq_restore+0x6c/0x80
    LR = ._raw_spin_unlock_irq+0x3c/0x54
[c0000001097cb4c0] [c0000001097cb550] 0xc0000001097cb550 (unreliable)
[c0000001097cb550] [c00000000064cf78] ._raw_spin_unlock_irq+0x3c/0x54
[c0000001097cb5e0] [c0000000000d703c] .acct_collect+0x1b0/0x1d4
[c0000001097cb680] [c000000000094008] .do_exit+0x1f8/0x71c
[c0000001097cb760] [c00000000002a568] .die+0x27c/0x2ac
[c0000001097cb800] [c000000000005110] fp_unavailable_common+0x110/0x180
--- Exception: 800 at .schedule+0x620/0x770
    LR = .schedule+0x620/0x770
[c0000001097cbc00] [c0000000000939b0] .do_wait+0x19c/0x220
[c0000001097cbcc0] [c000000000093b04] .SyS_wait4+0xd0/0x108
[c0000001097cbdc0] [c00000000009138c] .SyS_waitpid+0x1c/0x30
[c0000001097cbe30] [c0000000000085b4] syscall_exit+0x0/0x40
BUG: spinlock lockup on CPU#4, fs_racer_file_c/7356, c0000000048c5780
Call Trace:
[c00000010979abf0] [c000000000011c30] .show_stack+0x6c/0x16c (unreliable)
[c00000010979aca0] [c0000000003ad784] .do_raw_spin_lock+0x13c/0x184
[c00000010979ad40] [c00000000064c44c] ._raw_spin_lock+0x74/0xa4
[c00000010979add0] [c00000000008b804] .scheduler_tick+0x54/0x3a8
[c00000010979ae70] [c00000000009e148] .update_process_times+0x5c/0x88
[c00000010979af10] [c0000000000bd2fc] .tick_sched_timer+0xa4/0xf0
[c00000010979afb0] [c0000000000b0d84] .__run_hrtimer+0xac/0x11c
[c00000010979b050] [c0000000000b1098] .hrtimer_interrupt+0x108/0x258
[c00000010979b140] [c000000000029230] .timer_interrupt+0xe4/0x138
[c00000010979b1d0] [c000000000003718] decrementer_common+0x118/0x180
--- Exception: 901 at .raw_local_irq_restore+0x6c/0x80
    LR = ._raw_spin_unlock_irq+0x3c/0x54
[c00000010979b4c0] [c00000010979b550] 0xc00000010979b550 (unreliable)
[c00000010979b550] [c00000000064cf78] ._raw_spin_unlock_irq+0x3c/0x54
[c00000010979b5e0] [c0000000000d703c] .acct_collect+0x1b0/0x1d4
[c00000010979b680] [c000000000094008] .do_exit+0x1f8/0x71c
[c00000010979b760] [c00000000002a568] .die+0x27c/0x2ac
[c00000010979b800] [c000000000005110] fp_unavailable_common+0x110/0x180
--- Exception: 800 at .schedule+0x620/0x770
    LR = .schedule+0x620/0x770
[c00000010979bc00] [c0000000000939b0] .do_wait+0x19c/0x220
[c00000010979bcc0] [c000000000093b04] .SyS_wait4+0xd0/0x108
[c00000010979bdc0] [c00000000009138c] .SyS_waitpid+0x1c/0x30
[c00000010979be30] [c0000000000085b4] syscall_exit+0x0/0x40
BUG: spinlock lockup on CPU#6, mkdir/8226, c000000001692670
Call Trace:
[c000000108a8b5d0] [c000000000011c30] .show_stack+0x6c/0x16c (unreliable)
[c000000108a8b680] [c0000000003ad784] .do_raw_spin_lock+0x13c/0x184
[c000000108a8b720] [c00000000064c3a0] ._raw_spin_lock_irqsave+0x84/0xbc
[c000000108a8b7c0] [c00000000007b504] .__wake_up+0x34/0x88
[c000000108a8b870] [c0000000000ad180] .__wake_up_bit+0x3c/0x50
[c000000108a8b8f0] [c000000000118538] .unlock_page+0x40/0x58
[c000000108a8b980] [c00000000013421c] .__do_fault+0x5a8/0x628
[c000000108a8ba90] [c000000000136774] .handle_mm_fault+0x404/0x91c
[c000000108a8bb90] [c00000000064e4a0] .do_page_fault+0x42c/0x6b4
[c000000108a8be30] [c000000000005628] handle_page_fault+0x20/0x74
BUG: spinlock lockup on CPU#12, ln/8223, c000000001692670
Call Trace:
[c0000000a28635d0] [c000000000011c30] .show_stack+0x6c/0x16c (unreliable)
[c0000000a2863680] [c0000000003ad784] .do_raw_spin_lock+0x13c/0x184
[c0000000a2863720] [c00000000064c3a0] ._raw_spin_lock_irqsave+0x84/0xbc
[c0000000a28637c0] [c00000000007b504] .__wake_up+0x34/0x88
[c0000000a2863870] [c0000000000ad180] .__wake_up_bit+0x3c/0x50
[c0000000a28638f0] [c000000000118538] .unlock_page+0x40/0x58
[c0000000a2863980] [c00000000013421c] .__do_fault+0x5a8/0x628
[c0000000a2863a90] [c000000000136774] .handle_mm_fault+0x404/0x91c
[c0000000a2863b90] [c00000000064e4a0] .do_page_fault+0x42c/0x6b4
[c0000000a2863e30] [c000000000005628] handle_page_fault+0x20/0x74
BUG: spinlock lockup on CPU#17, fs_racer_file_c/8232, c000000001692670
Call Trace:
[c00000010ee7f5d0] [c000000000011c30] .show_stack+0x6c/0x16c (unreliable)
[c00000010ee7f680] [c0000000003ad784] .do_raw_spin_lock+0x13c/0x184
[c00000010ee7f720] [c00000000064c3a0] ._raw_spin_lock_irqsave+0x84/0xbc
[c00000010ee7f7c0] [c00000000007b504] .__wake_up+0x34/0x88
[c00000010ee7f870] [c0000000000ad180] .__wake_up_bit+0x3c/0x50
[c00000010ee7f8f0] [c000000000118538] .unlock_page+0x40/0x58
[c00000010ee7f980] [c00000000013421c] .__do_fault+0x5a8/0x628
[c00000010ee7fa90] [c000000000136774] .handle_mm_fault+0x404/0x91c
[c00000010ee7fb90] [c00000000064e4a0] .do_page_fault+0x42c/0x6b4
[c00000010ee7fe30] [c000000000005628] handle_page_fault+0x20/0x74
BUG: spinlock lockup on CPU#15, klogd/1511, c0000000040c5780
Call Trace:
[c000000107497300] [c000000000011c30] .show_stack+0x6c/0x16c (unreliable)
[c0000001074973b0] [c0000000003ad784] .do_raw_spin_lock+0x13c/0x184
[c000000107497450] [c00000000064c44c] ._raw_spin_lock+0x74/0xa4
[c0000001074974e0] [c00000000007ba68] .task_rq_lock+0x6c/0xd4
[c000000107497580] [c000000000087d74] .try_to_wake_up+0x50/0x454
[c000000107497640] [c0000000001838dc] .pollwake+0x9c/0xcc
[c000000107497720] [c0000000000797c0] .__wake_up_common+0x6c/0xe0
[c0000001074977d0] [c00000000007b494] .__wake_up_sync_key+0x68/0x9c
[c000000107497870] [c00000000059304c] .sock_def_readable+0x84/0xd8
[c0000001074978f0] [c00000000063996c] .unix_dgram_sendmsg+0x4e4/0x610
[c000000107497a30] [c00000000058e318] .sock_aio_write+0x170/0x1a8
[c000000107497b60] [c00000000016e4e4] .do_sync_write+0xac/0x10c
[c000000107497ce0] [c00000000016f2a4] .vfs_write+0xec/0x1dc
[c000000107497d80] [c00000000016f49c] .SyS_write+0x58/0xa0
[c000000107497e30] [c0000000000085b4] syscall_exit+0x0/0x40
BUG: spinlock lockup on CPU#14, true/8230, c0000000052c5780
Call Trace:
[c00000010b3d6c40] [c000000000011c30] .show_stack+0x6c/0x16c (unreliable)
[c00000010b3d6cf0] [c0000000003ad784] .do_raw_spin_lock+0x13c/0x184
[c00000010b3d6d90] [c00000000064c44c] ._raw_spin_lock+0x74/0xa4
[c00000010b3d6e20] [c00000000007ba68] .task_rq_lock+0x6c/0xd4
[c00000010b3d6ec0] [c000000000087d74] .try_to_wake_up+0x50/0x454
[c00000010b3d6f80] [c0000000000ad1ec] .autoremove_wake_function+0x18/0x54
[c00000010b3d7000] [c0000000000797c0] .__wake_up_common+0x6c/0xe0
[c00000010b3d70b0] [c00000000007b524] .__wake_up+0x54/0x88
[c00000010b3d7160] [c0000000000ad180] .__wake_up_bit+0x3c/0x50
[c00000010b3d71e0] [c000000000118538] .unlock_page+0x40/0x58
[c00000010b3d7270] [c00000000013421c] .__do_fault+0x5a8/0x628
[c00000010b3d7380] [c000000000136774] .handle_mm_fault+0x404/0x91c
[c00000010b3d7480] [c00000000064e4a0] .do_page_fault+0x42c/0x6b4
[c00000010b3d7720] [c000000000005628] handle_page_fault+0x20/0x74
--- Exception: 301 at .__clear_user+0x14/0x7c
    LR = .padzero+0x74/0x128
[c00000010b3d7a10] [c0000000001c2354] .padzero+0x44/0x128 (unreliable)
[c00000010b3d7aa0] [c0000000001c3530] .load_elf_binary+0xca4/0x16a8
[c00000010b3d7be0] [c0000000001753b0] .search_binary_handler+0x11c/0x37c
[c00000010b3d7cc0] [c000000000176d0c] .do_execve+0x1bc/0x2e8
[c00000010b3d7d90] [c000000000012740] .sys_execve+0x70/0xac
[c00000010b3d7e30] [c0000000000085b4] syscall_exit+0x0/0x40
BUG: spinlock lockup on CPU#1, true/8225, c000000001692670
Call Trace:
[c00000010a18b5d0] [c000000000011c30] .show_stack+0x6c/0x16c (unreliable)
[c00000010a18b680] [c0000000003ad784] .do_raw_spin_lock+0x13c/0x184
[c00000010a18b720] [c00000000064c3a0] ._raw_spin_lock_irqsave+0x84/0xbc
[c00000010a18b7c0] [c00000000007b504] .__wake_up+0x34/0x88
[c00000010a18b870] [c0000000000ad180] .__wake_up_bit+0x3c/0x50
[c00000010a18b8f0] [c000000000118538] .unlock_page+0x40/0x58
[c00000010a18b980] [c00000000013421c] .__do_fault+0x5a8/0x628
[c00000010a18ba90] [c000000000136774] .handle_mm_fault+0x404/0x91c
[c00000010a18bb90] [c00000000064e4a0] .do_page_fault+0x42c/0x6b4
[c00000010a18be30] [c000000000005628] handle_page_fault+0x20/0x74
BUG: spinlock lockup on CPU#3, true/8220, c000000001692670
Call Trace:
[c0000001085e75d0] [c000000000011c30] .show_stack+0x6c/0x16c (unreliable)
[c0000001085e7680] [c0000000003ad784] .do_raw_spin_lock+0x13c/0x184
[c0000001085e7720] [c00000000064c3a0] ._raw_spin_lock_irqsave+0x84/0xbc
[c0000001085e77c0] [c00000000007b504] .__wake_up+0x34/0x88
[c0000001085e7870] [c0000000000ad180] .__wake_up_bit+0x3c/0x50
[c0000001085e78f0] [c000000000118538] .unlock_page+0x40/0x58
[c0000001085e7980] [c00000000013421c] .__do_fault+0x5a8/0x628
[c0000001085e7a90] [c000000000136774] .handle_mm_fault+0x404/0x91c
[c0000001085e7b90] [c00000000064e4a0] .do_page_fault+0x42c/0x6b4
[c0000001085e7e30] [c000000000005628] handle_page_fault+0x20/0x74
BUG: spinlock lockup on CPU#2, mkdir/8219, c000000001692670
Call Trace:
[c00000010b3cf5d0] [c000000000011c30] .show_stack+0x6c/0x16c (unreliable)
[c00000010b3cf680] [c0000000003ad784] .do_raw_spin_lock+0x13c/0x184
[c00000010b3cf720] [c00000000064c3a0] ._raw_spin_lock_irqsave+0x84/0xbc
[c00000010b3cf7c0] [c00000000007b504] .__wake_up+0x34/0x88
[c00000010b3cf870] [c0000000000ad180] .__wake_up_bit+0x3c/0x50
[c00000010b3cf8f0] [c000000000118538] .unlock_page+0x40/0x58
[c00000010b3cf980] [c00000000013421c] .__do_fault+0x5a8/0x628
[c00000010b3cfa90] [c000000000136774] .handle_mm_fault+0x404/0x91c
[c00000010b3cfb90] [c00000000064e4a0] .do_page_fault+0x42c/0x6b4
[c00000010b3cfe30] [c000000000005628] handle_page_fault+0x20/0x74
-- 0:conmux-control -- time-stamp -- Jun/29/10 21:12:40 -- 

--------------050707020305090106030504--
