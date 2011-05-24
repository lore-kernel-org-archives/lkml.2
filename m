Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab1EXOfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:35:40 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60979 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab1EXOff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:35:35 -0400
Date: Tue, 24 May 2011 07:35:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
Message-ID: <20110524143527.GA2266@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110519222404.GG12600@redhat.com>
 <20110521210013.GJ2271@linux.vnet.ibm.com>
 <20110523152141.GB4019@redhat.com>
 <20110523153848.GC2310@linux.vnet.ibm.com>
 <1306189249.15900.10.camel@t41.thuisdomein>
 <4DDB7D36.60905@fusionio.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <4DDB7D36.60905@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 24, 2011 at 11:41:10AM +0200, Jens Axboe wrote:
> On 2011-05-24 00:20, Paul Bolle wrote:
> > On Mon, 2011-05-23 at 08:38 -0700, Paul E. McKenney wrote:
> >> Running under CONFIG_PREEMPT=y (along with CONFIG_TREE_PREEMPT_RCU=y)
> >> could be very helpful in and of itself.  CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> >> can also be helpful.  In post-2.6.39 mainline, it should be possible
> >> to set CONFIG_DEBUG_OBJECTS_RCU_HEAD=y without CONFIG_PREEMPT=y, but
> >> again, CONFIG_PREEMPT=y can help find problems.
> > 
> > 0) The first thing I tried (from your suggestions) was
> > CONFIG_DEBUG_OBJECTS_RCU_HEAD=y. Given its dependencies (and, well, the
> > build system I used) I ended up with:
> > 
> >     $ grep -e PREEMPT -e RCU /boot/config-2.6.39-0.local3.fc16.i686 |
> >     grep -v "^#"
> >     CONFIG_TREE_PREEMPT_RCU=y
> >     CONFIG_PREEMPT_RCU=y
> >     CONFIG_RCU_FANOUT=32
> >     CONFIG_PREEMPT_NOTIFIERS=y
> >     CONFIG_PREEMPT=y
> >     CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> >     CONFIG_DEBUG_PREEMPT=y
> >     CONFIG_PROVE_RCU=y
> >     CONFIG_SPARSE_RCU_POINTER=y
> > 
> > It looks like I am unable to trigger the issue we're talking about here
> > when using that config.
> > 
> > 1) For reference, the config of a kernel that does trigger it had:
> > 
> >     $ grep -e PREEMPT -e RCU /boot/config-2.6.39-0.local2.fc16.i686 |
> >     grep -v "^#"
> >     CONFIG_TREE_RCU=y
> >     CONFIG_RCU_FANOUT=32
> >     CONFIG_RCU_FAST_NO_HZ=y
> >     CONFIG_PREEMPT_NOTIFIERS=y
> >     CONFIG_PREEMPT_VOLUNTARY=y
> >     CONFIG_PROVE_RCU=y
> >     CONFIG_SPARSE_RCU_POINTER=y
> > 
> >>> Again CONFIG_TREE_PREEMPT_RCU is available only if PREEMPT=y. So should
> >>> we enable preemtion and CONFIG_TREE_PREEMPT_RCU=y and try to reproduce
> >>> the issue?
> >>
> >> Please!
> > 
> > 2) It appears I can't reproduce with those options enabled (see above).
> > 
> >> Polling is fine.  Please see attached for a script to poll at 15-second
> >> intervals.  Please also feel free to adjust, just tell me what you
> >> adjusted.
> > 
> > And should I now try to run that script on a config that triggers this
> > issue (such as the config under 1) above)?
> 
> Paul, can we see a dmesg from your running system? Perhaps there's some
> dependency on a particular driver or device that makes this easier to
> reproduce.

Here you go, please see attached.

I should have some additional diagnostics later today Pacific time.

							Thanx, Paul

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Description: console.log
Content-Disposition: attachment; filename="console.log"

Connected to vogons console [channel connected] (~$quit to exit)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Shutting down Avahi daemon: [  OK  ]
Running guests on default URI: no running guests.
Stopping libvirtd daemon: [  OK  ]
Stopping atd: [  OK  ]
Stopping abrt daemon: [  OK  ]
Stopping sshd: [  OK  ]
Shutting down postfix: [  OK  ]
Stopping crond: [  OK  ]
Stopping automount: [  OK  ]
Stopping HAL daemon: [  OK  ]
Stopping iprdump: [  OK  ]
Stopping iprinit: [  OK  ]Stopping iprupdate: [  OK  ]Stopping NetworkManager daemon: ehea: eth1: Logical port down
ehea: eth1: Physical port up
ehea: External switch port is backup port
[  OK  ]
Killing mdmonitor: [  OK  ]
Stopping system message bus: [  OK  ]
Stopping rpcbind: [  OK  ]
Stopping auditd: type=1305 audit(1306123304.459:167): audit_pid=0 old=983 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[  OK  ]
Shutting down interface eth0:  ehea: eth0: Logical port down
ehea: eth0: Physical port up
ehea: External switch port is backup port
[  OK  ]
Shutting down loopback interface:  [  OK  ]
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
ip6tables: Flushing firewall rules: [  OK  ]
ip6tables: Setting chains to policy ACCEPT: filter [  OK  ]
ip6tables: Unloading modules: [  OK  ]
iptables: Flushing firewall rules: [  OK  ]
iptables: Setting chains to policy ACCEPT: mangle nat filter [  OK  ]
iptables: Unloading modules: [  OK  ]
Stopping cgconfig service: [  OK  ]
Sending all processes the TERM signal... [  OK  ]
Sending all processes the KILL signal... [  OK  ]
Saving random seed:  [  OK  ]
Syncing hardware clock to system time type=1111 audit(1306123314.500:168): user pid=15173 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:hwclock_t:s0 msg='changing system time: exe="/sbin/hwclock" hostname=? addr=? terminal=? res=success'
[  OK  ]
Turning off quotas:  [  OK  ]
Unmounting pipe file systems:  [  OK  ]
Unmounting file systems:  [  OK  ]
init: Re-executing /sbin/init
Please stand by while rebooting the system...
type=1128 audit(1306123315.030:169): user pid=14476 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0 msg='init: exe="/sbin/reboot" hostname=? addr=? terminal=console res=success'
md: stopping all md devices.
ehea: Reboot: freeing all eHEA resources
Restarting system.
























IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 

          1 = SMS Menu                          5 = Default Boot List
          8 = Open Firmware Prompt              6 = Stored Boot List


     Memory      Keyboard     Network     SCSI     Speaker 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM                             IBM IBM IBM IBM IBM IBM
IBM IBM IBM IBM IBM IBM     STARTING SOFTWARE       IBM IBM IBM IBM IBM IBM
IBM IBM IBM IBM IBM IBM        PLEASE WAIT...       IBM IBM IBM IBM IBM IBM
IBM IBM IBM IBM IBM IBM                             IBM IBM IBM IBM IBM IBM
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
-\|/-\|/-\|
Elapsed time since release of system processors: 2247 mins 32 secs

Config file read, 2048 bytes
Welcome to Red Hat Enterprise Linux!
Hit <TAB> for boot options
Welcome to yaboot version 1.3.16 (Red Hat 1.3.16-0.2.el6)
Enter "help" to get some basic usage information
boot: default
Please wait, loading kernel...
   Elf64 kernel loaded...
Loading ramdisk...
ramdisk loaded at 03500000, size: 13620 Kbytes
OF stdout device is: /vdevice/vty@30000000
Preparing to boot Linux version 2.6.32-71.el6.ppc64 (mockbuild@js20-bc2-12.build.redhat.com) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #1 SMP Wed Sep 1 02:56:55 EDT 2010
Max number of cores passed to firmware: 0x0000000000000200
Calling ibm,client-architecture-support... done
command line: root=/dev/sda5 console=hvc0 multipath=off  
memory layout at init:
  memory_limit : 0000000000000000 (16 MB aligned)
  alloc_bottom : 0000000004250000
  alloc_top    : 0000000010000000
  alloc_top_hi : 0000000010000000
  rmo_top      : 0000000010000000
  ram_top      : 0000000010000000
found display   : /pci@800000020000202/display@1, opening... done
instantiating rtas at 0x000000000f3e0000... done
boot cpu hw idx 0000000000000000
starting cpu hw idx 0000000000000002... done
starting cpu hw idx 0000000000000004... done
starting cpu hw idx 0000000000000006... done
copying OF device tree...
Building dt strings...
Building dt structure...
Device tree strings 0x0000000004260000 -> 0x00000000042617da
Device tree struct  0x0000000004270000 -> 0x0000000004290000
Calling quiesce...
returning from prom_init
Using pSeries machine description
Using 1TB segments
Found initrd at 0xc000000003500000:0xc00000000424d000
bootconsole [udbg0] enabled
Partition configured for 8 cpus.
CPU maps initialized for 2 threads per core
Starting Linux PPC64 #1 SMP Wed Sep 1 02:56:55 EDT 2010
-----------------------------------------------------
ppc64_pft_size                = 0x1c
physicalMemorySize            = 0x3d4000000
htab_hash_mask                = 0x1fffff
-----------------------------------------------------
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.32-71.el6.ppc64 (mockbuild@js20-bc2-12.build.redhat.com) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #1 SMP Wed Sep 1 02:56:55 EDT 2010
[boot]0012 Setup Arch
PCI host bridge /pci@800000020000200  ranges:
  IO 0x00003dffe01f0000..0x00003dffe01fffff -> 0x00000000000f0000
 MEM 0x00003c0000000000..0x00003c007fffffff -> 0x0000000080000000 
PCI host bridge /pci@800000020000201  ranges:
  IO 0x00003dffe02f0000..0x00003dffe02fffff -> 0x00000000000f0000
 MEM 0x00003c0080000000..0x00003c00ffffffff -> 0x0000000080000000 
PCI host bridge /pci@800000020000202  ranges:
  IO 0x00003dffe03f0000..0x00003dffe03fffff -> 0x00000000000f0000
 MEM 0x00003c0100000000..0x00003c017fffffff -> 0x0000000080000000 
EEH: PCI Enhanced I/O Error Handling Enabled
PPC64 nvram contains 15360 bytes
Zone PFN ranges:
  DMA      0x00000000 -> 0x0003d400
  Normal   0x0003d400 -> 0x0003d400
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0001e000
    1: 0x0001e000 -> 0x0003d400
[boot]0015 Setup Done
PERCPU: Embedded 2 pages/cpu @c000000001400000 s93240 r0 d37832 u131072
pcpu-alloc: s93240 r0 d37832 u131072 alloc=1*1048576
pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Built 2 zonelists in Node order, mobility grouping on.  Total pages: 250665
Policy zone: DMA
Kernel command line: root=/dev/sda5 console=hvc0 multipath=off  
PID hash table entries: 4096 (order: -1, 32768 bytes)
freeing bootmem node 0
freeing bootmem node 1
Memory: 15945856k/16056320k available (12928k kernel code, 110464k reserved, 2752k data, 4414k bss, 4800k init)
Hierarchical RCU implementation.
NR_IRQS:512
[boot]0020 XICS Init
[boot]0021 XICS Done
clocksource: timebase mult[7d0000] shift[22] registered
Console: colour dummy device 80x25
console [hvc0] enabled, bootconsole disabled
console [hvc0] enabled, bootconsole disabled
allocated 10035200 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Initializing.
Dentry cache hash table entries: 2097152 (order: 8, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 7, 8388608 bytes)
Mount-cache hash table entries: 4096
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
Processor 1 found.
Processor 2 found.
Processor 3 found.
Processor 4 found.
Processor 5 found.
Processor 6 found.
Processor 7 found.
Brought up 8 CPUs
devtmpfs: initialized
regulator: core version 0.5
NET: Registered protocol family 16
IBM eBus Device Driver
POWER6 performance monitor hardware support registered
PCI: Probing PCI hardware
IOMMU table initialized, virtual merging enabled
pci 0001:00:01.0: PME# supported from D0 D1 D2 D3hot
pci 0001:00:01.0: PME# disabled
pci 0001:00:01.1: PME# supported from D0 D1 D2 D3hot
pci 0001:00:01.1: PME# disabled
pci 0001:00:01.2: PME# supported from D0 D1 D2 D3hot
pci 0001:00:01.2: PME# disabled
bio: create slab <bio-0> at 0
vgaarb: device added: PCI:0002:00:01.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Switching to clocksource timebase
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 6, 4194304 bytes)
TCP established hash table entries: 524288 (order: 7, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 4, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 13620k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1306123375.390:1): initialized
HugeTLB registered 16 MB page size, pre-allocated 0 pages
HugeTLB registered 16 GB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
msgmni has been set to 31168
alg: No test for stdrng (krng)
ksign: Installing public key data
Loading keyring
- Added public key FCF3FD17E3D277B8
- User ID: Red Hat, Inc. (Kernel Module GPG key)
- Added public key D4A26C9CCD09BEDA
- User ID: Red Hat Enterprise Linux Driver Update Program <secalert@redhat.com>
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
pci-stub: invalid id string ""
Using unsupported 640x480 display at 3c0178000000, depth=8, pitch=640
Console: switching to colour frame buffer device 80x30
fb0: Open Firmware frame buffer device on /pci@800000020000202/display@1
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input0
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0001:00:01.2: enabling device (0140 -> 0142)
ehci_hcd 0001:00:01.2: EHCI Host Controller
ehci_hcd 0001:00:01.2: new USB bus registered, assigned bus number 1
ehci_hcd 0001:00:01.2: irq 307, io mem 0x3c00ffffd000
ehci_hcd 0001:00:01.2: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.32-71.el6.ppc64 ehci_hcd
usb usb1: SerialNumber: 0001:00:01.2
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0001:00:01.0: OHCI Host Controller
ohci_hcd 0001:00:01.0: new USB bus registered, assigned bus number 2
ohci_hcd 0001:00:01.0: irq 305, io mem 0x3c00ffffe000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.32-71.el6.ppc64 ohci_hcd
usb usb2: SerialNumber: 0001:00:01.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ohci_hcd 0001:00:01.1: OHCI Host Controller
ohci_hcd 0001:00:01.1: new USB bus registered, assigned bus number 3
ohci_hcd 0001:00:01.1: irq 306, io mem 0x3c00fffff000
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.32-71.el6.ppc64 ohci_hcd
usb usb3: SerialNumber: 0001:00:01.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
mice: PS/2 mouse device common for all mice
rtc-generic rtc-generic: rtc core: registered rtc-generic as rtc0
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
rtc-generic rtc-generic: setting system clock to 2011-05-23 04:02:56 UTC (1306123376)
Initalizing network drop monitor service
Freeing unused kernel memory: 4800k freed
dracut: dracut-004-32.el6
WARNING: Deprecated config file /etc/modprobe.conf, all config files belong into /etc/modprobe.d/.
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
udev: starting version 147
[drm] Initialized drm 1.1.0 20060810
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
[drm] initializing kernel modesetting (RV100 0x1002:0x515E).
[drm] register mmio base: 0x77FD0000
[drm] register mmio size: 65536
radeon 0002:00:01.0: Invalid ROM contents
radeon 0002:00:01.0: Invalid ROM contents
[drm:radeon_get_bios] *ERROR* Unable to locate a BIOS ROM
[drm] Using generic clock info
radeon 0002:00:01.0: VRAM: 64M 0x3C0178000000 - 0x3C017BFFFFFF (16M used)
radeon 0002:00:01.0: GTT: 512M 0x3C017C000000 - 0x3C019BFFFFFF
[drm] radeon: irq initialized.
[drm] Detected VRAM RAM=64M, BAR=128M
[drm] RAM width 16bits DDR
[TTM] Zone  kernel: Available graphics memory: 7982144 kiB.
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[drm] radeon: 16M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] GART: num cpu pages 8192, num gpu pages 131072
[drm] Loading R100 Microcode
platform radeon_cp.0: firmware: requesting radeon/R100_cp.bin
[drm] radeon: ring at 0x00003C017C000000
[drm] ring test succeeded in 1 usecs
[drm] radeon: ib pool ready.
[drm] ib test succeeded in 0 usecs
[drm] Connector Table: 10 (rn50-power)
[drm] No TV DAC info found in BIOS
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   VGA
[drm]   DDC: 0x60 0x60 0x60 0x60 0x60 0x60 0x60 0x60
[drm]   Encoders:
[drm]     CRT1: INTERNAL_DAC1
[drm] Connector 1:
[drm]   VGA
[drm]   DDC: 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c 0x6c
[drm]   Encoders:
[drm]     CRT2: INTERNAL_DAC2
[drm] fb mappable at 0x3C0178040000
[drm] vram apper at 0x3C0178000000
[drm] size 786432
[drm] fb depth is 8
[drm]    pitch is 1024
fb: conflicting fb hw usage radeondrmfb vs OFfb display - removing generic driver
Console: switching to colour dummy device 80x25
Trying to free nonexistent resource <00003c0178000000-00003c017804afff>
Console: switching to colour frame buffer device 128x48
fb0: radeondrmfb frame buffer device
drm: registered panic notifier
Slow work thread pool: Starting up
Slow work thread pool: Ready
[drm] Initialized radeon 2.1.0 20080528 for 0002:00:01.0 on minor 0
dracut: Starting plymouth daemon
could not read byte from child: Success
IBM eHEA ethernet device driver (Release EHEA_0103-02)
ehea: eth0: Jumbo frames are enabled
ehea: eth0 -> logical port id #1
ehea: eth1: Jumbo frames are enabled
ehea: eth1 -> logical port id #2
ipr: IBM Power RAID SCSI Device Driver version: 2.4.3 (June 10, 2009)
ipr 0000:00:01.0: Found IOA with IRQ: 289
ipr 0000:00:01.0: Starting IOA initialization sequence.
ipr 0000:00:01.0: Adapter firmware version: 0220004A
ipr 0000:00:01.0: IOA initialized.
scsi0 : IBM 572C Storage Adapter
scsi 0:3:0:0: Direct-Access     IBM-ESXS ST9146802SS      B526 PQ: 0 ANSI: 5
scsi 0:8:0:0: Enclosure         IBM      VSBPD1BB   SAS     01 PQ: 0 ANSI: 2
scsi: unknown device type 31
scsi 0:255:255:255: No Device         IBM      572C001SISIOA    0150 PQ: 0 ANSI: 0
sd 0:3:0:0: [sda] 286748000 512-byte logical blocks: (146 GB/136 GiB)
sd 0:3:0:0: [sda] Write Protect is off
sd 0:3:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
sd 0:3:0:0: [sda] Attached SCSI disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
dracut: Remounting /dev/sda5 with -o errors=remount-ro,ro
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
dracut: Mounted root filesystem /dev/sda5
dracut: Loading SELinux policy
SELinux:  Disabled at runtime.
type=1404 audit(1306123379.672:2): selinux=0 auid=4294967295 ses=4294967295
dracut: /sbin/load_policy: Can't load policy: No such file or directory
dracut: Switching root
readahead-collector: starting
                Welcome to Red Hat Enterprise Linux Server
Starting udev: udev: starting version 147
sd 0:3:0:0: Attached scsi generic sg0 type 0
scsi 0:8:0:0: Attached scsi generic sg1 type 13
scsi 0:255:255:255: Attached scsi generic sg2 type 31
ses 0:8:0:0: Attached Enclosure device
[  OK  ]
Setting hostname vogons.ltc.austin.ibm.com:  [  OK  ]
Setting up Logical Volume Management:   No volume groups found
[  OK  ]
Checking filesystems
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/sda5 
deploy_root: clean, 52117/1281120 files, 414664/5120000 blocks
[  OK  ]
Remounting root filesystem in read-write mode:  EXT3 FS on sda5, internal journal
[  OK  ]
Mounting local filesystems:  [  OK  ]
Enabling local filesystem quotas:  [  OK  ]
Enabling /etc/fstab swaps:  Adding 4095872k swap on /dev/sda7.  Priority:-1 extents:1 across:4095872k 
[  OK  ]
readahead-disable-service: delaying service auditd
Entering non-interactive startup
Calling the system activity data collector (sadc): 
WARNING: Deprecated config file /etc/modprobe.conf, all config files belong into /etc/modprobe.d/.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  ehea: eth0: Physical port up
ehea: External switch port is backup port
[  OK  ]
Bringing up interface eth1:  ehea: eth1: Physical port up
ehea: External switch port is backup port
[  OK  ]
Starting system logger: [  OK  ]
Starting irqbalance: [  OK  ]
Starting mdmonitor: [  OK  ]
Starting kdump:[FAILED]
Starting system message bus: [  OK  ]
Mounting other filesystems:  [  OK  ]
Starting HAL daemon: [  OK  ]
Starting iprinit: [  OK  ]
Starting iprupdate: [  OK  ]
Retrigger failed udev events[  OK  ]
Adding udev persistent rules[  OK  ]
Starting iprdump: [  OK  ]
Starting sshd: [  OK  ]
Starting postfix: [  OK  ]
Starting abrt daemon: [  OK  ]
Starting crond: [  OK  ][  OK  ]
Starting atd: [  OK  ][  OK  ]

Red Hat Enterprise Linux Server release 6.0 (Santiago)
Kernel 2.6.32-71.el6.ppc64 on an ppc64

vogons.ltc.austin.ibm.com login: readahead-collector: starting delayed service auditd
readahead-collector: sorting
readahead-collector: finished
(bot:conmon-payload) connected
-- 0:conmux-control -- time-stamp -- May/22/11 21:05:39 --
-- 0:conmux-control -- time-stamp -- May/22/11 21:11:02 --
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
could not read byte from child: Success
initctl: Event failed
Stopping atd: [  OK  ]
Stopping abrt daemon: [  OK  ]
Stopping sshd: [  OK  ]
Shutting down postfix: [  OK  ]
Stopping crond: [  OK  ]
Stopping HAL daemon: [  OK  ]
Stopping iprdump: [  OK  ]
Stopping iprinit: [  OK  ]Stopping iprupdate: [  OK  ]Killing mdmonitor: [  OK  ]
Stopping system message bus: [  OK  ]
Stopping auditd: type=1305 audit(1306123950.060:15436): audit_pid=0 old=1342 auid=4294967295 ses=4294967295 res=1
[  OK  ]
Shutting down interface eth0:  ehea: eth0: Logical port down
ehea: eth0: Physical port up
ehea: External switch port is backup port
[  OK  ]
Shutting down interface eth1:  ehea: eth1: Logical port down
ehea: eth1: Physical port up
ehea: External switch port is backup port
[  OK  ]
Shutting down loopback interface:  [  OK  ]
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
Sending all processes the TERM signal... [  OK  ]
Sending all processes the KILL signal... [  OK  ]
Saving random seed:  [  OK  ]
Syncing hardware clock to system time type=1111 audit(1306123954.500:15437): user pid=11921 uid=0 auid=4294967295 ses=4294967295 msg='changing system time: exe="/sbin/hwclock" hostname=? addr=? terminal=console res=success'
[  OK  ]
Turning off swap:  [  OK  ]
Turning off quotas:  [  OK  ]
init: Re-executing /sbin/init
Please stand by while rebooting the system...
type=1128 audit(1306123955.068:15438): user pid=11582 uid=0 auid=4294967295 ses=4294967295 msg='init: exe="/sbin/reboot" hostname=? addr=? terminal=console res=success'
md: stopping all md devices.
ehea: Reboot: freeing all eHEA resources
Restarting system.
























IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 

          1 = SMS Menu                          5 = Default Boot List
          8 = Open Firmware Prompt              6 = Stored Boot List


     Memory      Keyboard     Network     SCSI     Speaker 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM                             IBM IBM IBM IBM IBM IBM
IBM IBM IBM IBM IBM IBM     STARTING SOFTWARE       IBM IBM IBM IBM IBM IBM
IBM IBM IBM IBM IBM IBM        PLEASE WAIT...       IBM IBM IBM IBM IBM IBM
IBM IBM IBM IBM IBM IBM                             IBM IBM IBM IBM IBM IBM
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
-\|/-\|/-\|
Elapsed time since release of system processors: 2258 mins 11 secs

Config file read, 2048 bytes
Welcome to Red Hat Enterprise Linux!
Hit <TAB> for boot options
Welcome to yaboot version 1.3.16 (Red Hat 1.3.16-0.2.el6)
Enter "help" to get some basic usage information
boot: autobench
Please wait, loading kernel...
   Elf64 kernel loaded...
Loading ramdisk...
ramdisk loaded at 03500000, size: 6629 Kbytes
OF stdout device is: /vdevice/vty@30000000
Preparing to boot Linux version 2.6.39-rc6-autokern1 (root@vogons.ltc.austin.ibm.com) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #1 SMP Mon May 23 00:09:33 EDT 2011
Max number of cores passed to firmware: 4 (NR_CPUS = 8)
Calling ibm,client-architecture-support... done
command line: console=hvc0 autobench_args: root=/dev/sda5 ABAT:1306123860 
memory layout at init:
  memory_limit : 0000000000000000 (16 MB aligned)
  alloc_bottom : 0000000003b80000
  alloc_top    : 0000000010000000
  alloc_top_hi : 0000000010000000
  rmo_top      : 0000000010000000
  ram_top      : 0000000010000000
found display   : /pci@800000020000202/display@1, opening... done
instantiating rtas at 0x000000000f3e0000... done
boot cpu hw idx 0
starting cpu hw idx 2... done
starting cpu hw idx 4... done
starting cpu hw idx 6... done
copying OF device tree...
Building dt strings...
Building dt structure...
Device tree strings 0x0000000003b90000 -> 0x0000000003b917da
Device tree struct  0x0000000003ba0000 -> 0x0000000003bc0000
Calling quiesce...
returning from prom_init
[    0.000000] Using pSeries machine description
[    0.000000] Using 1TB segments
[    0.000000] Found initrd at 0xc000000003500000:0xc000000003b79400
[    0.000000] bootconsole [udbg0] enabled
[    0.000000] Partition configured for 8 cpus.
[    0.000000] CPU maps initialized for 2 threads per core
[    0.000000] Starting Linux PPC64 #1 SMP Mon May 23 00:09:33 EDT 2011
[    0.000000] -----------------------------------------------------
[    0.000000] ppc64_pft_size                = 0x1c
[    0.000000] physicalMemorySize            = 0x3d4000000
[    0.000000] htab_hash_mask                = 0x1fffff
[    0.000000] -----------------------------------------------------
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.39-rc6-autokern1 (root@vogons.ltc.austin.ibm.com) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #1 SMP Mon May 23 00:09:33 EDT 2011
[    0.000000] [boot]0012 Setup Arch
[    0.000000] PCI host bridge /pci@800000020000200  ranges:
[    0.000000]   IO 0x00003dffe01f0000..0x00003dffe01fffff -> 0x00000000000f0000
[    0.000000]  MEM 0x00003c0000000000..0x00003c007fffffff -> 0x0000000080000000 
[    0.000000] PCI host bridge /pci@800000020000201  ranges:
[    0.000000]   IO 0x00003dffe02f0000..0x00003dffe02fffff -> 0x00000000000f0000
[    0.000000]  MEM 0x00003c0080000000..0x00003c00ffffffff -> 0x0000000080000000 
[    0.000000] PCI host bridge /pci@800000020000202  ranges:
[    0.000000]   IO 0x00003dffe03f0000..0x00003dffe03fffff -> 0x00000000000f0000
[    0.000000]  MEM 0x00003c0100000000..0x00003c017fffffff -> 0x0000000080000000 
[    0.000000] EEH: PCI Enhanced I/O Error Handling Enabled
[    0.000000] PPC64 nvram contains 15360 bytes
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x0003d400
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0003d400
[    0.000000] [boot]0015 Setup Done
[    0.000000] PERCPU: Embedded 1 pages/cpu @c000000001a00000 s30336 r0 d35200 u131072
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 250665
[    0.000000] Policy zone: DMA
[    0.000000] Kernel command line: console=hvc0 autobench_args: root=/dev/sda5 ABAT:1306123860 
[    0.000000] PID hash table entries: 4096 (order: -1, 32768 bytes)
[    0.000000] freeing bootmem node 0
[    0.000000] Memory: 15947776k/16056320k available (20928k kernel code, 108544k reserved, 1792k data, 2626k bss, 6720k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU debugfs-based tracing is enabled.
[    0.000000]  CONFIG_RCU_FANOUT set to non-default value of 8
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:512
[    0.000000] [boot]0020 XICS Init
[    0.000000] [boot]0021 XICS Done
[    0.000000] clocksource: timebase mult[7d0000] shift[22] registered
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [hvc0] enabled, bootconsole disabled
[    0.000000] console [hvc0] enabled, bootconsole disabled
[    0.000000] allocated 8028160 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.003261] pid_max: default: 32768 minimum: 301
[    0.003388] Security Framework initialized
[    0.003397] SELinux:  Initializing.
[    0.003689] Dentry cache hash table entries: 2097152 (order: 8, 16777216 bytes)
[    0.008685] Inode-cache hash table entries: 1048576 (order: 7, 8388608 bytes)
[    0.011228] Mount-cache hash table entries: 4096
[    0.013381] Initializing cgroup subsys ns
[    0.013388] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.013395] Initializing cgroup subsys cpuacct
[    0.013411] Initializing cgroup subsys memory
[    0.013537] Initializing cgroup subsys devices
[    0.013542] Initializing cgroup subsys freezer
[    0.013546] Initializing cgroup subsys net_cls
[    0.013551] Initializing cgroup subsys blkio
[    0.013684] POWER6 performance monitor hardware support registered
[    0.020123] Brought up 8 CPUs
[    0.021265] devtmpfs: initialized
[    0.032354] print_constraints: dummy: 
[    0.032500] NET: Registered protocol family 16
[    0.032514] IBM eBus Device Driver
[    0.043433] PCI: Probing PCI hardware
[    0.074166] IOMMU table initialized, virtual merging enabled
[    0.157679] bio: create slab <bio-0> at 0
[    0.158128] vgaarb: device added: PCI:0002:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.158134] vgaarb: loaded
[    0.158404] SCSI subsystem initialized
[    0.158550] usbcore: registered new interface driver usbfs
[    0.158574] usbcore: registered new interface driver hub
[    0.158637] usbcore: registered new device driver usb
[    0.158758] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.158892] NetLabel: Initializing
[    0.158896] NetLabel:  domain hash size = 128
[    0.158899] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.158916] NetLabel:  unlabeled traffic allowed by default
[    0.158939] Switching to clocksource timebase
[    0.158999] Switched to NOHz mode on CPU #0
[    0.159244] Switched to NOHz mode on CPU #6
[    0.160122] Switched to NOHz mode on CPU #7
[    0.164467] NET: Registered protocol family 2
[    0.164620] IP route cache hash table entries: 524288 (order: 6, 4194304 bytes)
[    0.166027] TCP established hash table entries: 524288 (order: 7, 8388608 bytes)
[    0.168911] TCP bind hash table entries: 65536 (order: 4, 1048576 bytes)
[    0.169027] Switched to NOHz mode on CPU #1
[    0.169280] TCP: Hash tables configured (established 524288 bind 65536)
[    0.169286] TCP reno registered
[    0.169297] UDP hash table entries: 8192 (order: 2, 262144 bytes)
[    0.169388] UDP-Lite hash table entries: 8192 (order: 2, 262144 bytes)
[    0.169737] NET: Registered protocol family 1
[    0.170515] Trying to unpack rootfs image as initramfs...
[    0.185745] Switched to NOHz mode on CPU #2
[    0.186632] Switched to NOHz mode on CPU #3
[    0.187525] Switched to NOHz mode on CPU #4
[    0.188386] Switched to NOHz mode on CPU #5
[    0.329630] Freeing initrd memory: 6629k freed
[    0.330778] vio 30000000: Warning: IOMMU dma not supported: mask 0xffffffffffffffff, table unavailable
[    0.330805] vio 4000: Warning: IOMMU dma not supported: mask 0xffffffffffffffff, table unavailable
[    0.330838] vio 4001: Warning: IOMMU dma not supported: mask 0xffffffffffffffff, table unavailable
[    0.330862] vio 4002: Warning: IOMMU dma not supported: mask 0xffffffffffffffff, table unavailable
[    0.330887] vio 4004: Warning: IOMMU dma not supported: mask 0xffffffffffffffff, table unavailable
[    0.330911] vio 4003: Warning: IOMMU dma not supported: mask 0xffffffffffffffff, table unavailable
[    0.331081] Hypercall H_BEST_ENERGY not supported
[    0.331375] audit: initializing netlink socket (disabled)
[    0.331393] type=2000 audit(1306109616.240:1): initialized
[    0.463067] HugeTLB registered 16 MB page size, pre-allocated 0 pages
[    0.463076] HugeTLB registered 16 GB page size, pre-allocated 0 pages
[    0.463639] VFS: Disk quotas dquot_6.5.2
[    0.463732] Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
[    0.464062] msgmni has been set to 31160
[    0.464551] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.464559] io scheduler noop registered
[    0.464564] io scheduler deadline registered
[    0.464615] io scheduler cfq registered (default)
[    0.464716] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.464736] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.464742] rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
[    0.665251] radeonfb 0002:00:01.0: Invalid ROM contents
[    0.679003] radeonfb: No ATY,RefCLK property !
[    0.769002] xtal calculation failed: 26880
[    0.769009] radeonfb: Used default PLL infos
[    0.769015] radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=166.00 Mhz, System=166.00 MHz
[    0.769022] radeonfb: PLL min 12000 max 35000
[    0.869005] radeonfb: Monitor 1 type CRT found
[    0.869013] radeonfb: Monitor 2 type no found
[    1.464714] Console: switching to colour frame buffer device 80x30
[    1.500072] radeonfb (0002:00:01.0): ATI Radeon 515e "Q^"
[    1.500528] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.501512] Linux agpgart interface v0.103
[    1.501533] [drm] Initialized drm 1.1.0 20060810
[    1.501564] [drm] radeon defaulting to kernel modesetting.
[    1.501569] [drm] radeon kernel modesetting enabled.
[    1.503327] brd: module loaded
[    1.504180] loop: module loaded
[    1.504217] Loading iSCSI transport class v2.0-870.
[    1.504306] ipr: IBM Power RAID SCSI Device Driver version: 2.5.1 (August 10, 2010)
[    1.504486] ipr 0000:00:01.0: Found IOA with IRQ: 289
[    1.504629] ipr 0000:00:01.0: Using 32-bit DMA via iommu
[    1.508131] ipr 0000:00:01.0: Starting IOA initialization sequence.
[    1.508863] ipr 0000:00:01.0: Adapter firmware version: 0220004A
[    1.512230] ipr 0000:00:01.0: IOA initialized.
[    1.512246] scsi0 : IBM 572C Storage Adapter
[    1.551067] scsi 0:3:0:0: Direct-Access     IBM-ESXS ST9146802SS      B526 PQ: 0 ANSI: 5
[    1.625369] scsi 0:8:0:0: Enclosure         IBM      VSBPD1BB   SAS     01 PQ: 0 ANSI: 2
[    2.365360] scsi: unknown device type 31
[    2.365370] scsi 0:255:255:255: No Device         IBM      572C001SISIOA    0150 PQ: 0 ANSI: 0
[    2.365538] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
[    2.365546] libcxgbi:ddp_setup_host_page_size: system PAGE 65536, ddp idx 3.
[    2.365552] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[    2.365584] iscsi: registered transport (cxgb3i)
[    2.365590] Broadcom NetXtreme II iSCSI Driver bnx2i v2.6.2.3 (Dec 31, 2010)
[    2.365613] iscsi: registered transport (bnx2i)
[    2.366018] sd 0:3:0:0: Attached scsi generic sg0 type 0
[    2.366152] scsi 0:8:0:0: Attached scsi generic sg1 type 13
[    2.366286] scsi 0:255:255:255: Attached scsi generic sg2 type 31
[    2.368840] sd 0:3:0:0: [sda] 286748000 512-byte logical blocks: (146 GB/136 GiB)
[    2.371772] ses 0:8:0:0: Attached Enclosure device
[    2.371904] sd 0:3:0:0: [sda] Write Protect is off
[    2.372773] Fixed MDIO Bus: probed
[    2.372801] ehea: IBM eHEA ethernet device driver (Release EHEA_0107)
[    2.373650] sd 0:3:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[    2.428501]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
[    2.434859] sd 0:3:0:0: [sda] Attached SCSI disk
[    2.721794] ibmebus port0: eth0: Jumbo frames are enabled
[    2.721810] ibmebus port0: eth0: logical port id #1
[    2.722064] ibmebus port1: eth1: Jumbo frames are enabled
[    2.722070] ibmebus port1: eth1: logical port id #2
[    2.722119] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.2.13 (Jan 31, 2011)
[    2.722218] Solarflare NET driver v3.1
[    2.722377] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.722593] ehci_hcd 0001:00:01.2: enabling device (0140 -> 0142)
[    2.722855] ehci_hcd 0001:00:01.2: EHCI Host Controller
[    2.723110] ehci_hcd 0001:00:01.2: new USB bus registered, assigned bus number 1
[    2.859084] ehci_hcd 0001:00:01.2: irq 307, io mem 0x3c00ffffd000
[    2.879005] ehci_hcd 0001:00:01.2: USB 2.0 started, EHCI 1.00
[    2.879042] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.879049] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.879056] usb usb1: Product: EHCI Host Controller
[    2.879061] usb usb1: Manufacturer: Linux 2.6.39-rc6-autokern1 ehci_hcd
[    2.879068] usb usb1: SerialNumber: 0001:00:01.2
[    2.879206] hub 1-0:1.0: USB hub found
[    2.879214] hub 1-0:1.0: 5 ports detected
[    2.879317] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.879588] ohci_hcd 0001:00:01.0: OHCI Host Controller
[    2.879642] ohci_hcd 0001:00:01.0: new USB bus registered, assigned bus number 2
[    2.889109] ohci_hcd 0001:00:01.0: irq 305, io mem 0x3c00ffffe000
[    2.979039] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.979049] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.979055] usb usb2: Product: OHCI Host Controller
[    2.979061] usb usb2: Manufacturer: Linux 2.6.39-rc6-autokern1 ohci_hcd
[    2.979066] usb usb2: SerialNumber: 0001:00:01.0
[    2.979186] hub 2-0:1.0: USB hub found
[    2.979196] hub 2-0:1.0: 3 ports detected
[    2.979512] ohci_hcd 0001:00:01.1: OHCI Host Controller
[    2.979565] ohci_hcd 0001:00:01.1: new USB bus registered, assigned bus number 3
[    2.989098] ohci_hcd 0001:00:01.1: irq 306, io mem 0x3c00fffff000
[    3.079035] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.079045] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.079052] usb usb3: Product: OHCI Host Controller
[    3.079057] usb usb3: Manufacturer: Linux 2.6.39-rc6-autokern1 ohci_hcd
[    3.079064] usb usb3: SerialNumber: 0001:00:01.1
[    3.079195] hub 3-0:1.0: USB hub found
[    3.079205] hub 3-0:1.0: 2 ports detected
[    3.079290] uhci_hcd: USB Universal Host Controller Interface driver
[    3.079456] mousedev: PS/2 mouse device common for all mice
[    3.079668] rtc-generic rtc-generic: rtc core: registered rtc-generic as rtc0
[    3.079721] lirc_dev: IR Remote Control driver registered, major 249 
[    3.079727] IR NEC protocol handler initialized
[    3.079732] IR RC5(x) protocol handler initialized
[    3.079736] IR RC6 protocol handler initialized
[    3.079741] IR JVC protocol handler initialized
[    3.079746] IR Sony protocol handler initialized
[    3.079750] IR RC5 (streamzap) protocol handler initialized
[    3.079755] IR LIRC bridge handler initialized
[    3.079760] Linux video capture interface: v2.00
[    3.079780] i2c-core: driver [tuner] using legacy suspend method
[    3.079786] i2c-core: driver [tuner] using legacy resume method
[    3.079852] i2c-core: driver [msp3400] using legacy suspend method
[    3.079858] i2c-core: driver [msp3400] using legacy resume method
[    3.079940] bttv: driver version 0.9.18 loaded
[    3.079946] bttv: using 8 buffers with 2112k (33 pages) each for capture
[    3.079986] cx88/0: cx2388x v4l2 driver version 0.0.8 loaded
[    3.080016] ivtv: Start initialization, version 1.4.2
[    3.080038] ivtv: End initialization
[    3.080043] cx18:  Start initialization, version 1.4.0
[    3.080064] cx18:  End initialization
[    3.080070] cx23885 driver version 0.0.2 loaded
[    3.080093] au0828 driver loaded
[    3.080117] usbcore: registered new interface driver au0828
[    3.080122] saa7164 driver loaded
[    3.080165] bt878: AUDIO driver version 0.0.0 loaded
[    3.080334] device-mapper: uevent: version 1.0.3
[    3.080441] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    3.080805] usbcore: registered new interface driver usbhid
[    3.080811] usbhid: USB HID core driver
[    3.080871] ALSA device list:
[    3.080876]   No soundcards found.
[    3.080927] TCP cubic registered
[    3.081073] NET: Registered protocol family 10
[    3.084277] NET: Registered protocol family 17
[    3.086348] registered taskstats version 1
[    3.088974] rtc-generic rtc-generic: setting system clock to 2011-05-23 00:13:40 UTC (1306109620)
[    3.088988] Initializing network drop monitor service
[    3.090833] Freeing unused kernel memory: 6720k freed
[    3.109731] dracut: dracut-004-32.el6
[    3.125026] udev: starting version 147
[    3.125106] udevd (103): /proc/103/oom_adj is deprecated, please use /proc/103/oom_score_adj instead.
[    3.200846] dracut: Starting plymouth daemon
[    4.915583] EXT3-fs: barriers not enabled
[    4.920290] kjournald starting.  Commit interval 5 seconds
[    4.920589] EXT3-fs (sda5): mounted filesystem with ordered data mode
[    5.069390] dracut: Remounting /dev/sda5 with -o errors=remount-ro,ro
[    5.072976] EXT3-fs: barriers not enabled
[    5.073241] kjournald starting.  Commit interval 5 seconds
[    5.073538] EXT3-fs (sda5): mounted filesystem with ordered data mode
[    5.082228] dracut: Mounted root filesystem /dev/sda5
[    5.135981] dracut: Loading SELinux policy
[    5.345407] SELinux:  Disabled at runtime.
[    5.729055] type=1404 audit(1306109623.140:2): selinux=0 auid=4294967295 ses=4294967295
[    5.729314] dracut: /sbin/load_policy: Can't load policy: No such file or directory
[    6.096298] dracut: Switching root
[    6.892524] readahead: starting
[    7.329092] udev: starting version 147
[    7.449252] WARNING! power/level is deprecated; use power/control instead
[    8.854267] EXT3-fs (sda5): using internal journal
[    9.210822] Adding 4095936k swap on /dev/sda7.  Priority:-1 extents:1 across:4095936k 
[    9.963675] ibmebus port0: eth0: Physical port up
[    9.963688] ibmebus port0: eth0: External switch port is backup port
[   11.450988] ibmebus port1: eth1: Physical port up
[   11.451001] ibmebus port1: eth1: External switch port is backup port

Red Hat Enterprise Linux Server release 6.0 (Santiago)
Kernel 2.6.39-rc6-autokern1 on an ppc64

vogons.ltc.austin.ibm.com login: [   57.308347] rcu-torture:--- Start of test: nreaders=16 nfakewriters=4 stat_interval=30 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
[   62.840044] cpu 7 (hwid 7) Ready to die...
[   65.969954] cpu 1 (hwid 1) Ready to die...
[   69.099908] cpu 4 (hwid 4) Ready to die...
[   72.209933] cpu 2 (hwid 2) Ready to die...
[   75.239002] Switched to NOHz mode on CPU #2
[   78.719945] cpu 2 (hwid 2) Ready to die...
[   81.830108] cpu 3 (hwid 3) Ready to die...
[   84.859001] Switched to NOHz mode on CPU #6
[   87.309028] rcu-torture: rtc: d000000002b07c58 ver: 1339 tfle: 0 rta: 1339 rtaf: 107 rtf: 1338 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 22508
[   87.309031] rcu-torture: Reader Pipe:  57820449 276 0 0 0 0 0 0 0 0 0
[   87.309032] rcu-torture: Reader Batch:  57820497 236 0 0 0 0 0 0 0 0 0
[   87.309034] rcu-torture: Free-Block Circulation:  1338 1338 1338 1338 1338 1338 1338 1338 1338 1338 0
[   88.218997] Switched to NOHz mode on CPU #1
[   91.710244] cpu 6 (hwid 6) Ready to die...
[   94.809595] cpu 1 (hwid 1) Ready to die...
[   97.849004] Switched to NOHz mode on CPU #7
[  101.229000] Switched to NOHz mode on CPU #3
[  104.749768] cpu 5 (hwid 5) Ready to die...
[  107.778997] Switched to NOHz mode on CPU #1
[  111.218998] Switched to NOHz mode on CPU #5
[  114.749843] cpu 1 (hwid 1) Ready to die...
[  117.309040] rcu-torture: rtc: d000000002b08618 ver: 2692 tfle: 0 rta: 2692 rtaf: 195 rtf: 2691 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 45732
[  117.309043] rcu-torture: Reader Pipe:  99475710 468 0 0 0 0 0 0 0 0 0
[  117.309044] rcu-torture: Reader Batch:  99475855 374 0 0 0 0 0 0 0 0 0
[  117.309046] rcu-torture: Free-Block Circulation:  2691 2691 2691 2691 2691 2691 2691 2691 2691 2691 0
[  117.849778] cpu 0 (hwid 0) Ready to die...
[  120.888999] Switched to NOHz mode on CPU #1
[  124.299006] Switched to NOHz mode on CPU #2
[  127.709957] cpu 7 (hwid 7) Ready to die...
[  130.799924] cpu 5 (hwid 5) Ready to die...
[  133.829004] Switched to NOHz mode on CPU #7
[  137.239754] cpu 1 (hwid 1) Ready to die...
[  140.340108] cpu 7 (hwid 7) Ready to die...
[  143.419551] cpu 3 (hwid 3) Ready to die...
[  146.459002] Switched to NOHz mode on CPU #5
[  147.309031] rcu-torture: rtc: d000000002b07928 ver: 4033 tfle: 0 rta: 4033 rtaf: 326 rtf: 4032 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 69222
[  147.309033] rcu-torture: Reader Pipe:  131520986 597 0 0 0 0 0 0 0 0 0
[  147.309034] rcu-torture: Reader Batch:  131521161 498 0 0 0 0 0 0 0 0 0
[  147.309036] rcu-torture: Free-Block Circulation:  4032 4032 4032 4032 4032 4032 4032 4032 4032 4032 0
[  149.509005] Switched to NOHz mode on CPU #7
[  152.909630] cpu 5 (hwid 5) Ready to die...
[  155.999535] cpu 7 (hwid 7) Ready to die...
[  159.059000] Switched to NOHz mode on CPU #6
[  162.399003] Switched to NOHz mode on CPU #7
[  165.759002] Switched to NOHz mode on CPU #4
[  169.178999] Switched to NOHz mode on CPU #1
[  172.689824] cpu 4 (hwid 4) Ready to die...
[  175.719003] Switched to NOHz mode on CPU #5
[  177.309035] rcu-torture: rtc: d000000002b08378 ver: 5477 tfle: 0 rta: 5477 rtaf: 326 rtf: 5476 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 92739
[  177.309037] rcu-torture: Reader Pipe:  167861749 756 0 0 0 0 0 0 0 0 0
[  177.309039] rcu-torture: Reader Batch:  167861963 629 0 0 0 0 0 0 0 0 0
[  177.309040] rcu-torture: Free-Block Circulation:  5476 5476 5476 5476 5476 5476 5476 5476 5476 5476 0
[  179.199961] cpu 7 (hwid 7) Ready to die...
[  182.309899] cpu 5 (hwid 5) Ready to die...
[  185.419635] cpu 2 (hwid 2) Ready to die...
[  188.510514] cpu 6 (hwid 6) Ready to die...
[  191.578998] Switched to NOHz mode on CPU #2
[  194.919002] Switched to NOHz mode on CPU #5
[  198.279004] Switched to NOHz mode on CPU #7
[  201.679717] cpu 7 (hwid 7) Ready to die...
[  204.709003] Switched to NOHz mode on CPU #7
[  207.309028] rcu-torture: rtc: d000000002b07d78 ver: 6845 tfle: 0 rta: 6845 rtaf: 365 rtf: 6844 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 115995
[  207.309030] rcu-torture: Reader Pipe:  204020855 899 0 0 0 0 0 0 0 0 0
[  207.309032] rcu-torture: Reader Batch:  204021133 737 0 0 0 0 0 0 0 0 0
[  207.309033] rcu-torture: Free-Block Circulation:  6844 6844 6844 6844 6844 6844 6844 6844 6844 6844 0
[  208.129993] cpu 5 (hwid 5) Ready to die...
[  211.158995] Switched to NOHz mode on CPU #0
[  214.369765] cpu 1 (hwid 1) Ready to die...
[  217.399000] Switched to NOHz mode on CPU #6
[  220.749003] Switched to NOHz mode on CPU #5
[  224.249799] cpu 2 (hwid 2) Ready to die...
[  227.369723] cpu 0 (hwid 0) Ready to die...
[  230.399008] Switched to NOHz mode on CPU #1
[  233.849749] cpu 1 (hwid 1) Ready to die...
[  236.879001] Switched to NOHz mode on CPU #2
[  237.309023] rcu-torture: rtc: d000000002b078c8 ver: 8219 tfle: 0 rta: 8219 rtaf: 465 rtf: 8218 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 139180
[  237.309026] rcu-torture: Reader Pipe:  243079329 1068 0 0 0 0 0 0 0 0 0
[  237.309027] rcu-torture: Reader Batch:  243079691 847 0 0 0 0 0 0 0 0 0
[  237.309028] rcu-torture: Free-Block Circulation:  8218 8218 8218 8218 8218 8218 8218 8218 8218 8218 0
[  240.238999] Switched to NOHz mode on CPU #1
[  243.769811] cpu 2 (hwid 2) Ready to die...
[  246.879712] cpu 6 (hwid 6) Ready to die...
[  249.990137] cpu 7 (hwid 7) Ready to die...
[  253.019003] Switched to NOHz mode on CPU #0
[  256.439578] cpu 1 (hwid 1) Ready to die...
[  259.469001] Switched to NOHz mode on CPU #3
[  262.819006] Switched to NOHz mode on CPU #4
[  266.229679] cpu 4 (hwid 4) Ready to die...
[  267.309028] rcu-torture: rtc: d000000002b07958 ver: 9634 tfle: 0 rta: 9634 rtaf: 518 rtf: 9633 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 162647
[  267.309030] rcu-torture: Reader Pipe:  280679035 1221 0 0 0 0 0 0 0 0 0
[  267.309032] rcu-torture: Reader Batch:  280679461 978 0 0 0 0 0 0 0 0 0
[  267.309033] rcu-torture: Free-Block Circulation:  9633 9633 9633 9633 9633 9633 9633 9633 9633 9633 0
[  269.349753] cpu 5 (hwid 5) Ready to die...
[  272.379003] Switched to NOHz mode on CPU #4
[  275.729005] Switched to NOHz mode on CPU #1
[  279.199785] cpu 0 (hwid 0) Ready to die...
[  282.229000] Switched to NOHz mode on CPU #5
[  285.579005] Switched to NOHz mode on CPU #7
[  289.010033] cpu 1 (hwid 1) Ready to die...
[  292.130185] cpu 3 (hwid 3) Ready to die...
[  295.159004] Switched to NOHz mode on CPU #1
[  297.309035] rcu-torture: rtc: d000000002b08288 ver: 10971 tfle: 0 rta: 10971 rtaf: 640 rtf: 10970 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 185887
[  297.309037] rcu-torture: Reader Pipe:  317303546 1363 0 0 0 0 0 0 0 0 0
[  297.309038] rcu-torture: Reader Batch:  317304050 1056 0 0 0 0 0 0 0 0 0
[  297.309040] rcu-torture: Free-Block Circulation:  10970 10970 10970 10970 10970 10970 10970 10970 10970 10970 0
[  298.599848] cpu 7 (hwid 7) Ready to die...
[  301.711055] cpu 4 (hwid 4) Ready to die...
[  304.739003] Switched to NOHz mode on CPU #0
[  308.240254] cpu 5 (hwid 5) Ready to die...
[  311.278998] Switched to NOHz mode on CPU #3
[  314.629004] Switched to NOHz mode on CPU #5
[  318.069753] cpu 3 (hwid 3) Ready to die...
[  321.099002] Switched to NOHz mode on CPU #6
[  324.519730] cpu 6 (hwid 6) Ready to die...
[  327.309030] rcu-torture: rtc: d000000002b07718 ver: 12216 tfle: 0 rta: 12216 rtaf: 827 rtf: 12215 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 208961
[  327.309033] rcu-torture: Reader Pipe:  342130752 1442 0 0 0 0 0 0 0 0 0
[  327.309034] rcu-torture: Reader Batch:  342131299 1133 0 0 0 0 0 0 0 0 0
[  327.309036] rcu-torture: Free-Block Circulation:  12215 12215 12215 12215 12215 12215 12215 12215 12215 12215 0
[  327.619973] cpu 0 (hwid 0) Ready to die...
[  330.658998] Switched to NOHz mode on CPU #4
[  334.059635] cpu 1 (hwid 1) Ready to die...
[  337.089002] Switched to NOHz mode on CPU #1
[  340.449000] Switched to NOHz mode on CPU #7
[  343.789006] Switched to NOHz mode on CPU #6
[  347.129002] Switched to NOHz mode on CPU #0
[  350.580175] cpu 0 (hwid 0) Ready to die...
[  353.689868] cpu 6 (hwid 6) Ready to die...
[  356.809676] cpu 1 (hwid 1) Ready to die...
[  357.309030] rcu-torture: rtc: d000000002b08738 ver: 13597 tfle: 0 rta: 13597 rtaf: 904 rtf: 13596 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 232248
[  357.309033] rcu-torture: Reader Pipe:  385077127 1595 0 0 0 0 0 0 0 0 0
[  357.309034] rcu-torture: Reader Batch:  385077683 1305 0 0 0 0 0 0 0 0 0
[  357.309035] rcu-torture: Free-Block Circulation:  13596 13596 13596 13596 13596 13596 13596 13596 13596 13596 0
[  359.910136] cpu 4 (hwid 4) Ready to die...
[  362.939003] Switched to NOHz mode on CPU #0
[  366.299007] Switched to NOHz mode on CPU #2
[  369.709002] Switched to NOHz mode on CPU #1
[  373.069005] Switched to NOHz mode on CPU #6
[  376.659990] cpu 0 (hwid 0) Ready to die...
[  379.780047] cpu 7 (hwid 7) Ready to die...
[  382.809004] Switched to NOHz mode on CPU #7
[  386.159004] Switched to NOHz mode on CPU #0
[  387.309021] rcu-torture: rtc: d000000002b08108 ver: 14862 tfle: 0 rta: 14862 rtaf: 1075 rtf: 14861 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 255431
[  387.309023] rcu-torture: Reader Pipe:  427667186 1735 0 0 0 0 0 0 0 0 0
[  387.309025] rcu-torture: Reader Batch:  427667732 1458 0 0 0 0 0 0 0 0 0
[  387.309026] rcu-torture: Free-Block Circulation:  14861 14861 14861 14861 14861 14861 14861 14861 14861 14861 0
[  389.590417] cpu 6 (hwid 6) Ready to die...
[  392.869847] cpu 2 (hwid 2) Ready to die...
[  395.899005] Switched to NOHz mode on CPU #4
[  399.359863] cpu 0 (hwid 0) Ready to die...
[  402.389005] Switched to NOHz mode on CPU #3
[  405.919891] cpu 5 (hwid 5) Ready to die...
[  408.948999] Switched to NOHz mode on CPU #6
[  412.409831] cpu 6 (hwid 6) Ready to die...
[  415.539770] cpu 1 (hwid 1) Ready to die...
[  417.309029] rcu-torture: rtc: d000000002b07b98 ver: 16235 tfle: 0 rta: 16235 rtaf: 1173 rtf: 16234 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 278878
[  417.309031] rcu-torture: Reader Pipe:  482365168 1945 0 0 0 0 0 0 0 0 0
[  417.309033] rcu-torture: Reader Batch:  482365703 1704 0 0 0 0 0 0 0 0 0
[  417.309034] rcu-torture: Free-Block Circulation:  16234 16234 16234 16234 16234 16234 16234 16234 16234 16234 0
[  418.569001] Switched to NOHz mode on CPU #2
[  422.010132] cpu 7 (hwid 7) Ready to die...
[  425.099654] cpu 4 (hwid 4) Ready to die...
[  428.139001] Switched to NOHz mode on CPU #6
[  431.508998] Switched to NOHz mode on CPU #1
[  434.929765] cpu 3 (hwid 3) Ready to die...
[  438.029881] cpu 6 (hwid 6) Ready to die...
[  441.149489] cpu 2 (hwid 2) Ready to die...
[  444.189001] Switched to NOHz mode on CPU #3
[  447.239002] Switched to NOHz mode on CPU #2
[  447.309032] rcu-torture: rtc: d000000002b07898 ver: 17541 tfle: 0 rta: 17541 rtaf: 1281 rtf: 17540 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 302172
[  447.309035] rcu-torture: Reader Pipe:  510233529 2039 0 0 0 0 0 0 0 0 0
[  447.309037] rcu-torture: Reader Batch:  510234137 1769 0 0 0 0 0 0 0 0 0
[  447.309038] rcu-torture: Free-Block Circulation:  17540 17540 17540 17540 17540 17540 17540 17540 17540 17540 0
[  450.589000] Switched to NOHz mode on CPU #6
[  454.009715] cpu 2 (hwid 2) Ready to die...
[  457.109603] cpu 6 (hwid 6) Ready to die...
[  460.220150] cpu 1 (hwid 1) Ready to die...
[  463.259001] Switched to NOHz mode on CPU #1
[  466.309001] Switched to NOHz mode on CPU #4
[  469.648999] Switched to NOHz mode on CPU #5
[  473.079697] cpu 4 (hwid 4) Ready to die...
[  476.179633] cpu 1 (hwid 1) Ready to die...
[  477.309037] rcu-torture: rtc: d000000002b08348 ver: 18971 tfle: 0 rta: 18971 rtaf: 1322 rtf: 18970 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 325896
[  477.309040] rcu-torture: Reader Pipe:  541015434 2137 0 0 0 0 0 0 0 0 0
[  477.309041] rcu-torture: Reader Batch:  541016074 1857 0 0 0 0 0 0 0 0 0
[  477.309043] rcu-torture: Free-Block Circulation:  18970 18970 18970 18970 18970 18970 18970 18970 18970 18970 0
[  479.218996] Switched to NOHz mode on CPU #2
[  482.579002] Switched to NOHz mode on CPU #4
[  486.079718] cpu 2 (hwid 2) Ready to die...
[  489.109004] Switched to NOHz mode on CPU #7
[  492.459000] Switched to NOHz mode on CPU #1
[  495.869007] Switched to NOHz mode on CPU #2
[  499.410306] cpu 4 (hwid 4) Ready to die...
[  502.539862] cpu 5 (hwid 5) Ready to die...
[  505.569003] Switched to NOHz mode on CPU #6
[  507.309034] rcu-torture: rtc: d000000002b08228 ver: 20365 tfle: 0 rta: 20365 rtaf: 1408 rtf: 20364 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 349493
[  507.309037] rcu-torture: Reader Pipe:  584666871 2320 0 0 0 0 0 0 0 0 0
[  507.309038] rcu-torture: Reader Batch:  584667596 1989 0 0 0 0 0 0 0 0 0
[  507.309039] rcu-torture: Free-Block Circulation:  20364 20364 20364 20364 20364 20364 20364 20364 20364 20364 0
[  509.059867] cpu 2 (hwid 2) Ready to die...
[  512.089001] Switched to NOHz mode on CPU #5
[  515.609877] cpu 7 (hwid 7) Ready to die...
[  518.639000] Switched to NOHz mode on CPU #0
[  521.989000] Switched to NOHz mode on CPU #7
[  525.679978] cpu 0 (hwid 0) Ready to die...
[  528.799901] cpu 3 (hwid 3) Ready to die...
[  531.828999] Switched to NOHz mode on CPU #4
[  535.299830] cpu 6 (hwid 6) Ready to die...
[  537.309029] rcu-torture: rtc: d000000002b08288 ver: 21670 tfle: 0 rta: 21670 rtaf: 1549 rtf: 21669 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 372686
[  537.309031] rcu-torture: Reader Pipe:  630754044 2509 0 0 0 0 0 0 0 0 0
[  537.309033] rcu-torture: Reader Batch:  630754852 2126 0 0 0 0 0 0 0 0 0
[  537.309034] rcu-torture: Free-Block Circulation:  21669 21669 21669 21669 21669 21669 21669 21669 21669 21669 0
[  538.449755] cpu 5 (hwid 5) Ready to die...
[  541.479005] Switched to NOHz mode on CPU #2
[  545.099797] cpu 1 (hwid 1) Ready to die...
[  548.199786] cpu 4 (hwid 4) Ready to die...
[  551.239001] Switched to NOHz mode on CPU #1
[  554.669001] Switched to NOHz mode on CPU #4
[  558.100519] cpu 1 (hwid 1) Ready to die...
[  561.129002] Switched to NOHz mode on CPU #1
[  564.439007] Switched to NOHz mode on CPU #6
[  567.309035] rcu-torture: rtc: d000000002b086d8 ver: 23095 tfle: 0 rta: 23095 rtaf: 1561 rtf: 23094 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 395967
[  567.309038] rcu-torture: Reader Pipe:  666570812 2664 0 0 0 0 0 0 0 0 0
[  567.309040] rcu-torture: Reader Batch:  666571679 2230 0 0 0 0 0 0 0 0 0
[  567.309041] rcu-torture: Free-Block Circulation:  23094 23094 23094 23094 23094 23094 23094 23094 23094 23094 0
[  567.840052] cpu 2 (hwid 2) Ready to die...
[  570.868998] Switched to NOHz mode on CPU #2
[  574.379835] cpu 6 (hwid 6) Ready to die...
[  577.480272] cpu 7 (hwid 7) Ready to die...
[  580.610357] cpu 1 (hwid 1) Ready to die...
[  583.659002] Switched to NOHz mode on CPU #7
[  587.049635] cpu 4 (hwid 4) Ready to die...
[  590.129551] cpu 2 (hwid 2) Ready to die...
[  593.169001] Switched to NOHz mode on CPU #6
[  596.219001] Switched to NOHz mode on CPU #2
[  597.309031] rcu-torture: rtc: d000000002b081f8 ver: 24468 tfle: 0 rta: 24468 rtaf: 1624 rtf: 24467 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 419247
[  597.309034] rcu-torture: Reader Pipe:  696464023 2759 0 0 0 0 0 0 0 0 0
[  597.309035] rcu-torture: Reader Batch:  696464935 2339 0 0 0 0 0 0 0 0 0
[  597.309036] rcu-torture: Free-Block Circulation:  24467 24467 24467 24467 24467 24467 24467 24467 24467 24467 0
[  599.649703] cpu 6 (hwid 6) Ready to die...
[  602.679005] Switched to NOHz mode on CPU #3
[  606.099614] cpu 3 (hwid 3) Ready to die...
[  609.129001] Switched to NOHz mode on CPU #4
[  612.479003] Switched to NOHz mode on CPU #1
[  615.899695] cpu 2 (hwid 2) Ready to die...
[  618.928997] Switched to NOHz mode on CPU #2
[  622.349010] Switched to NOHz mode on CPU #6
[  625.879836] cpu 6 (hwid 6) Ready to die...
[  627.309023] rcu-torture: rtc: d000000002b07538 ver: 25802 tfle: 0 rta: 25802 rtaf: 1755 rtf: 25801 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 442689
[  627.309025] rcu-torture: Reader Pipe:  727706425 2869 0 0 0 0 0 0 0 0 0
[  627.309027] rcu-torture: Reader Batch:  727707412 2425 0 0 0 0 0 0 0 0 0
[  627.309028] rcu-torture: Free-Block Circulation:  25801 25801 25801 25801 25801 25801 25801 25801 25801 25801 0
[  628.908997] Switched to NOHz mode on CPU #0
[  632.339812] cpu 4 (hwid 4) Ready to die...
[  635.369003] Switched to NOHz mode on CPU #6
[  638.729007] Switched to NOHz mode on CPU #5
[  642.088999] Switched to NOHz mode on CPU #4
[  645.650036] cpu 5 (hwid 5) Ready to die...
[  648.679000] Switched to NOHz mode on CPU #3
[  652.160172] cpu 2 (hwid 2) Ready to die...
[  655.319933] cpu 6 (hwid 6) Ready to die...
[  657.309019] rcu-torture: rtc: d000000002b08318 ver: 27170 tfle: 0 rta: 27170 rtaf: 1838 rtf: 27169 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 466080
[  657.309022] rcu-torture: Reader Pipe:  793342101 3161 0 0 0 0 0 0 0 0 0
[  657.309023] rcu-torture: Reader Batch:  793343120 2718 0 0 0 0 0 0 0 0 0
[  657.309024] rcu-torture: Free-Block Circulation:  27169 27169 27169 27169 27169 27169 27169 27169 27169 27169 0
[  658.439917] cpu 7 (hwid 7) Ready to die...
[  661.561098] cpu 3 (hwid 3) Ready to die...
[  664.589005] Switched to NOHz mode on CPU #6
[  668.029000] Switched to NOHz mode on CPU #3
[  671.450205] cpu 0 (hwid 0) Ready to die...
[  674.479007] Switched to NOHz mode on CPU #5
[  677.940774] cpu 4 (hwid 4) Ready to die...
[  680.969001] Switched to NOHz mode on CPU #7
[  684.549816] cpu 5 (hwid 5) Ready to die...
[  687.309027] rcu-torture: rtc: d000000002b08558 ver: 28593 tfle: 0 rta: 28593 rtaf: 1878 rtf: 28592 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 489425
[  687.309029] rcu-torture: Reader Pipe:  843852580 3389 0 0 0 0 0 0 0 0 0
[  687.309031] rcu-torture: Reader Batch:  843853648 2924 0 0 0 0 0 0 0 0 0
[  687.309032] rcu-torture: Free-Block Circulation:  28592 28592 28592 28592 28592 28592 28592 28592 28592 28592 0
[  687.599001] Switched to NOHz mode on CPU #5
[  690.958998] Switched to NOHz mode on CPU #4
[  694.560023] cpu 1 (hwid 1) Ready to die...
[  697.719866] cpu 5 (hwid 5) Ready to die...
[  700.749000] Switched to NOHz mode on CPU #0
[  704.169835] cpu 6 (hwid 6) Ready to die...
[  707.199002] Switched to NOHz mode on CPU #1
[  710.699826] cpu 4 (hwid 4) Ready to die...
[  713.729005] Switched to NOHz mode on CPU #6
[  717.089004] Switched to NOHz mode on CPU #4
[  717.309024] rcu-torture: rtc: d000000002b07538 ver: 29896 tfle: 0 rta: 29896 rtaf: 2020 rtf: 29895 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 512297
[  717.309027] rcu-torture: Reader Pipe:  894409233 3591 0 0 0 0 0 0 0 0 0
[  717.309028] rcu-torture: Reader Batch:  894410295 3168 0 0 0 0 0 0 0 0 0
[  717.309030] rcu-torture: Free-Block Circulation:  29895 29895 29895 29895 29895 29895 29895 29895 29895 29895 0
[  720.530062] cpu 6 (hwid 6) Ready to die...
[  723.649923] cpu 3 (hwid 3) Ready to die...
[  726.679004] Switched to NOHz mode on CPU #6
[  730.160738] cpu 4 (hwid 4) Ready to die...
[  733.259696] cpu 6 (hwid 6) Ready to die...
[  736.289002] Switched to NOHz mode on CPU #4
[  739.770004] cpu 4 (hwid 4) Ready to die...
[  742.799002] Switched to NOHz mode on CPU #3
[  746.149006] Switched to NOHz mode on CPU #2
[  747.309027] rcu-torture: rtc: d000000002b08318 ver: 31173 tfle: 0 rta: 31173 rtaf: 2192 rtf: 31172 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 535439
[  747.309030] rcu-torture: Reader Pipe:  944813051 3772 0 0 0 0 0 0 0 0 0
[  747.309031] rcu-torture: Reader Batch:  944814136 3358 0 0 0 0 0 0 0 0 0
[  747.309033] rcu-torture: Free-Block Circulation:  31172 31172 31172 31172 31172 31172 31172 31172 31172 31172 0
[  749.508997] Switched to NOHz mode on CPU #6
[  752.950016] cpu 0 (hwid 0) Ready to die...
[  756.079819] cpu 2 (hwid 2) Ready to die...
[  759.109003] Switched to NOHz mode on CPU #4
[  762.529006] Switched to NOHz mode on CPU #0
[  766.059903] cpu 3 (hwid 3) Ready to die...
[  769.088998] Switched to NOHz mode on CPU #3
[  772.559929] cpu 0 (hwid 0) Ready to die...
[  775.679836] cpu 7 (hwid 7) Ready to die...
[  777.309022] rcu-torture: rtc: d000000002b07bf8 ver: 32345 tfle: 0 rta: 32345 rtaf: 2493 rtf: 32344 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 558730
[  777.309025] rcu-torture: Reader Pipe:  994426665 3953 0 0 0 0 0 0 0 0 0
[  777.309026] rcu-torture: Reader Batch:  994427719 3609 0 0 0 0 0 0 0 0 0
[  777.309028] rcu-torture: Free-Block Circulation:  32344 32344 32344 32344 32344 32344 32344 32344 32344 32344 0
[  778.799712] cpu 6 (hwid 6) Ready to die...
[  781.829001] Switched to NOHz mode on CPU #7
[  785.179006] Switched to NOHz mode on CPU #2
[  788.599005] Switched to NOHz mode on CPU #0
[  792.120068] cpu 1 (hwid 1) Ready to die...
[  795.149008] Switched to NOHz mode on CPU #5
[  798.610316] cpu 5 (hwid 5) Ready to die...
[  801.739934] cpu 0 (hwid 0) Ready to die...
[  804.769003] Switched to NOHz mode on CPU #5
[  807.309028] rcu-torture: rtc: d000000002b08468 ver: 33489 tfle: 0 rta: 33489 rtaf: 2739 rtf: 33488 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 580911
[  807.309030] rcu-torture: Reader Pipe:  1040624638 4102 0 0 0 0 0 0 0 0 0
[  807.309032] rcu-torture: Reader Batch:  1040625661 3777 0 0 0 0 0 0 0 0 0
[  807.309034] rcu-torture: Free-Block Circulation:  33488 33488 33488 33488 33488 33488 33488 33488 33488 33488 0
[  808.310290] cpu 5 (hwid 5) Ready to die...
[  811.470945] cpu 7 (hwid 7) Ready to die...
[  814.569621] cpu 3 (hwid 3) Ready to die...
[  817.599003] Switched to NOHz mode on CPU #6
[  821.040106] cpu 4 (hwid 4) Ready to die...
[  824.129530] cpu 6 (hwid 6) Ready to die...
[  833.199001] Switched to NOHz mode on CPU #6
[  836.309535] cpu 6 (hwid 6) Ready to die...
[  837.309027] rcu-torture: rtc: d000000002b07ce8 ver: 34862 tfle: 0 rta: 34862 rtaf: 2795 rtf: 34861 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 604269
[  837.309029] rcu-torture: Reader Pipe:  1067776459 4202 0 0 0 0 0 0 0 0 0
[  837.309030] rcu-torture: Reader Batch:  1067777527 3839 0 0 0 0 0 0 0 0 0
[  837.309032] rcu-torture: Free-Block Circulation:  34861 34861 34861 34861 34861 34861 34861 34861 34861 34861 0
[  839.378993] Switched to NOHz mode on CPU #3
[  842.719003] Switched to NOHz mode on CPU #1
[  846.069003] Switched to NOHz mode on CPU #5
[  849.418999] Switched to NOHz mode on CPU #6
[  852.959872] cpu 2 (hwid 2) Ready to die...
[  855.989006] Switched to NOHz mode on CPU #4
[  859.539885] cpu 5 (hwid 5) Ready to die...
[  862.569007] Switched to NOHz mode on CPU #7
[  866.119836] cpu 7 (hwid 7) Ready to die...
[  867.309034] rcu-torture: rtc: d000000002b07da8 ver: 36221 tfle: 0 rta: 36221 rtaf: 2863 rtf: 36220 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 627435
[  867.309037] rcu-torture: Reader Pipe:  1106674713 4355 0 0 0 0 0 0 0 0 0
[  867.309038] rcu-torture: Reader Batch:  1106675808 4009 0 0 0 0 0 0 0 0 0
[  867.309040] rcu-torture: Free-Block Circulation:  36220 36220 36220 36220 36220 36220 36220 36220 36220 36220 0
[  869.260001] cpu 1 (hwid 1) Ready to die...
[  872.288999] Switched to NOHz mode on CPU #5
[  875.699752] cpu 6 (hwid 6) Ready to die...
[  878.738995] Switched to NOHz mode on CPU #2
[  882.079005] Switched to NOHz mode on CPU #7
[  885.519835] cpu 4 (hwid 4) Ready to die...
[  888.620588] cpu 7 (hwid 7) Ready to die...
[  891.709002] Switched to NOHz mode on CPU #6
[  895.109750] cpu 5 (hwid 5) Ready to die...
[  897.309028] rcu-torture: rtc: d000000002b07e98 ver: 37557 tfle: 0 rta: 37557 rtaf: 2973 rtf: 37556 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 650766
[  897.309031] rcu-torture: Reader Pipe:  1144454313 4496 0 0 0 0 0 0 0 0 0
[  897.309033] rcu-torture: Reader Batch:  1144455536 4095 0 0 0 0 0 0 0 0 0
[  897.309034] rcu-torture: Free-Block Circulation:  37556 37556 37556 37556 37556 37556 37556 37556 37556 37556 0
[  898.220080] cpu 6 (hwid 6) Ready to die...
[  901.258995] Switched to NOHz mode on CPU #6
[  904.669609] cpu 2 (hwid 2) Ready to die...
[  907.699002] Switched to NOHz mode on CPU #0
[  911.058999] Switched to NOHz mode on CPU #4
[  914.449734] cpu 4 (hwid 4) Ready to die...
[  917.489001] Switched to NOHz mode on CPU #4
[  920.838998] Switched to NOHz mode on CPU #7
[  924.439845] cpu 4 (hwid 4) Ready to die...
[  927.309032] rcu-torture: rtc: d000000002b07598 ver: 39017 tfle: 0 rta: 39017 rtaf: 2973 rtf: 39016 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 674310
[  927.309034] rcu-torture: Reader Pipe:  1183799858 4643 0 0 0 0 0 0 0 0 0
[  927.309036] rcu-torture: Reader Batch:  1183801142 4225 0 0 0 0 0 0 0 0 0
[  927.309037] rcu-torture: Free-Block Circulation:  39016 39016 39016 39016 39016 39016 39016 39016 39016 39016 0
[  927.619737] cpu 6 (hwid 6) Ready to die...
[  930.719573] cpu 7 (hwid 7) Ready to die...
[  933.749003] Switched to NOHz mode on CPU #6
[  937.179571] cpu 6 (hwid 6) Ready to die...
[  940.208998] Switched to NOHz mode on CPU #2
[  943.579001] Switched to NOHz mode on CPU #6
[  946.919007] Switched to NOHz mode on CPU #1
[  950.269002] Switched to NOHz mode on CPU #4
[  953.749961] cpu 0 (hwid 0) Ready to die...
[  956.779006] Switched to NOHz mode on CPU #5
[  957.309025] rcu-torture: rtc: d000000002b07b38 ver: 40198 tfle: 0 rta: 40198 rtaf: 3250 rtf: 40197 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 697556
[  957.309028] rcu-torture: Reader Pipe:  1217872657 4754 0 0 0 0 0 0 0 0 0
[  957.309030] rcu-torture: Reader Batch:  1217873965 4341 0 0 0 0 0 0 0 0 0
[  957.309031] rcu-torture: Free-Block Circulation:  40197 40197 40197 40197 40197 40197 40197 40197 40197 40197 0
[  960.209004] Switched to NOHz mode on CPU #7
[  963.840061] cpu 1 (hwid 1) Ready to die...
[  966.869001] Switched to NOHz mode on CPU #0
[  970.310245] cpu 6 (hwid 6) Ready to die...
[  973.459939] cpu 2 (hwid 2) Ready to die...
[  976.569845] cpu 3 (hwid 3) Ready to die...
[  979.680271] cpu 0 (hwid 0) Ready to die...
[  982.779706] cpu 4 (hwid 4) Ready to die...
[  985.809002] Switched to NOHz mode on CPU #6
[  987.309024] rcu-torture: rtc: d000000002b07898 ver: 41351 tfle: 0 rta: 41351 rtaf: 3438 rtf: 41350 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 719350
[  987.309026] rcu-torture: Reader Pipe:  1271744824 4972 0 0 0 0 0 0 0 0 0
[  987.309028] rcu-torture: Reader Batch:  1271746112 4611 0 0 0 0 0 0 0 0 0
[  987.309029] rcu-torture: Free-Block Circulation:  41350 41350 41350 41350 41350 41350 41350 41350 41350 41350 0
[  989.169002] Switched to NOHz mode on CPU #0
[  992.519002] Switched to NOHz mode on CPU #3
[  995.849008] Switched to NOHz mode on CPU #2
[  999.699914] cpu 0 (hwid 0) Ready to die...
[ 1002.989831] cpu 3 (hwid 3) Ready to die...
[ 1006.099726] cpu 6 (hwid 6) Ready to die...
[ 1009.128997] Switched to NOHz mode on CPU #4
[ 1012.569767] cpu 7 (hwid 7) Ready to die...
[ 1015.599003] Switched to NOHz mode on CPU #7
[ 1017.309024] rcu-torture: rtc: d000000002b07568 ver: 42692 tfle: 0 rta: 42692 rtaf: 3561 rtf: 42691 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 742625
[ 1017.309026] rcu-torture: Reader Pipe:  1319106169 5144 0 0 0 0 0 0 0 0 0
[ 1017.309028] rcu-torture: Reader Batch:  1319107478 4774 0 0 0 0 0 0 0 0 0
[ 1017.309029] rcu-torture: Free-Block Circulation:  42691 42691 42691 42691 42691 42691 42691 42691 42691 42691 0
[ 1019.050343] cpu 4 (hwid 4) Ready to die...
[ 1022.210194] cpu 7 (hwid 7) Ready to die...
[ 1025.239003] Switched to NOHz mode on CPU #3
[ 1028.639581] cpu 3 (hwid 3) Ready to die...
[ 1031.669002] Switched to NOHz mode on CPU #3
[ 1035.018995] Switched to NOHz mode on CPU #6
[ 1038.368997] Switched to NOHz mode on CPU #7
[ 1041.790002] cpu 2 (hwid 2) Ready to die...
[ 1044.909713] cpu 3 (hwid 3) Ready to die...
[ 1047.309031] rcu-torture: rtc: d000000002b08348 ver: 43973 tfle: 0 rta: 43973 rtaf: 3731 rtf: 43972 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 766181
[ 1047.309033] rcu-torture: Reader Pipe:  1352432576 5235 0 0 0 0 0 0 0 0 0
[ 1047.309035] rcu-torture: Reader Batch:  1352433893 4890 0 0 0 0 0 0 0 0 0
[ 1047.309036] rcu-torture: Free-Block Circulation:  43972 43972 43972 43972 43972 43972 43972 43972 43972 43972 0
[ 1047.949003] Switched to NOHz mode on CPU #3
[ 1051.490702] cpu 6 (hwid 6) Ready to die...
[ 1054.519004] Switched to NOHz mode on CPU #2
[ 1058.039695] cpu 2 (hwid 2) Ready to die...
[ 1061.068997] Switched to NOHz mode on CPU #2
[ 1064.489685] cpu 2 (hwid 2) Ready to die...
[ 1067.610080] cpu 5 (hwid 5) Ready to die...
[ 1070.648999] Switched to NOHz mode on CPU #5
[ 1074.129669] cpu 3 (hwid 3) Ready to die...
[ 1077.159001] Switched to NOHz mode on CPU #3
[ 1077.309030] rcu-torture: rtc: d000000002b078c8 ver: 45443 tfle: 0 rta: 45443 rtaf: 3731 rtf: 45442 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 789548
[ 1077.309033] rcu-torture: Reader Pipe:  1389751161 5367 0 0 0 0 0 0 0 0 0
[ 1077.309034] rcu-torture: Reader Batch:  1389752516 4993 0 0 0 0 0 0 0 0 0
[ 1077.309036] rcu-torture: Free-Block Circulation:  45442 45442 45442 45442 45442 45442 45442 45442 45442 45442 0
[ 1080.539004] Switched to NOHz mode on CPU #1
[ 1084.049819] cpu 5 (hwid 5) Ready to die...
[ 1087.079004] Switched to NOHz mode on CPU #2
[ 1090.439000] Switched to NOHz mode on CPU #5
[ 1093.789010] Switched to NOHz mode on CPU #4
[ 1097.400727] cpu 4 (hwid 4) Ready to die...
[ 1100.519820] cpu 3 (hwid 3) Ready to die...
[ 1103.549005] Switched to NOHz mode on CPU #0
[ 1106.969003] Switched to NOHz mode on CPU #3
[ 1107.309027] rcu-torture: rtc: d000000002b08018 ver: 46783 tfle: 0 rta: 46783 rtaf: 3842 rtf: 46782 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 812800
[ 1107.309030] rcu-torture: Reader Pipe:  1436860431 5541 0 0 0 0 0 0 0 0 0
[ 1107.309031] rcu-torture: Reader Batch:  1436861819 5148 0 0 0 0 0 0 0 0 0
[ 1107.309033] rcu-torture: Free-Block Circulation:  46782 46782 46782 46782 46782 46782 46782 46782 46782 46782 0
[ 1110.500218] cpu 0 (hwid 0) Ready to die...
[ 1113.629808] cpu 5 (hwid 5) Ready to die...
[ 1116.739677] cpu 7 (hwid 7) Ready to die...
[ 1119.769004] Switched to NOHz mode on CPU #6
[ 1123.199778] cpu 1 (hwid 1) Ready to die...
[ 1126.319602] cpu 6 (hwid 6) Ready to die...
[ 1129.359001] Switched to NOHz mode on CPU #4
[ 1132.709001] Switched to NOHz mode on CPU #6
[ 1136.129002] Switched to NOHz mode on CPU #0
[ 1137.309028] rcu-torture: rtc: d000000002b07b98 ver: 48052 tfle: 0 rta: 48052 rtaf: 4020 rtf: 48051 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 836334
[ 1137.309030] rcu-torture: Reader Pipe:  1478456758 5700 0 0 0 0 0 0 0 0 0
[ 1137.309032] rcu-torture: Reader Batch:  1478458162 5314 0 0 0 0 0 0 0 0 0
[ 1137.309034] rcu-torture: Free-Block Circulation:  48051 48051 48051 48051 48051 48051 48051 48051 48051 48051 0
[ 1139.640536] cpu 0 (hwid 0) Ready to die...
[ 1142.739808] cpu 2 (hwid 2) Ready to die...
[ 1145.769000] Switched to NOHz mode on CPU #0
[ 1149.270555] cpu 3 (hwid 3) Ready to die...
[ 1152.369626] cpu 6 (hwid 6) Ready to die...
[ 1155.399000] Switched to NOHz mode on CPU #2
[ 1158.899571] cpu 4 (hwid 4) Ready to die...
[ 1161.929001] Switched to NOHz mode on CPU #6
[ 1165.279001] Switched to NOHz mode on CPU #4
[ 1167.309027] rcu-torture: rtc: d000000002b085e8 ver: 49374 tfle: 0 rta: 49374 rtaf: 4138 rtf: 49373 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 859363
[ 1167.309030] rcu-torture: Reader Pipe:  1515282107 5897 0 0 0 0 0 0 0 0 0
[ 1167.309032] rcu-torture: Reader Batch:  1515283536 5500 0 0 0 0 0 0 0 0 0
[ 1167.309033] rcu-torture: Free-Block Circulation:  49373 49373 49373 49373 49373 49373 49373 49373 49373 49373 0
[ 1168.708998] Switched to NOHz mode on CPU #7
[ 1172.148999] Switched to NOHz mode on CPU #3
[ 1175.479005] Switched to NOHz mode on CPU #1
[ 1178.980028] cpu 2 (hwid 2) Ready to die...
[ 1182.099964] cpu 1 (hwid 1) Ready to die...
[ 1185.129004] Switched to NOHz mode on CPU #1
[ 1188.560076] cpu 4 (hwid 4) Ready to die...
[ 1191.729902] cpu 6 (hwid 6) Ready to die...
[ 1194.839719] cpu 3 (hwid 3) Ready to die...
[ 1197.309019] rcu-torture: rtc: d000000002b07bc8 ver: 50600 tfle: 0 rta: 50600 rtaf: 4340 rtf: 50599 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 882296
[ 1197.309022] rcu-torture: Reader Pipe:  1572568082 6118 0 0 0 0 0 0 0 0 0
[ 1197.309023] rcu-torture: Reader Batch:  1572569513 5756 0 0 0 0 0 0 0 0 0
[ 1197.309024] rcu-torture: Free-Block Circulation:  50599 50599 50599 50599 50599 50599 50599 50599 50599 50599 0
[ 1197.960142] cpu 1 (hwid 1) Ready to die...
[ 1200.998998] Switched to NOHz mode on CPU #3
[ 1204.379004] Switched to NOHz mode on CPU #6
[ 1207.809788] cpu 7 (hwid 7) Ready to die...
[ 1210.839001] Switched to NOHz mode on CPU #5
[ 1214.339820] cpu 0 (hwid 0) Ready to die...
[ 1217.368997] Switched to NOHz mode on CPU #2
[ 1220.729001] Switched to NOHz mode on CPU #1
[ 1224.149839] cpu 6 (hwid 6) Ready to die...
[ 1227.269673] cpu 5 (hwid 5) Ready to die...
[ 1227.309044] rcu-torture: rtc: d000000002b07988 ver: 51932 tfle: 0 rta: 51932 rtaf: 4460 rtf: 51931 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 905659
[ 1227.309047] rcu-torture: Reader Pipe:  1608378751 6264 0 0 0 0 0 0 0 0 0
[ 1227.309048] rcu-torture: Reader Batch:  1608380217 5873 0 0 0 0 0 0 0 0 0
[ 1227.309050] rcu-torture: Free-Block Circulation:  51931 51931 51931 51931 51931 51931 51931 51931 51931 51931 0
[ 1230.380012] cpu 2 (hwid 2) Ready to die...
[ 1233.409002] Switched to NOHz mode on CPU #6
[ 1236.809698] cpu 3 (hwid 3) Ready to die...
[ 1239.910277] cpu 1 (hwid 1) Ready to die...
[ 1242.949002] Switched to NOHz mode on CPU #4
[ 1245.999003] Switched to NOHz mode on CPU #3
[ 1249.390601] cpu 6 (hwid 6) Ready to die...
[ 1252.469487] cpu 4 (hwid 4) Ready to die...
[ 1255.509000] Switched to NOHz mode on CPU #2
[ 1257.309028] rcu-torture: rtc: d000000002b07628 ver: 53327 tfle: 0 rta: 53327 rtaf: 4509 rtf: 53326 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 929221
[ 1257.309031] rcu-torture: Reader Pipe:  1634440053 6343 0 0 0 0 0 0 0 0 0
[ 1257.309032] rcu-torture: Reader Batch:  1634441503 5969 0 0 0 0 0 0 0 0 0
[ 1257.309034] rcu-torture: Free-Block Circulation:  53326 53326 53326 53326 53326 53326 53326 53326 53326 53326 0
[ 1258.568998] Switched to NOHz mode on CPU #1
[ 1261.928999] Switched to NOHz mode on CPU #6
[ 1265.289004] Switched to NOHz mode on CPU #5
[ 1268.809960] cpu 3 (hwid 3) Ready to die...
[ 1271.920251] cpu 1 (hwid 1) Ready to die...
[ 1274.949007] Switched to NOHz mode on CPU #4
[ 1278.328999] Switched to NOHz mode on CPU #1
[ 1281.769999] cpu 5 (hwid 5) Ready to die...
[ 1284.869788] cpu 2 (hwid 2) Ready to die...
[ 1287.309027] rcu-torture: rtc: d000000002b075f8 ver: 54616 tfle: 0 rta: 54616 rtaf: 4682 rtf: 54615 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 952306
[ 1287.309029] rcu-torture: Reader Pipe:  1674571436 6495 0 0 0 0 0 0 0 0 0
[ 1287.309031] rcu-torture: Reader Batch:  1674572898 6139 0 0 0 0 0 0 0 0 0
[ 1287.309032] rcu-torture: Free-Block Circulation:  54615 54615 54615 54615 54615 54615 54615 54615 54615 54615 0
[ 1287.898998] Switched to NOHz mode on CPU #5
[ 1291.328999] Switched to NOHz mode on CPU #2
[ 1294.749895] cpu 1 (hwid 1) Ready to die...
[ 1297.778994] Switched to NOHz mode on CPU #3
[ 1301.199915] cpu 2 (hwid 2) Ready to die...
[ 1304.299776] cpu 3 (hwid 3) Ready to die...
[ 1307.409851] cpu 6 (hwid 6) Ready to die...
[ 1310.539692] cpu 4 (hwid 4) Ready to die...
[ 1313.579005] Switched to NOHz mode on CPU #7
[ 1316.629000] Switched to NOHz mode on CPU #2
[ 1317.309026] rcu-torture: rtc: d000000002b07748 ver: 56039 tfle: 0 rta: 56039 rtaf: 4682 rtf: 56038 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 975281
[ 1317.309028] rcu-torture: Reader Pipe:  1711711038 6628 0 0 0 0 0 0 0 0 0
[ 1317.309030] rcu-torture: Reader Batch:  1711712535 6287 0 0 0 0 0 0 0 0 0
[ 1317.309031] rcu-torture: Free-Block Circulation:  56038 56038 56038 56038 56038 56038 56038 56038 56038 56038 0
[ 1320.129890] cpu 7 (hwid 7) Ready to die...
[ 1323.229602] cpu 5 (hwid 5) Ready to die...
[ 1326.269002] Switched to NOHz mode on CPU #4
[ 1329.420121] cpu 4 (hwid 4) Ready to die...
[ 1332.459003] Switched to NOHz mode on CPU #6
[ 1335.509004] Switched to NOHz mode on CPU #7
[ 1338.848999] Switched to NOHz mode on CPU #1
[ 1342.209003] Switched to NOHz mode on CPU #5
[ 1345.559007] Switched to NOHz mode on CPU #0
[ 1347.309029] rcu-torture: rtc: d000000002b07658 ver: 57504 tfle: 0 rta: 57504 rtaf: 4682 rtf: 57503 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 998737
[ 1347.309032] rcu-torture: Reader Pipe:  1741502304 6739 0 0 0 0 0 0 0 0 0
[ 1347.309033] rcu-torture: Reader Batch:  1741503826 6379 0 0 0 0 0 0 0 0 0
[ 1347.309035] rcu-torture: Free-Block Circulation:  57503 57503 57503 57503 57503 57503 57503 57503 57503 57503 0
[ 1349.029936] cpu 7 (hwid 7) Ready to die...
[ 1352.059000] Switched to NOHz mode on CPU #4
[ 1355.659940] cpu 5 (hwid 5) Ready to die...
[ 1358.790147] cpu 4 (hwid 4) Ready to die...
[ 1361.839001] Switched to NOHz mode on CPU #4
[ 1365.259857] cpu 2 (hwid 2) Ready to die...
[ 1368.288997] Switched to NOHz mode on CPU #5
[ 1371.780046] cpu 0 (hwid 0) Ready to die...
[ 1374.859001] Switched to NOHz mode on CPU #0
[ 1377.309030] rcu-torture: rtc: d000000002b08408 ver: 58788 tfle: 0 rta: 58788 rtaf: 4868 rtf: 58787 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1022291
[ 1377.309032] rcu-torture: Reader Pipe:  1794636737 6945 0 0 0 0 0 0 0 0 0
[ 1377.309034] rcu-torture: Reader Batch:  1794638221 6651 0 0 0 0 0 0 0 0 0
[ 1377.309035] rcu-torture: Free-Block Circulation:  58787 58787 58787 58787 58787 58787 58787 58787 58787 58787 0
[ 1378.310733] cpu 6 (hwid 6) Ready to die...
[ 1381.348998] Switched to NOHz mode on CPU #6
[ 1384.689005] Switched to NOHz mode on CPU #7
[ 1388.199993] cpu 4 (hwid 4) Ready to die...
[ 1391.229001] Switched to NOHz mode on CPU #4
[ 1394.669942] cpu 7 (hwid 7) Ready to die...
[ 1397.789999] cpu 4 (hwid 4) Ready to die...
[ 1400.819000] Switched to NOHz mode on CPU #7
[ 1404.249833] cpu 7 (hwid 7) Ready to die...
[ 1407.309026] rcu-torture: rtc: d000000002b078f8 ver: 60027 tfle: 0 rta: 60027 rtaf: 5099 rtf: 60026 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1045552
[ 1407.309028] rcu-torture: Reader Pipe:  1842757013 7135 0 0 0 0 0 0 0 0 0
[ 1407.309030] rcu-torture: Reader Batch:  1842758568 6836 0 0 0 0 0 0 0 0 0
[ 1407.309031] rcu-torture: Free-Block Circulation:  60026 60026 60026 60026 60026 60026 60026 60026 60026 60026 0
[ 1407.369729] cpu 6 (hwid 6) Ready to die...
[ 1410.408996] Switched to NOHz mode on CPU #4
[ 1413.859686] cpu 4 (hwid 4) Ready to die...
[ 1416.959616] cpu 0 (hwid 0) Ready to die...
[ 1419.998995] Switched to NOHz mode on CPU #4
[ 1423.419003] Switched to NOHz mode on CPU #0
[ 1426.919762] cpu 1 (hwid 1) Ready to die...
[ 1430.050161] cpu 0 (hwid 0) Ready to die...
[ 1433.139485] cpu 5 (hwid 5) Ready to die...
[ 1436.179004] Switched to NOHz mode on CPU #1
[ 1437.309024] rcu-torture: rtc: d000000002b083d8 ver: 61377 tfle: 0 rta: 61377 rtaf: 5226 rtf: 61376 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1068844
[ 1437.309026] rcu-torture: Reader Pipe:  1871408577 7257 0 0 0 0 0 0 0 0 0
[ 1437.309028] rcu-torture: Reader Batch:  1871410264 6899 0 0 0 0 0 0 0 0 0
[ 1437.309029] rcu-torture: Free-Block Circulation:  61376 61376 61376 61376 61376 61376 61376 61376 61376 61376 0
[ 1439.229001] Switched to NOHz mode on CPU #0
[ 1442.609002] Switched to NOHz mode on CPU #6
[ 1446.029730] cpu 1 (hwid 1) Ready to die...
[ 1449.058998] Switched to NOHz mode on CPU #5
[ 1452.509747] cpu 5 (hwid 5) Ready to die...
[ 1455.599698] cpu 4 (hwid 4) Ready to die...
[ 1458.628999] Switched to NOHz mode on CPU #7
[ 1462.059003] Switched to NOHz mode on CPU #2
[ 1465.489005] Switched to NOHz mode on CPU #1
[ 1467.309026] rcu-torture: rtc: d000000002b07f88 ver: 62750 tfle: 0 rta: 62750 rtaf: 5311 rtf: 62749 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1092378
[ 1467.309029] rcu-torture: Reader Pipe:  1904431875 7407 0 0 0 0 0 0 0 0 0
[ 1467.309030] rcu-torture: Reader Batch:  1904433633 6996 0 0 0 0 0 0 0 0 0
[ 1467.309032] rcu-torture: Free-Block Circulation:  62749 62749 62749 62749 62749 62749 62749 62749 62749 62749 0
[ 1468.909871] cpu 7 (hwid 7) Ready to die...
[ 1472.054584] cpu 2 (hwid 2) Ready to die...
[ 1475.098996] Switched to NOHz mode on CPU #7
[ 1478.519961] cpu 6 (hwid 6) Ready to die...
[ 1481.558998] Switched to NOHz mode on CPU #2
[ 1485.009740] cpu 7 (hwid 7) Ready to die...
[ 1488.039004] Switched to NOHz mode on CPU #5
[ 1491.549690] cpu 2 (hwid 2) Ready to die...
[ 1494.679625] cpu 0 (hwid 0) Ready to die...
[ 1497.309031] rcu-torture: rtc: d000000002b07ad8 ver: 64015 tfle: 0 rta: 64015 rtaf: 5506 rtf: 64014 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1115873
[ 1497.309034] rcu-torture: Reader Pipe:  1942059632 7542 0 0 0 0 0 0 0 0 0
[ 1497.309035] rcu-torture: Reader Batch:  1942061398 7173 0 0 0 0 0 0 0 0 0
[ 1497.309037] rcu-torture: Free-Block Circulation:  64014 64014 64014 64014 64014 64014 64014 64014 64014 64014 0
[ 1497.719001] Switched to NOHz mode on CPU #7
[ 1501.170548] cpu 5 (hwid 5) Ready to die...
[ 1504.219006] Switched to NOHz mode on CPU #3
[ 1507.579001] Switched to NOHz mode on CPU #4
[ 1510.998997] Switched to NOHz mode on CPU #0
[ 1514.609871] cpu 0 (hwid 0) Ready to die...
[ 1517.639003] Switched to NOHz mode on CPU #0
[ 1521.070247] cpu 3 (hwid 3) Ready to die...
[ 1524.099001] Switched to NOHz mode on CPU #3
[ 1527.309024] rcu-torture: rtc: d000000002b07f58 ver: 65445 tfle: 0 rta: 65445 rtaf: 5527 rtf: 65444 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1139039
[ 1527.309026] rcu-torture: Reader Pipe:  1987317115 7720 0 0 0 0 0 0 0 0 0
[ 1527.309028] rcu-torture: Reader Batch:  1987318931 7321 0 0 0 0 0 0 0 0 0
[ 1527.309029] rcu-torture: Free-Block Circulation:  65444 65444 65444 65444 65444 65444 65444 65444 65444 65444 0
[ 1527.449000] Switched to NOHz mode on CPU #5
[ 1530.940022] cpu 1 (hwid 1) Ready to die...
[ 1534.079856] cpu 7 (hwid 7) Ready to die...
[ 1537.169766] cpu 3 (hwid 3) Ready to die...
[ 1540.208998] Switched to NOHz mode on CPU #3
[ 1543.639004] Switched to NOHz mode on CPU #7
[ 1547.109840] cpu 7 (hwid 7) Ready to die...
[ 1550.138996] Switched to NOHz mode on CPU #1
[ 1553.499006] Switched to NOHz mode on CPU #6
[ 1556.939922] cpu 1 (hwid 1) Ready to die...
[ 1557.309033] rcu-torture: rtc: d000000002b08528 ver: 66648 tfle: 0 rta: 66648 rtaf: 5759 rtf: 66647 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1162083
[ 1557.309035] rcu-torture: Reader Pipe:  2034033213 7869 0 0 0 0 0 0 0 0 0
[ 1557.309037] rcu-torture: Reader Batch:  2034034983 7544 0 0 0 0 0 0 0 0 0
[ 1557.309038] rcu-torture: Free-Block Circulation:  66647 66647 66647 66647 66647 66647 66647 66647 66647 66647 0
[ 1559.969002] Switched to NOHz mode on CPU #1
[ 1563.579933] cpu 1 (hwid 1) Ready to die...
[ 1566.869843] cpu 4 (hwid 4) Ready to die...
[ 1569.990409] cpu 5 (hwid 5) Ready to die...
[ 1573.019003] Switched to NOHz mode on CPU #7
[ 1576.449771] cpu 0 (hwid 0) Ready to die...
[ 1579.488997] Switched to NOHz mode on CPU #2
[ 1583.039673] cpu 2 (hwid 2) Ready to die...
[ 1586.069001] Switched to NOHz mode on CPU #1
[ 1587.309029] rcu-torture: rtc: d000000002b07fb8 ver: 68040 tfle: 0 rta: 68040 rtaf: 5822 rtf: 68039 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1185427
[ 1587.309032] rcu-torture: Reader Pipe:  2081200988 8077 0 0 0 0 0 0 0 0 0
[ 1587.309033] rcu-torture: Reader Batch:  2081202862 7696 0 0 0 0 0 0 0 0 0
[ 1587.309035] rcu-torture: Free-Block Circulation:  68039 68039 68039 68039 68039 68039 68039 68039 68039 68039 0
[ 1589.499695] cpu 6 (hwid 6) Ready to die...
[ 1592.529002] Switched to NOHz mode on CPU #2
[ 1595.879003] Switched to NOHz mode on CPU #4
[ 1599.459865] cpu 4 (hwid 4) Ready to die...
[ 1602.559749] cpu 1 (hwid 1) Ready to die...
[ 1605.669642] cpu 7 (hwid 7) Ready to die...
[ 1608.708999] Switched to NOHz mode on CPU #4
[ 1612.069000] Switched to NOHz mode on CPU #7
[ 1615.409003] Switched to NOHz mode on CPU #1
[ 1617.309024] rcu-torture: rtc: d000000002b08588 ver: 69354 tfle: 0 rta: 69354 rtaf: 5968 rtf: 69353 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1208647
[ 1617.309027] rcu-torture: Reader Pipe:  2115106458 8221 0 0 0 0 0 0 0 0 0
[ 1617.309029] rcu-torture: Reader Batch:  2115108400 7829 0 0 0 0 0 0 0 0 0
[ 1617.309030] rcu-torture: Free-Block Circulation:  69353 69353 69353 69353 69353 69353 69353 69353 69353 69353 0
[ 1618.829802] cpu 1 (hwid 1) Ready to die...
[ 1621.859001] Switched to NOHz mode on CPU #5
[ 1625.219001] Switched to NOHz mode on CPU #1
[ 1628.649000] Switched to NOHz mode on CPU #6
[ 1632.150333] cpu 3 (hwid 3) Ready to die...
[ 1635.179006] Switched to NOHz mode on CPU #0
[ 1638.680084] cpu 7 (hwid 7) Ready to die...
[ 1641.810173] cpu 5 (hwid 5) Ready to die...
[ 1644.839006] Switched to NOHz mode on CPU #7
[ 1647.309025] rcu-torture: rtc: d000000002b07778 ver: 70591 tfle: 0 rta: 70591 rtaf: 6188 rtf: 70590 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1232046
[ 1647.309027] rcu-torture: Reader Pipe:  2173994787 8453 0 0 0 0 0 0 0 0 0
[ 1647.309029] rcu-torture: Reader Batch:  2173996731 8099 0 0 0 0 0 0 0 0 0
[ 1647.309030] rcu-torture: Free-Block Circulation:  70590 70590 70590 70590 70590 70590 70590 70590 70590 70590 0
[ 1648.319962] cpu 6 (hwid 6) Ready to die...
[ 1651.348997] Switched to NOHz mode on CPU #3
[ 1654.739010] Switched to NOHz mode on CPU #5
[ 1658.294997] cpu 7 (hwid 7) Ready to die...
[ 1661.470017] cpu 1 (hwid 1) Ready to die...
[ 1664.589836] cpu 0 (hwid 0) Ready to die...
[ 1667.699865] cpu 2 (hwid 2) Ready to die...
[ 1670.799632] cpu 3 (hwid 3) Ready to die...
[ 1673.889515] cpu 5 (hwid 5) Ready to die...
[ 1676.929002] Switched to NOHz mode on CPU #2
[ 1677.309028] rcu-torture: rtc: d000000002b084c8 ver: 71858 tfle: 0 rta: 71858 rtaf: 6384 rtf: 71857 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1255032
[ 1677.309030] rcu-torture: Reader Pipe:  2222621877 8657 0 0 0 0 0 0 0 0 0
[ 1677.309032] rcu-torture: Reader Batch:  2222623907 8285 0 0 0 0 0 0 0 0 0
[ 1677.309033] rcu-torture: Free-Block Circulation:  71857 71857 71857 71857 71857 71857 71857 71857 71857 71857 0
[ 1679.978995] Switched to NOHz mode on CPU #3
[ 1683.379593] cpu 3 (hwid 3) Ready to die...
[ 1686.409003] Switched to NOHz mode on CPU #6
[ 1689.869899] cpu 4 (hwid 4) Ready to die...
[ 1692.899001] Switched to NOHz mode on CPU #1
[ 1696.239604] cpu 6 (hwid 6) Ready to die...
[ 1699.319912] cpu 1 (hwid 1) Ready to die...
[ 1702.379001] Switched to NOHz mode on CPU #1
[ 1705.429004] Switched to NOHz mode on CPU #5
[ 1707.309037] rcu-torture: rtc: d000000002b07778 ver: 73193 tfle: 0 rta: 73193 rtaf: 6460 rtf: 73192 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1278258
[ 1707.309040] rcu-torture: Reader Pipe:  2244080094 8734 0 0 0 0 0 0 0 0 0
[ 1707.309041] rcu-torture: Reader Batch:  2244082164 8319 0 0 0 0 0 0 0 0 0
[ 1707.309043] rcu-torture: Free-Block Circulation:  73192 73192 73192 73192 73192 73192 73192 73192 73192 73192 0
[ 1708.848996] Switched to NOHz mode on CPU #3
[ 1712.369723] cpu 3 (hwid 3) Ready to die...
[ 1715.469676] cpu 2 (hwid 2) Ready to die...
[ 1718.569549] cpu 1 (hwid 1) Ready to die...
[ 1721.639001] Switched to NOHz mode on CPU #0
[ 1724.979001] Switched to NOHz mode on CPU #3
[ 1728.369593] cpu 3 (hwid 3) Ready to die...
[ 1731.450271] cpu 5 (hwid 5) Ready to die...
[ 1734.489002] Switched to NOHz mode on CPU #1
[ 1737.309029] rcu-torture: rtc: d000000002b07b68 ver: 74568 tfle: 0 rta: 74568 rtaf: 6524 rtf: 74567 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1301711
[ 1737.309032] rcu-torture: Reader Pipe:  2271004395 8826 0 0 0 0 0 0 0 0 0
[ 1737.309033] rcu-torture: Reader Batch:  2271006492 8393 0 0 0 0 0 0 0 0 0
[ 1737.309034] rcu-torture: Free-Block Circulation:  74567 74567 74567 74567 74567 74567 74567 74567 74567 74567 0
[ 1737.549002] Switched to NOHz mode on CPU #7
[ 1740.889005] Switched to NOHz mode on CPU #4
[ 1744.229006] Switched to NOHz mode on CPU #6
[ 1747.732099] cpu 6 (hwid 6) Ready to die...
[ 1750.850145] cpu 1 (hwid 1) Ready to die...
[ 1753.879001] Switched to NOHz mode on CPU #3
[ 1757.309719] cpu 4 (hwid 4) Ready to die...
[ 1760.430036] cpu 3 (hwid 3) Ready to die...
[ 1763.529574] cpu 0 (hwid 0) Ready to die...
[ 1766.569000] Switched to NOHz mode on CPU #4
[ 1767.309026] rcu-torture: rtc: d000000002b07fb8 ver: 75940 tfle: 0 rta: 75940 rtaf: 6611 rtf: 75939 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1324929
[ 1767.309028] rcu-torture: Reader Pipe:  2306992809 8968 0 0 0 0 0 0 0 0 0
[ 1767.309030] rcu-torture: Reader Batch:  2306994915 8533 0 0 0 0 0 0 0 0 0
[ 1767.309031] rcu-torture: Free-Block Circulation:  75939 75939 75939 75939 75939 75939 75939 75939 75939 75939 0
[ 1769.619004] Switched to NOHz mode on CPU #1
[ 1772.969002] Switched to NOHz mode on CPU #2
[ 1776.329005] Switched to NOHz mode on CPU #5
[ 1779.759941] cpu 7 (hwid 7) Ready to die...
[ 1782.849789] cpu 1 (hwid 1) Ready to die...
[ 1785.949598] cpu 5 (hwid 5) Ready to die...
[ 1788.978999] Switched to NOHz mode on CPU #1
[ 1792.339000] Switched to NOHz mode on CPU #3
[ 1795.759003] Switched to NOHz mode on CPU #5
[ 1797.309018] rcu-torture: rtc: d000000002b08618 ver: 77194 tfle: 0 rta: 77194 rtaf: 6810 rtf: 77193 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1348090
[ 1797.309020] rcu-torture: Reader Pipe:  2336638413 9069 0 0 0 0 0 0 0 0 0
[ 1797.309021] rcu-torture: Reader Batch:  2336640610 8595 0 0 0 0 0 0 0 0 0
[ 1797.309023] rcu-torture: Free-Block Circulation:  77193 77193 77193 77193 77193 77193 77193 77193 77193 77193 0
[ 1799.189003] Switched to NOHz mode on CPU #0
[ 1802.689936] cpu 3 (hwid 3) Ready to die...
[ 1805.809794] cpu 5 (hwid 5) Ready to die...
[ 1808.959800] cpu 2 (hwid 2) Ready to die...
[ 1811.989000] Switched to NOHz mode on CPU #3
[ 1815.339004] Switched to NOHz mode on CPU #6
[ 1818.819848] cpu 0 (hwid 0) Ready to die...
[ 1821.848998] Switched to NOHz mode on CPU #0
[ 1825.389883] cpu 1 (hwid 1) Ready to die...
[ 1827.309023] rcu-torture: rtc: d000000002b08318 ver: 78356 tfle: 0 rta: 78356 rtaf: 7072 rtf: 78355 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1371257
[ 1827.309026] rcu-torture: Reader Pipe:  2378621042 9229 0 0 0 0 0 0 0 0 0
[ 1827.309027] rcu-torture: Reader Batch:  2378623246 8768 0 0 0 0 0 0 0 0 0
[ 1827.309028] rcu-torture: Free-Block Circulation:  78355 78355 78355 78355 78355 78355 78355 78355 78355 78355 0
[ 1828.419002] Switched to NOHz mode on CPU #7
[ 1831.860049] cpu 3 (hwid 3) Ready to die...
[ 1834.939002] Switched to NOHz mode on CPU #1
[ 1838.288998] Switched to NOHz mode on CPU #5
[ 1841.820168] cpu 4 (hwid 4) Ready to die...
[ 1844.939853] cpu 0 (hwid 0) Ready to die...
[ 1848.040477] cpu 7 (hwid 7) Ready to die...
[ 1851.069001] Switched to NOHz mode on CPU #2
[ 1854.519715] cpu 6 (hwid 6) Ready to die...
[ 1857.309034] rcu-torture: rtc: d000000002b08528 ver: 79746 tfle: 0 rta: 79746 rtaf: 7141 rtf: 79745 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1394468
[ 1857.309037] rcu-torture: Reader Pipe:  2429087479 9439 0 0 0 0 0 0 0 0 0
[ 1857.309039] rcu-torture: Reader Batch:  2429089713 8978 0 0 0 0 0 0 0 0 0
[ 1857.309040] rcu-torture: Free-Block Circulation:  79745 79745 79745 79745 79745 79745 79745 79745 79745 79745 0
[ 1857.315808] rcu-torture: rtc:           (null) ver: 79746 tfle: 0 rta: 79746 rtaf: 7141 rtf: 79745 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1394468
[ 1857.315810] rcu-torture: Reader Pipe:  2429087479 9439 0 0 0 0 0 0 0 0 0
[ 1857.315812] rcu-torture: Reader Batch:  2429089713 8978 0 0 0 0 0 0 0 0 0
[ 1857.315813] rcu-torture: Free-Block Circulation:  79745 79745 79745 79745 79745 79745 79745 79745 79745 79745 0
[ 1857.369027] rcu-torture: rtc:           (null) ver: 79746 tfle: 0 rta: 79746 rtaf: 7141 rtf: 79745 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1394468
[ 1857.369030] rcu-torture: Reader Pipe:  2429087479 9439 0 0 0 0 0 0 0 0 0
[ 1857.369031] rcu-torture: Reader Batch:  2429089713 8978 0 0 0 0 0 0 0 0 0
[ 1857.369033] rcu-torture: Free-Block Circulation:  79745 79745 79745 79745 79745 79745 79745 79745 79745 79745 0
[ 1857.369064] rcu-torture:--- End of test: SUCCESS: nreaders=16 nfakewriters=4 stat_interval=30 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4
[ 1857.629688] cpu 2 (hwid 2) Ready to die...
(bot:conmon-payload) disconnected

--VS++wcV0S1rZb1Fb--
