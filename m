Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422676Ab2JLLen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:34:43 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:63985 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758516Ab2JLLeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:34:37 -0400
Date: Fri, 12 Oct 2012 14:34:33 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Linux KVM tool for v3.7-rc0
Message-ID: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling the latest LKVM tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git kvmtool/for-linus

LKVM is the long lost userspace friend of KVM that makes it really easy
to launch virtualized Linx environment on x86 and PPC64 Linux.

To try out LKVM, first make sure you have a KVM and virtio enabled
kernel:

  make defconfig
  make kvmconfig
  make

Second, install LKVM to your $HOME/bin directory:

  make -C tools/kvm install

And then simply type:

  lkvm run

and you are greeted with a network-enabled shell in a KVM sandbox using
your host binaries running a freshly built kernel.

One really cool thing to do with LKVM is run Trinity. the Linux syscall
fuzzer, in a KVM sandbox.

To do that, first fetch latest Trinity sources and install it to your
$HOME/bin directory:

  git clone git://git.codemonkey.org.uk/trinity
  make -C trinity install

Then start trinity in a KVM sandbox:

  lkvm sandbox -- $HOME/bin/trinity --dangerous

			Pekka

------------------>
The following changes since commit 56d92aa5cf7c96c70f81d0350c94faf46a9fb76d:

  Merge tag 'stable/for-linus-3.7-x86-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen (2012-10-02 22:09:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git kvmtool/for-linus

Alessandro Guido (2):
      kvm tools, ui: Add some missing key codes
      kvm tools, sdl: Fix "5" key

Amerigo Wang (2):
      kvm tools: build rbtree.o from source
      kvm tools: implement "help xxx" command

Amos Kong (4):
      kvm tools: Make virt_queue__available return false if queue is not initialized
      kvm tools: Add a script to setup private bridge
      kvm tools: Add a script to setup tap device
      kvm tools: Setup bridged network by a script

Andy Shevchenko (1):
      kvm tools: don't use custom strtoul for hex numbers

Aneesh Kumar K.V (21):
      tools/kvm/9p: Add support for multiple 9p export dirs
      tools/kvm/9p: Always include system header before kernel headers
      tools/kvm/9p: Use the same #define as the kernel
      tools/kvm/virtio: Add new iov helper
      tools/kvm/9p: Don't follow symlink on server
      tools/kvm/9p: Fix the pdu len.
      tools/kvm/9p: Simplify the handler
      tools/kvm/9p: check the iov count with the read/write count
      tools/kvm/9p: Add error protocol reply
      tools/kvm/9p: Make the 9p handler void return
      tools/kvm/9p: Add error handling
      tools/kvm/9p: Add encode/decode routines for protocol data
      tools/kvm/9p: return EOPNOTSUPP if the handler is not implemented
      kvm tools, 9p: Add error handling to protocol handlers
      kvm tools, 9p: WSTAT don't use open fid
      net/9p: Remove structure not used in the code
      tools/kvm: Use kernel header version of net/9p/9p.h
      kvm tools, 9p: handler should be called in case of not supported operation
      kvm tools: Save and restore the iovec related values in read and write
      kvm tools, 9p: Implement 9p2000.L extensions
      kvm tools, 9p: Fix walk to prepare correct path name

Anton Vorontsov (1):
      kvm tools: Fix broken terminal when kvm exits because of a signal

Asias He (192):
      bios: No new line at EOF nit fix
      kvm: remove unneccessary iotcl parameter
      kvm__init: the kernel should support irq and pit
      kvm: reimplement kvm__setup_sregs
      kvm: kvm__setup_sregs initialize more registers
      early_printk.c: add rep/outsb support
      kvm__setup_sregs: fix indentation
      kvm, test: add PIT 8254 and PIC 8259 test code
      kvm, test: add a counter to tick test in ISR
      kvm: Check vmx capability using cpuid
      kvm__setup_cpuid: use KVM_GET_SUPPORTED_CPUID to simplify cpuid setup
      kvm, pci: fill up virtio device configuration header
      kvm: Add cscope target to Makefile
      virtio: capacity should be in 512-byte sectors
      kvm,virtio: move SECTOR_SHIFT and SECTOR_SIZE to disk-image.h
      kvm,virtio: do not publish read only feature to guest
      kvm: Add rw to default kernel command line parameters
      kvm,virtio: add scatter-gather support
      kvm,virtio: add scatter-gather support v2
      kvm tools: add README
      kvm tools: remove KVM_EXIT_INTERNAL_ERROR
      kvm tools: Cleanup IO space and PCI magic numbers
      kvm tools: Add helper functions for virtqueue code
      kvm tools: Move terminal related code to a new file term.c
      kvm tools: Make 8250 serial use infrastructure provided by term.c
      kvm tools: Virtio console support
      kvm tools: Introduce --enable-virtio-console option
      kvm tools: Rename struct device to struct blk_device for block devices
      kvm tools: Introduce virtio.c and virtio.h
      kvm tools: Unify virtio code file names
      kvm tools: Drop virt_queue__get_used_elem virtio helper
      kvm tools: Use virt_queue__get_iov to simpify virtio blk IO handler
      kvm tools: Make virtio console device code thread-safe
      kvm tools: Remove unnecessary goto label out_unlock
      kvm tools: Exit KVM session on Ctrl+a and 'x'
      kvm tools: Replace option --enable-virtio-console with --console
      kvm tools: Fix virtio console PCI class number and device ID number
      kvm tools: Fix lock imbalance in virtio_console_pci_io_out()
      kvm tools: Use IRQ pin 2 for virtio console
      kvm tools: Implement virtio network device
      kvm tools: Fix virtio console input problem
      kvm tools: Implement virtio net TSO/UFO support
      kvm tools: Respect ISR status in virtio header
      kvm tools: Respect VRING_AVAIL_F_NO_INTERRUPT
      kvm tools: Use virt_queue__trigger_irq() to trigger IRQ for virtio console
      kvm tools: Use virt_queue__trigger_irq() to trigger IRQ for virtio blk
      kvm tools: Use virt_queue__trigger_irq() to trigger IRQ for virtio rng
      kvm tools: Fix virtio console hangs by removing IRQ injection for tx path
      kvm tools: Bring VIRTIO_BLK_F_SEG_MAX feature back to virtio blk
      kvm tools: Tune the command-line option
      kvm tools: Move disk image related code under disk directory
      kvm tools: Rename disk-image.c to core.c
      kvm tools: Split raw image and blk device code from disk/core.c
      kvm tools: Rename disk_image__{read, write}_sector_iov
      kvm tools: Remove dead coe disk_image__{read, write}_sector
      kvm tools: Consolidate disk_image__{new, new_readonly}
      kvm tools: Split blk device code from raw.c to blk.c
      kvm tools: Tune up ops in 'struct disk_image_operations'
      kvm tools: Rename struct disk_image_operations ops name for raw image
      kvm tools: Rename raw_image_ops to blk_dev_ops
      kvm tools: Remove unnecessary S_ISBLK check
      kvm tools: Do not use 'inline' for disk_image__flush
      kvm tools: Add debug info for disk_image__{read, write}
      kvm tools: Print debug info for qcow1_nowrite_sector
      kvm tools: Update README
      kvm tools: Introduce ethernet frame buffer system for uip
      kvm tools: Add ARP support for uip
      kvm tools: Add IPV4 support for uip
      kvm tools: Implement IP checksum for uip
      kvm tools: Add ICMP support for uip
      kvm tools: Introduce struct uip_udp to present UDP package
      kvm tools: Introduce struct uip_pseudo_hdr to present UDP pseudo header
      kvm tools: Introduce struct uip_udp_socket
      kvm tools: Add two helpers to return UDP {header, total} length
      kvm tools: Add helper to return ethernet header length
      kvm tools: Implement uip_csum_udp() to calculate UDP checksum
      kvm tools: Add UDP support for uip
      kvm tools: Introduce struct uip_tcp to present TCP package.
      kvm tools: Introduce struct uip_tcp_socket
      kvm tools: Add helpers to return TCP {header, total, payload} length
      kvm tools: Add helper to return start address of TCP payload
      kvm tools: Add helpers to test whether SYN or FIN bit is set.
      kvm tools: Add helper to allocate and get TCP initial sequence number
      kvm tools: Implement uip_csum_tcp() to calculate TCP checksum
      kvm tools: Add TCP support for uip
      kvm tools: Introduce uip_init() for uip
      kvm tools: Introduce uip_tx() for uip
      kvm tools: Introduce uip_rx() for uip
      kvm tools: Add MACRO for user and tap mode for virtio net
      kvm tools: Reanme net_device to net_dev
      kvm tools: Introduce -net {user, tap, none} options for virtio net
      kvm tools: Change default guest MAC address to 00:15:15:15:15:15
      kvm tools: Make virtio net work with user mode network
      kvm tools: Make default network mode to user mode
      kvm tools: Make default host ip address to 192.168.33.1
      kvm tools: Introduce struct net_dev_operations
      kvm tools: Make virtio net work on older kernels
      kvm tools: Move uip to net directory
      kvm tools: Introduce uip_udp_make_pkg()
      kvm tools: Introduce struct uip_dhcp
      kvm tools: Add helper to tell if a UDP package is a DHCP package
      kvm tools: Add helpers to tell the type of a DHCP message
      kvm tools: Get domain name and nameserver from host
      kvm tools: Fill DHCP options with domain name and DNS server IP
      kvm tools: Fill all DHCP options
      kvm tools: Introduce uip_dhcp_make_pkg()
      kvm tools: Introduce uip_tx_do_ipv4_udp_dhcp()
      kvm tools: Get DNS information from host in uip_init()
      kvm tools: Handle DHCP package in gernal UDP processing path
      kvm tools: Introduce --guest-ip option
      kvm tools: Introduce --host-mac option
      kvm tools: Rename --host-ip-addr to --host-ip
      kvm tools: Initialize MAC address for virtio net properly
      kvm tools: Initialize MAC and IP address for uip properly
      kvm tools: Add '-Wunused-result' to WARNINGS
      kvm tools: Tune 'kvm balloon' option
      kvm tools: Make --kvm-dev option shorter
      kvm tools: Make --virtio-9p option shorter
      kvm tools: Sort options of kvm run command
      kvm tools: Tune --disk option usage information
      kvm tools: Set correct virtio pci device class code
      kvm tools: Fix MSI-X table size set up
      kvm tools: Drop unused variable in struct uip_buf
      kvm tools: Use macro in uip_tx_do_ipv4()
      kvm tools: Fix a vertical indentation for net/uip/udp.c
      kvm tools: Fix ndev mutex and condition variable initialization
      kvm tools: Remove dead code virt_queue__trigger_irq()
      kvm tools: Fix build in virtio/net.c
      kvm tools: Use vring_need_event() to determine if interrupt is needed
      kvm tools: Improve virtio blk request processing
      kvm tools: Get multiple io events at a time
      kvm tools: Remove unnecessary assignment in disk/raw.c
      kvm tools: Drop write operation in ro_ops_nowrite
      kvm tools: Remove lkvm alias vm in 'make clean'
      kvm tools: Fix 'lkvm stop' when guest is pasued.
      kvm tools: Do not run guest if it is stopped.
      kvm tools: Fix compat message per device for virtio/blk
      kvm tools: Handle multiple IPC cmd at a time
      kvm tools: Introduce KVM_IPC_VMSTATE IPC cmd
      kvm tools: Respect paused status in ./lkvm list
      kvm tools: Improve 'lkvm {pause,resume}'s output
      kvm tools: Remove resume pause noise.
      kvm tools: Use kvm_ipc__send to send IPC msg
      kvm tools: Fix kvm-ipc.c build breakage
      kvm tools: Simply write_in_full() check semantics
      kvm tools: Add is_pio flag to ioeventfd__add_event
      kvm tools: Rework on virtio transport abstraction.
      kvm tools: Rename callback_mmio_table
      kvm tools: Introduce KVM_VIRTIO_MMIO_AREA
      kvm tools: Add virtio-mmio support
      kvm tools: Support virtio-mmio in virtio_init
      kvm tools: Introduce trans=mmio parameter for virtio-net
      kvm tools: Increase virtio-blk and virtio-net queue size
      kvm tools: Add set_size_vq for virtio-net
      kvm tools: Add set_size_vq for virtio-blk
      kvm tools: Rename VIRTIO_P9 to VIRTIO_9P
      kvm tools: Use enum for NET_MODE_{USER, TAP}
      kvm tools: Small indentation fix
      kvm tools: Drop unnecessary headers in barrier.h
      kvm tools: Make raw block device work
      kvm tools: Fix sdl hang
      kvm tools: Update README for CONFIG_FB_VESA
      kvm tools: Remove unused req_mutex variable.
      kvm tools: Rename ~/.kvm-tools/ to ~/.lkvm/
      kvm tools: Restart io_submit if it returns EAGAIN
      kvm tools: Simplify disk read write function name
      kvm tools: Code cleanup for virtio/9p.c
      kvm tools: Code cleanup for virtio/balloon.c
      kvm tools: Code cleanup for virtio/blk.c
      kvm tools: Code cleanup for virtio/console.c
      kvm tools: Code cleanup for virtio/net.c
      kvm tools: Code cleanup for disk/core.c
      kvm tools: Code cleanup for disk/qcow.c
      kvm tools: Code cleanup for disk/raw.c
      kvm tools: Introduce virtio_compat_add_message() helper
      kvm tools: Fix compat message
      kvm tools: Improve compat message format
      kvm tools: Increase AIO_MAX to 256
      kvm tools: Process virito blk requests in separate thread
      kvm tools: Fix VHOST_SET_MEM_TABLE failure
      kvm tools: Do not poll ioeventfd if vhost is enabled
      kvm tools: Introduce struct disk_image_params
      kvm tools: Enable O_DIRECT support
      kvm tools: Add initial virtio-scsi support
      kvm tools: Embed init and init_stage2 into lkvm binary
      kvm tools: Use LD instead using 'ld' directly
      kvm tools: Merge guest init and init_stage2.c
      kvm tools: Make 'lkvm setup' work outside kernel/tools/kvm dir
      kvm tools: Make tcp between guest/host virtual ip work in UIP mode
      kvm tools: Respect guest tcp window size
      kvm tools: Export DISPLAY ENV as our default host ip address
      kvm tools: Mount devpts to /dev/pts

Cyrill Gorcunov (132):
      Add utility functions
      Don't die on old kernels without single-step debug support
      Makefile: Add CPPFLAGS handling
      Add info() helper
      kvm: load_bzimage: Proper check for number of setup sectors
      kvm: Use 64 bit names when showing registers
      kvm: Fixup boot selector
      kvm: Add --kernel parameter handling
      kvm: Add --params option
      kvm: Introduce IVT handling
      kvm: Setup fake IVT table
      kvm: Fill up fake IVT
      kvm: Rename ivt_ prefixed entities
      kvm: Put fake bios interrupt handlers into known memory area
      bios: Add simple bin2c converter
      interrupt: Add interrupt_table__set helper
      kvm: Introduce kvm__dump_mem helper
      interrupt: Move bios related constants to kvm/bios.h
      bios: Add bios stubs generated from assembly files
      kvm: Add copying of kernel command line into guest memory
      kvm: Update command line related enitites in boot parameters
      kvm: Reference to undefined variable
      kvm: Make command line to be placed at predefined address
      ioport: Make all PIT channels being dummy
      kvm: Add more default kernel command line parameters
      kvm: Kill the bin2c helper
      Makefile: Add cpu specific definition
      kvm: Command line update must honor ABI
      kvm: Set more fields in boot protocol
      kvm: Don't touch 64 bit specific MSR registers on 32 bit
      Change __x86_x__ to CONFIG_X86_X
      kvm: Print error code on unknown error
      kvm: Use PRIx qualificator for printf
      kvm: Use strlcat helper for copying cmdline params
      kvm: Check for required KVM extensions in one place
      kvm: Append missing ending space for built-in command line
      kvm: The command line storage should not be too short
      early_printk: Simplify the code
      tests/pit: Issue cli on ISR handling
      test/pit: Fill up IDT with noop handler
      kvm: Check for HTL extension granted
      tests/pit: Increase PIT frequency up to 1KHz
      kvm: Add force exit from tests
      kvm, tests: Use motherboard specific ports for testing
      kvm, cpuid: Fix XSTOR and VMX compatibility in cpuid
      kvm: KVM_CAP_EXT_CPUID is required
      kvm, cpuid: Fill up func 0 and 4
      kvm, cpuid: Use logical AND on bit ops
      kvm: Check for SVM extension being supported for AMD cpus
      kvm, bios: Get rid of buggy int10 handler
      Exclude .cscope from .gitignore
      kvm, bios: Rework BIOS setup
      bios: Don't clobber 32bit registers
      bios: No need for sti at int15 irq exit
      kvm: Add --mem= option
      kvm, bios: BIOS code redesign
      kvm, bios: Make e820 map to look similar the real one
      bios: clean predefined bios area early
      pci: Use proper PCI port names
      pci: Fix typo in previous commit
      kvm, pci: Return "no device" by default
      kvm, pci: Add dummy virtio device for probing
      kvm, pci: Add bus forwarding register
      kvm, pci: Fix offset for pci CONFIG_DATA ioport
      kvm, pci: Claim virtio device ioport in pci header
      kvm: Support loading initrd image
      kvm: Add virtio_ring.h to tree
      kvm: Add virtio_blk.h to tree
      kvm: Don't forget to close initrd file
      bios: Get rid of redundant ops
      bios: Use proper grep syntax
      kvm: Setup disk geometry if needed
      virtio-blk: Leave disk geometry to compute in kernel
      make: Add TAGS, tags targets and tune cscope
      kvm: save/restore std ttys
      8250-serial: Simplify is_readable function
      8250-serial: Use linux/serial-reg.h with predefined constants
      8250-serial: Make transmitter being always ready to send data
      8250-serial: Emulate 8250 behaviour on autoprobing
      virtio, block: Rename IOPORT_VIRTIO to IOPORT_VIRTIO_BLK
      kvm tools: Setup BIOS for both bzImage and flat image
      kvm tools: Remove useless empty lines for a call series in kvm__reset_vcpu
      kvm tools: Separate BIOS specifics into own file
      kvm tools, bios: Introduce bioscall specificator
      kvm tools: Use static assignment for default RAM size
      kvm tools: Add --cpus parameter
      kvm tools: Update documentation
      kvm tools: Add missing space before root= option
      kvm tools: Use non shared pin/irqs for virtio devices
      kvm tools: Add MP tables support
      kvm tools: Use system wide msr-index.h instead of own definitions
      kvm tools: Add NR_CPUS definition in case of non-configured kernel sources
      kvm tools: Gather Virtio-PCI constants into one place
      kvm tools: Fix up PCI pin assignment to conform specification
      kvm tools: Fix up mtable srcbusirq assignment for PCI devices
      kvm tools: Add debug() helper
      kvm tools: Prefix error() and friends helpers with pr_
      kvm tools: Add conditional compilation of symbol resolving
      kvm tools: Fix alignment for mpf_intel table
      kvm tools, 9p: Test for tuncation result
      kvm tools: Print out a warning on io-port re-registration
      kvm tools: Drop unused vars from int10.c code
      kvm tools: Options parser to handle hex numbers
      kvm tools: Introduce vidmode parmeter
      kvm tools: Delete dangling cursor from int10
      kvm tools: Get rid of spaces in ld script
      kvm tools: Reform bios make rules
      kvm tools, bios: Make sure IRQ handlers segment is properly set
      kvm tools: Fix absence of notrace definition
      kvm tools: Support xAPIC
      kvm tools: Clear presence of performance-energy bias bit
      kvm tools: Use ARRAY_SIZE helper to count serial devices
      kvm tools: Fix VESA BIOS mode info
      kvm tools: Drop "notsc" no longer needed kernel option
      kvm tools: Add BUG_ON() helper to make a run-time critical tests
      kvm tools: Define __compiletime_error helper
      kvm tools: Rename pr_error to pr_err to follow kernel convention
      kvm tools, sd: Fix array size for keymap
      kvm tools: Make kvm__arch_setup_firmware to return error code
      kvm tool: Introduce own BUG_ON handler
      kvm tools: Remove tags/TAGS on "make clean"
      kvm tools: Don't stop working if symbols search engine failed to init
      kvm tools: Cleanup BDF searching code
      kvm tools: Fix test for mmap failure
      kvm tool: Make kvm structure to carry name copy
      kvm tool: Don't close not yet opened files and SIGSEV fix
      kvm tools: Bring mptables back in case if no firmware used
      kvm tools, x86: Drop unneeded sections in rom building script
      kvm tools: Add --debug-mmio option
      kvm tools: Add own barrier() definition
      kvm tools: Use safe string handling functions
      kvm tools: Add test for -static libc present

David Ahern (1):
      kvm tools: do not append root=/dev/vda if passed via command line

Emil Renner Berthing (1):
      kvm tools: Update README with instructions for Arch Linux

Giuseppe Calderaro (2):
      kvm tools: Fix compilation issue in virtio-blk.c
      kvm tools: Remove unused handle_sigint() function

Hagen Paul Pfeifer (2):
      kvm tools, setup: Create private directory
      kvm tools: remove addr_type - unused but set variable

Hongyong Zang (1):
      kvm tool: Change kvm->ram_size to real mapped size.

Ingo Molnar (13):
      kvm tools: Emit a more informative error message when /dev/kvm does not open
      kvm tools: Fix segfault when running 'kvm' without a disk image
      kvm tools: Indicate the end of a KVM session
      kvm tools: Fix 64-bit assumptions and type uglinesses
      kvm tools: Fix 32-bit build of the asm/system.h include
      kvm tools: Enable earlyprintk=serial by default
      kvm tools: Fix and improve the CPU register dump debug output code
      kvm tools: Dump vCPUs in order
      kvm tools: Use standardized style for the virtio/net.c driver
      kvm tools: Fix type mismatches on GCC 4.4 on 32-bit systems
      kvm tools: Fix virtio net build breakage on 32-bit
      kvm tools: Fix build breakage with GCC 4.7
      tools/kvm: Fix compilation fallout from system.h split-up

Jean-Philippe Menil (1):
      kvm tools: Fix printf() format string in kvm__load_firmware()

John Floren (6):
      kvm tools: Add BIOS INT10 handler
      kvm tools: Add video mode to kernel initialization
      kvm tools: Add VESA device
      kvm tools: Update makefile and feature tests
      kvm tools: Initialize and use VESA and VNC
      kvm tools: Add support for PS/2 keyboard system

Konstantin Khlebnikov (2):
      kvm tools: fix instances enumeration
      kvm tools: pick kernel from linux source tree root

Lai Jiangshan (42):
      kvm tools: check condition before wait
      kvm tools: fix function name
      kvm tools: move threadpool.c to util/
      kvm tools: move rbtree.o to util/
      kvm tools: add missing build output
      kvm tools: move read-write.c to util/
      kvm tools: move util.c to util/
      kvm tools: move strlcat() to util/strbuf.c
      kvm tools: narrow the C.S. of compat_mtx
      kvm tools: protect shared global id in compat_mtx C.S.
      kvm tools: remove duplicated code
      kvm-tools: Create util/rbtree.d
      kvm-tools: Fix error path
      kvm-tools: remove make_root_dir()
      kvm-tools: only one rootfs directory atmost
      kvm-tools: write the sandbox command exactly as expect
      kvm-tools: Don't create existed ~/.kvm-tools/ directory
      kvm-tools: remove unneed sprintf("%s")
      kvm-tools: fix wrong "./lkvm list -i"
      kvm-tools: remove unneed SIGKVMXX
      kvm tools: Avoid overflow
      kvm tools: mark usages functions as NORETURN
      kvm tools: cleanup kvm_cmd_balloon()
      kvm tools: cleanup kvm_cmd_debug()
      kvm tools: cleanup kvm_cmd_pause()
      kvm tools: cleanup kvm_cmd_resume()
      kvm tools: cleanup kvm_cmd_stat()
      kvm tools: cleanup kvm_cmd_stop()
      kvm tools: cleanup kvm_ipc__handle()
      kvm tools: add kvm_ipc__receive()
      kvm tools: add kvm_ipc__send() and kvm_ipc__send_msg()
      kvm tools: add WARN_ON()
      kvm tools: carefully send and handle stop ipc
      kvm tools: carefully send and handle balloon ipc
      kvm tools: carefully send and handle debug ipc
      kvm tools: carefully send and handle pause/resume ipc
      kvm tools: carefully send and handle balloon stat ipc
      kvm tools: use custom rootfs_name for guest name
      kvm tools: Remove unused code for print_guest()
      kvm tools: Check the state before pause/resume
      kvm tools: Don't remove any file which is not created by itself
      kvm tools: Add kvm__arch_delete_ram()

Lan Tianyu (4):
      kvm tools: Add support for the read operation of qcow and qcow2 compressed image
      kvm tools, qcow: Add the support for copy-on-write cluster
      kvm tools: Use kernel error check functions
      kvm tools, qcow: Add support for growing refcount blocks

Liming Wang (9):
      kvm tools: remove unused options
      kvm tools: convert callback to int and deal with the return value
      kvm tools: handle failure of command
      kvm tools: ignore balloon signals by default to avoid balloon crash
      kvm tools: enable keyboard press repeat for sdl
      kvm tools: check negative value of num_pages
      kvm tools: unify all serials' registers with the first serial
      kvm tools: fix wrong virtio id for balloon
      kvm tools: change option type of RNG from increment to boolean

Matt Evans (44):
      kvm tools: term.h needs to include stdbool.h
      kvm tools: kvm.c needs to include sys/stat.h for mkdir
      kvm tools: Split x86 arch-specific bits into x86/
      kvm tools: Fix virtio-pci endian bug when reading VIRTIO_PCI_QUEUE_NUM
      kvm tools: Correctly limit nrcpus to max_cpus
      kvm tools: Only build/init i8042 on x86
      kvm tools: Add Makefile parameter for kernel include path
      kvm tools: Re-arrange Makefile to heed CFLAGS before checking for optional libs
      kvm tools: Add arch-specific KVM_RUN exit handling via kvm_cpu__handle_exit()
      kvm tools: Don't die if KVM_CAP_NR_VCPUS isn't available
      kvm tools: Fix KVM_RUN exit code check
      kvm tools: Add kvm__arch_periodic_poll()
      kvm tools: Move arch-specific cmdline init into kvm__arch_set_cmdline()
      kvm tools: Add CONSOLE_HV term type and allow it to be selected
      kvm tools: Fix term_getc(), term_getc_iov() endian bugs
      kvm tools: Allow initrd_check() to match a cpio
      kvm tools: Allow load_flat_binary() to load an initrd alongside
      kvm tools: Initialise PCI before devices start getting registered with PCI
      kvm tools: Perform CPU and firmware setup after devices are added
      kvm tools: Init IRQs after determining nrcpus
      kvm tools: Move PCI_MAX_DEVICES to pci.h
      kvm tools: Endian-sanitise pci.h and PCI device setup
      kvm tools: Correctly set virtio-pci bar_size and remove hardwired address
      kvm tools: Add pci__config_{rd,wr}(), pci__find_dev()
      kvm tools: Arch-specific define for PCI MMIO allocation area
      kvm tools: Add ability to map guest RAM from hugetlbfs
      kvm tools: Create arch-specific kvm_cpu__emulate_{mm}io()
      kvm tools: Fix build of util.c on 32bit machines
      kvm tools: Add initial SPAPR PPC64 architecture support
      kvm tools: Remove KVM_NR_CPUS
      kvm tools: Fix alaising errors in LINT assignment
      PPC: Add __SANE_USERSPACE_TYPES__ to asm/types.h for LL64
      kvm tools: Get correct 64-bit types on PPC64 and link appropriately
      kvm tools: Fix running with --initrd and no real discs/rootfs
      kvm tools: Repair running on non ioeventfd-capable platforms
      kvm tools: Add build target for statically-linked binary
      kvm tools: PPC64, add HPT/SDR1 for -PR KVM
      kvm tools: Generate SPAPR PPC64 guest device tree
      kvm tools: Add SPAPR PPC64 hcall & rtascall structure
      kvm tools: Add SPAPR PPC64 HV console
      kvm tools: Add PPC64 XICS interrupt controller support
      kvm tools: Add PPC64 PCI Host Bridge
      kvm tools: Add PPC64 kvm_cpu__emulate_io()
      kvm tools: Enable PPC64 to build static

Michael Ellerman (22):
      kvm-tool: Don't try to cleanup ioeventfd if we never initialised it
      kvm tools: Define KVM_VIRTIO_MMIO_AREA for powerpc
      kvm tools: Use asm/barrier.h on powerpc
      kvm tools: Support cross compilation
      kvm tools: Cleanup ARCH & uname_M in Makefile
      kvm tool: Fix powerpc/kvm-cpu.c for new KVM_SET_ONE_REG API
      kvm tools: Move mmap_anon_or_hugetblfs() into util
      kvm tools, powerpc: Use mmap_anon_or_hugetblfs() in kvm__arch_init()
      kvm tools: Remember page size as kvm->ram_pagesize
      kvm tools, powerpc: Use designated initializers for struct cpu_info
      kvm tools, powerpc: Use ARRAY_SIZE() in find_cpu_info()
      kvm tools, powerpc: Reformatting in find_cpu_info()
      kvm tools, powerpc: Restructure find_cpu_info()
      kvm tools, powerpc: Use MMU info from the kernel for ibm,segment-page-sizes
      kvm tools, powerpc: Use MMU info for ibm,processor-segment-sizes
      kvm tools, powerpc: Use MMU info for ibm,slb-size
      kvm tools: Fix crash when /etc/resolv.conf doesn't exist
      kvm tools: Fix formatting of error message in TAP handling
      kvm tools: Check for unknown parameters in network option handling
      kvm tools: Fix powerpc build errors caused by recent changes
      kvm tools: Fix segfault on powerpc in xics_register()
      kvm tools: Do setup_fdt() later, get powerpc to boot again

Osier Yang (1):
      kvm tools: Beautify kvm list output

Paul Bolle (1):
      kvm tools: Fix compilation on x86_64

Paul Neumann (1):
      kvm tools: Fix segfault on "lkvm run"

Pekka Enberg (375):
      Initial commit
      Check for KVM_API_VERSION at init
      Add .gitignore file
      Create a VM using ioctl(KVM_CREATE_VM)
      Move KVM fds into 'struct kvm'
      Check for KVM_CAP_USER_MEMORY
      Clean up KVM initialization
      Initialize KVM some more
      Set up TSS address to make vcpu creation work
      Clean up struct kvm file descriptor names
      Mmap the kvm_run structure
      Move CPU emulation code to cpu.c
      Load kernel image to the VM
      Initial version of kernel image loading
      Initialize guest memory region properly
      Load bzImage to guest RAM
      Update .gitignore to include object files
      Dump registers after KVM_RUN returns
      Initialize RIP before starting to run the guest
      Print out constant names for KVM exit reasons
      Show dump of executed code at KVM exit
      Fix guest code printout
      Setup rflags properly to fix EXIT_UNKNOWN
      Fix up rflags printing
      Dump KVM_EXIT_IO details
      Move KVM_SET_REGS to kvm__reset_vcpu()
      Enable KVM guest single-stepping
      Separate KVM code from the main loop
      Setup segmentation for the guest
      Fix LDT descriptor type for KVM_SET_SREG
      Improve KVM register dump output
      Fix up 'ip' in kvm__reset_vcpu() to take real mode into account
      Print 'avl' bits of a segment
      Add a simple "kernel" binary that can be used for testing
      Add support for loading flat binaries
      kvm: Load bzImage real-mode boot sector and setup code
      kvm: Fix bzImage setup sector default count
      kvm: Read the whole bzImage to memory
      kvm: Hardcode a "reset vector" at f000:fff0
      kvm: Add some single-step debugging and don't stop running
      kvm: Clean up reset vector setup code
      kvm: Document the 'reset vector' hack
      kvm: Enable 'interrupt request window'
      Revert "kvm: Enable 'interrupt request window'"
      kvm: Fix setup size calculation
      kvm: Remove 'reset vector' hack
      kvm: Fix kernel boot IP
      kvm: Load kernel at 0x1000
      kvm: Setup stack for the kernel
      kvm: Introduce host_real_to_guest() helper function
      kvm: Rename interrupt emulation source files
      kvm: Clean up kvm/interrupt.h a bit
      kvm: Remove unnecessary includes from interrupt.c
      kvm: Move interrupt table to struct kvm
      kvm: Clean up interrupt_table__setup()
      kvm: Move util.h to include/kvm directory
      kvm: Introduce --single-step command line option
      kvm: Setup CPUID for the guest
      kvm: Enable GCC debugging information
      kvm: Extract CPUID code into its own file
      kvm: Extract ioport emulation code to its own file
      kvm: Don't abort guest on KVM_EXIT_IO
      kvm: Add simple NMI enable/disable support
      kvm: Remove unused cpu.c file
      kvm: Setup guest FPU state
      kvm: Ignore math co-processor reset I/O writes
      kvm: Ignore PIC init during boot
      kvm: Fix protected mode code dump
      kvm: Free memory on exit
      kvm: Clean up Makefile output
      kvm: Add test binaries to .gitignore
      kvm: Clean up kvm__reset_vcpu() function
      kvm: Setup VCPU MSRs
      kvm: Add .gitignore for bios build files
      kvm: Show gdt and idt registers
      kvm: Dump stack on KVM oops
      kvm: Dump page tables at exit
      kvm: Set up MAXPHYADDR guest CPUID
      kvm: Don't crash debug dump if address isn't in guest memory
      kvm: Ignore PCI config space accesses
      kvm: Ignore MMIO accesses
      kvm: Ignore PIC accesses
      kvm: Ignore CMOS RAM/RTC ioports
      kvm: Ignore CRT control ioports
      kvm: Ignore dummy delay ioport
      kvm: Ignore PIT ioports
      kvm: Ignore keyboard controller ioports
      kvm: Fix off-by-one bugs in kvm__setup_cpuid()
      kvm: Fix minor formatting glitch in cpuid.c
      kvm: Add support for early serial printk
      kvm: Force 'notsc' and 'earlyprintk' kernel parameters
      kvm: Clean up early serial code
      Merge branch 'master' of git://github.com/cyrillos/vm
      kvm: Dump state on SIGQUIT
      kvm: Flush stdout for early printk
      kvm: Fix .gitignore patterns
      kvm, test: Move PIT tests to separate directory
      kvm: Add Makefile for compiling all test cases
      kvm: Add .gitignore for tests
      kvm, test: Improve PIT test output
      kvm: Add 'check' target to Makefile
      kvm: Use 'nopci pci=off' kernel parameters by default
      kvm: Cleanup command line parsing
      kvm: Cleanup ioport_ops table
      kvm: Add proper 00E0 ioport handling
      kvm: Add '--params' to usage
      kvm: Don't stop on ioport errors by default
      kvm: Fix compilation warning
      kvm: Introduce 'make devices' target
      kvm: Introduce '--kvm-dev' command line option
      kvm: Cleanup kvm__cpu_supports_vm()
      kvm: Cleanup struct boot_params setup
      kvm: BIOS E820 memory map emulation
      kvm: Use -Os optimization for GCC
      kvm: Fix VM support check for unrecognized CPUs
      kvm: Check for read() return value in load_bzimage()
      kvm: Fix usage command line format
      kvm: Fix load_bzimage for flat binaries
      kvm: Use 32-bit operand size prefix for rdfs8()
      kvm: Use -Werror for building the thing
      kvm: Remove unused outb() function from e820.c
      kvm: Cleanup BIOS setup code
      kvm: Use sizeof instead of magic number
      kvm: Clear performance monitoring CPUID flags
      kvm: Update bios .gitignore list
      kvm: Fix Makefile header dependencies
      kvm: Clean header dependency files
      kvm: Exclude BIOS object files from header deps
      kvm: Use proper segment + offset in e820 bios
      kvm: Add some more ioport emulation
      kvm: Enable Linux kernel PCI probing
      kvm: Force PCI Configuration Mechanism 1
      kvm: Initial PCI probe emulation
      kvm: Add PCI CONFIG_ADDRESS register layout
      kvm, pci: Fix device probe accesses
      kvm: Fix PCI config space emulation
      kvm, pci: Don't calculate offset twice
      kvm, pci: Fix unaligned PCI accesses
      kvm: Kill virtio debugging code
      kvm: Add KVM ABI headers
      Merge branch 'master' of git://github.com/cyrillos/vm
      kvm: Fix unaligned PCI_CONFIG_ADDRESS accesses
      kvm: Extract virtio-blk driver to separate file
      kvm: Update .gitignore to ignore tags
      kvm: Add port range to ioport__register()
      kvm: Add virtio PCI ioport handler stubs
      kvm: Fail virtio blk ioports by default
      kvm: Virtio block device emulation
      kvm: Fix kernel loading error messages
      kvm: Fix virtio block PCI device IRQ configuration
      kvm: Implement "host features" for virtio blk device
      kvm: Cleanup virtio block device I/O functions
      kvm: Don't use VIRTIO_BLK_F_SEG_MAX in the hypervisor
      kvm: Remove bogus #include directive
      Revert "kvm: Fix virtio block PCI device IRQ configuration"
      kvm: Implement virtio blk device config space
      kvm: Make virtio block device read-only
      kvm: Add ->queue_selector and ->queue_pfn to struct device
      kvm: Implement virtqueues for virtio block device
      kvm: Implement virtio blk device vring lookup
      kvm: Kill stale interrupt configuration comment
      kvm: Add support for disk images
      kvm: Use disk image API from virtio block device
      kvm: Cleanup disk geometry setup code
      kvm: Introduce a list of known BUGS
      Merge branch 'master' of git://github.com/cyrillos/vm
      kvm: Enable virtio block device if disk image specified
      kvm: Improve kvm__init() error message
      kvm: Fail if user specifies a QCOW disk image
      kvm: Fix virtqueue ring index check
      kvm: Fix virtio block device support some more
      kvm: Support MSR register for serial console
      kvm: Kill debug logging from blk-virtio.c
      kvm: Implement virtio block device write support
      kvm: Redirect serial console to stdout, not stderr
      kvm: Improve 8250 serial console support
      kvm: Fix magic numbers in 8250 support
      kvm,serial: Enable THRI bit in IIR register
      kvm: Implement support interrupt injection
      kvm: Rename early_printk.c to 8250-serial.c
      kvm,8250: Inject interrupts to guest
      kvm: Use serial console by default
      kvm,8250: Implement serial input support
      kvm: Put terminal in canonical mode
      Merge branch 'master' of /home/penberg/kvm into kvm/core
      kvm: Use disk name for mounting root
      kvm: Improve 8250 serial console interrupt handling
      kvm: Support for more than one serial ttys
      kvm,8250: Make ttyS1 and ttyS2 disabled
      kvm,8250: Fix "too much work for irq4" problems
      kvm,8250: Fix ->counter clearing
      kvm,8250: Cleanup receive emulation
      kvm,8250: Implement missing register emulation
      kvm,serial: Implement 16550A FIFO support
      kvm: Cleanup interrupt timer logic
      Revert "kvm,virtio: add scatter-gather support"
      kvm: Remove duplicate headers
      kvm tools: Cleanup termios handling
      kvm,8250: Fix device initial state
      kvm tools: Cleanup virtqueue handling
      tools/kvm: Exit gracefully upon KVM_EXIT_SHUTDOWN
      kvm tools, 8250: Don't set the UART_LSR_OE bit
      kvm tools: Fix large disk images on 32-bit
      kvm tools: Fix E820 map on x86-64
      kvm tools: Fix required boot protocol version
      tools kvm: Fix missing ARCH define on 32-bit in Makefile
      kvm tools: Cleanup strstr() in expression
      kvm tools: Cleanup virtio block device configuration
      kvm tools: Cleanup disk image code
      kvm tools: Drop hard-coded 'nosmp' kernel parameter
      kvm tools: Use STDIN_FILENO instead of fileno(stdin)
      kvm tools: Use pread() and pwrite() in disk-image.c
      kvm tools: Don't exit() on SIGQUIT
      kvm tools: Send SysRq-P to guest kernel on SIGQUIT
      Merge branch 'kvm/gitish' into kvm/core
      kvm tools: Fix .gitignore after Gitification merge
      kvm tools: Cleanup virtio_blk_do_io_request I/O error handling
      kvm tools: Make code mostly checkpatch clean
      kvm tools: Introduce KVM VCPU data structure
      kvm tools: Make 8250 code thread-safe
      kvm tools: Make virtio block device code thread-safe
      kvm tools: Extract kvm_cpu__start() function
      kvm tools: Move CPU initialization to kvm_cpu__start()
      kvm tools: Fix pthread mutex error checks
      kvm tools: Use per-VCPU threads for execution
      kvm tools: Fix 'kill -3' to send SysRq-P to the guest
      kvm tools: Use mutex_lock() and mutex_unlock() wrappers
      kvm tools: Remove the BUGS file
      kvm tools: Use ioport__register() for legacy devices
      Revert "kvm tools: Use mmap by default for disk images"
      kvm tools: Use host kernel image by default
      kvm tools: Don't override kernel image passed by user
      kvm tools: Add read-only support for block devices
      kvm tools: Cleanup qcow1_read_sector() function
      kvm tools: Untangle qcow1_read_sector() function
      kvm tools: Kill redundant assignment in qcow1_read_cluster()
      kvm tools: Fix qcow1_read_cluster() return value on error
      kvm tools: Add read-only support for QCOW2 images
      kvm tools: Show KVM state on SIGQUIT
      kvm tools: Fix disk image double-free on KVM panic
      kvm tools: Emulate RTC to fix system time in guests
      Revert "kvm tools: Use threadpool for virtio-net"
      kvm tools: Fix virtio rng build breakage
      kvm tools: Move virtio drivers under virtio directory
      kvm tools: Cleanup virtio code some more
      kvm tools: Scale guest RAM size by CPU count
      kvm tools: Limit CPU count by KVM_CAP_NR_VCPUS
      kvm tools: Don't use all of host RAM for guests by default
      kvm tools: Warn if guest RAM size exceeds host RAM size
      kvm tools: Fix 'kill -3' hangs
      kvm tools: QCOW code cleanups
      kvm tools: Use '-c' for '--cpus', not '--console'
      kvm tools: Print out important command line options at startup
      kvm tools: Fix read-only support in QCOW
      kvm tools: Fix typo in converting bytes to MBs
      kvm tools: Lookup symbol based on RIP for 'kill -3'
      kvm tools: Fix includes for preadv/pwritev
      kvm tools: Make host_ram_size() more robust
      kvm tools: Fail if passed initrd is not really an initrd
      kvm tools: Move hardware drivers to hw directory
      kvm tools, serial: Register 0x2e8 ioport
      kvm tools: Don't register dummy ops for serial ports
      kvm tools: Drop dummy PCI ioport registrations
      kvm tools: Code cleanups to hw/vesa.c
      kvm tools: Use more readable name for ioport mutex
      kvm tools: Fix up common QCOW function names
      kvm tools: Add 'kvm debug' command
      kvm tools: Use constants for i8042 register numbers
      kvm tools, i8042: Sort status register bits
      kmv tools, i8042: Use kernel status register bit names
      kvm tools, i8042: Use kernel command names
      kvm tools, i8042: Fix device init failure
      kvm tools, ui: Add framebuffer infrastructure
      kvm tools, ui: Move VNC specific framebuffer code to ui/vnc.c
      kvm tools, ui: Add support for SDL framebuffer output target
      kvm tools, vesa: Cleanup code in bios/int10.c
      kvm tools, vesa: Fix 'ah' access in int10_vesa()
      kvm tools, vesa: Use guest-mapped memory for framebuffer
      kvm tools: Kill libvnc dependency from hw/i8042.c
      kvm tools, ui: Add simple keyboard support to SDL UI
      kvm, ui: Kill fb_write() function
      kvm tools: Makefile cleanups
      kvm tools: Add WERROR to Makefile for disabling -Werror
      kvm tools: Fix 'kvm run' on 32-bit machines with >2 GB of RAM
      kvm tools, qcow: Use fdatasync() instead of sync_file_range()
      kvm run: Add 'panic=1' to default kernel options
      Merge commit 'v3.0-rc5' into kvm/core
      kvm tools: Fix guest single-stepping setup
      kvm tools: Don't sort command-list.txt for help text
      kvm tools: Add KVMTOOLS-VERSION-FILE to .gitignore
      kvm tools, qcow: Rename struct qcow_l2_cache to struct qcow_l2_table
      kvm tools, qcow: Use 'struct qcow_l2_table' instead of untyped array
      kvm tools, qcow: Fix locking issues
      kvm tools, qcow: Introduce qcow_disk_flush()
      kvm tools, qcow: Delayed L1 table writeout
      kvm tools, qcow: Don't fdatasync() L2 table writeout
      kvm tools, qcow: Use big endian order for L2 table entries
      kvm tools, qcow: Delayed L2 table writeout
      kvm tools, qcow: Flush only dirty L2 tables
      kvm tools, qcow: I/O error on compressed sectors
      kvm tools: Use writev() in xwritev()
      kvm tools, qcow: Fix copy-on-write image corruption
      kvm tools: Rename 'struct qcow_table' to 'struct qcow_l1_table'
      kvm tools, qcow: Unify L1 and L2 variable names
      kvm tools: Fix formatting in include/kvm/qcow.h
      kvm tools, qcow: Move L2 cache to 'struct qcow_l1_table'
      kvm tools, qcow: Rename L2 table lookup functions
      kvm tools, qcow: Force read-only mode for QCOW images
      kvm tools, 9p: Fix init error handling
      kvm tools, qcow: Add support for writing to zero refcount clusters
      kvm tools: Boot to host /bin/sh via 9p by default
      kvm tools: Enable kernel DHCP autoconf by default
      Revert "kvm tools: Enable kernel DHCP autoconf by default"
      kvm tools: Improve 'kvm list' output
      kvm tool: Fix builtin command usage printouts
      kvm tools: Improve 'kvm version' output
      kvm tools: Stop guest if SDL window is closed
      kvm tools: Organize includes in builtin-run.c
      kvm tools, bios: Setup CF after returning from interrupt handler
      kvm tools, bios: Rename struct int10_args to struct biosregs
      kvm tools, bios: Add macros for BIOS registers
      kvm tools, bios: Add EIP and EFLAGS to 'struct biosregs'
      kvm tools, bios: Use struct biosregs in E820 code
      kvm tools, bios: Move CF clearing to e820_query_map()
      kvm tools, bios: Convert int15 code to C
      kvm tools, bios: Set CF for non-supported services
      kvm tools, bios: Rename bios.S to entry.S
      Merge branch 'kvm/bios' into kvm/core
      kvm tool, sdl: Set window caption
      kvm tools: Add entry to MAINTAINERS file
      kvm tools: Introduce 'kvm setup' command
      kvm tools, setup: Create /tmp in guest filesystems
      kvm tools: Fix up build instructions on Fedora
      kvm tools: NULL-terminate init env
      kvm tools: Move segment_to_flat() to kvm/segment.h
      kvm tools: Use HOME_DIR and KVM_PID_FILE_PATH from <kvm/kvm.h>
      kvm tools: Use kvm__get_dir() helper function
      kvm tools, bios: Fix BIOS to kernel memory copy
      kvm tools: Disable stack protector for BIOS code
      kvm tools, bios: Don't include glibc headers
      kvm tools: Kill double slash from kvm__get_dir()
      kvm tools: Improve "kvm setup" info and error messages
      kvm tools: Improve "kvm list" default output
      kvm tools: Fix 'kvm run' when run the first time
      kvm tools: Fix kvm__set_dir() to include trailing slash
      kvm tools, rtc: Introduce 'struct rtc_device'
      kvm tools, rtc: Add RTC register names
      kvm tools, rtc: Implement RTC_DAY_OF_WEEK
      kvm tools, rtc: Nonvolatile BIOS memory support
      kvm tools: Fix kvm/barrier.h build breakage
      Merge branch 'kvmtool/sandbox' into kvmtool/next
      kvm tools: Call executable 'lkvm' and add 'vm' alias
      kvm tools: Fix use after free during shutdown
      kvm tools: Free vcpu array on shutdown
      kvm tools, 9p: Fix memory leak in virtio_p9_walk()
      kvm tools, 9p: Fix memory leak in virtio_9p_attach()
      kvm tools: Remove bogus init printout
      kvm tools: Fix <linux/msi.h> kobject build breakage
      Merge commit 'v3.2' into kvmtool/next
      kvm tools, bios: Don't specify ELF PHDRs
      kvm tools, x86: Fix use after free in irq__exit()
      kvm tools: Fix another use-after-free in shutdown sequence
      kvm tools: Use pr_debug() for symbol lookup init failure
      kvm tools, x86: Fix munmap() size in kvm__arch_delete_ram()
      kvm tools: Fix "vm setup" help text
      kvm tools, seabios: Add "--firmware" option to "vm run"
      kvm tools, seabios: Add support for SeaBIOS debugging output
      kvm tools: Make 'vm sandbox' more user-friendly
      kvm tools, sandbox: Fix running guest commands
      kvm tools: Fix realpath() error checking
      Merge commit 'v3.4-rc1' into kvmtool/next
      kvm tools: Fix build breakage due to <linux/stddef.h> changes
      Merge commit 'v3.5' into kvmtool/next
      kvm tools: Add 'install' target to Makefile
      kvm tools: Drop lchown() calls from 9p

Prasad Joshi (29):
      kvm tools: Fix KVM problem on SuSe 2.6.37 kernel
      kvm tools: Generate list of common kvm tool commands
      kvm tools: Use code from perf for argument processing
      kvm tools: Provide the basic Gitish framework
      kvm tools: Use the Gitish freamwork to run the virtual machine
      kvm tools: Fix a possible segfault if raw_image__probe returns NULL
      kvm tools: Avoid using disk_image->priv member in disk_image__new()
      kvm tools: add a close method for raw_image_ro_mmap_ops
      kvm tools: Add QCOW version 1 read-only support
      kvm tools: Use the readily built kernel with 'kvm run' if not specified explicitly
      kvm tools: Fix function names in qcow.c
      kvm tools: Avoid byte-order conversion during each read operation
      kvm tools: Free l1_table in qcow1_disk_close() and in error path of qcow1_probe()
      kvm tool: Remove the __stringify*() definition from util.h
      kvm tool: Change the type of QCOW table index and offset variables to u64
      kvm tools: check the cluster boundary in the qcow read code
      kvm tools: Correct a variable naming spelling mistake
      kvm tools: Use the root partition of the host to boot the guest machine
      kvm tools: check read permission before using the root partition of the host to boot VM
      kvm tools: display appropriate error message when default kernel image could not be found
      kvm tools: fix a memory leak in qcow2_read_header
      kvm tools: Add QCOW write support
      kvm tools: Add VIRTIO_BLK_T_FLUSH feature to handle flush operation from VM
      kvm tools: Add a wrapper function to open disk images
      kvm tools: Close the disk images after the guest shuts down
      kvm tools: Add a wrapper function to initialize all virtio block devices
      kvm tools: Release memory allocated during virtio block initialization
      kvm tools: Add QCOW level2 caching support
      kvm tools: Add IO delay option

Sasha Levin (338):
      kvm tools: Free memory and FDs on exit
      kvm tools: Fix input hang when compiling without optimization
      kvm tools: Close kernel FD after loading it into memory
      kvm tools: Use mmap by default for disk images
      kvm tools: Add option to load disk image read only
      kvm tools: Add OPT_GROUP to cmdline parser
      kvm tools: Arrange cmdline help menu
      kvm tools: Set up tun interface using ioctls
      kvm tools: Make host side IP configurable
      kvm tools: Organize net parameters into struct
      kvm tools: Enable network by default
      kvm tools: Add option to specify guest MAC
      kvm tools: Rename raw_image__close_sector_ro_mmap
      kvm tools: Fix leak in QCOW
      kvm tools: Add scatter-gather variants of IO functions
      kvm tools: Add scatter-gather support for disk images
      kvm tools: Rename _sg to _iov and remove dead code
      kvm tools: Fix iov shifting
      kvm tools: Fix possible leak in disk_image
      kvm tools: Use threading for virtio block devices
      kvm tools: Use mmap to allocate guest RAM
      kvm tools: Fix possible leak in qcow
      kvm tools: Prevent duplicate definitions of ALIGN
      kvm tools: Add kernel headers required for using list
      kvm tools: Introduce generic I/O thread pool
      kvm tools: Use threadpool for virtio-blk
      kvm tools: Use threadpool for virtio-console
      kvm tools: Use threadpool for virtio-net
      kvm tools: Modify thread pool API
      kvm tools: Lock job_mutex before signalling
      kvm tools: Introduce virtio-rng
      kvm tools: Add cmdline switch to enable virtio-rng
      kvm tools: Drop ALIGN from bios.h
      kvm tools: Fix virt_queue__set_used_elem
      kvm tools: Move disk_image into virtio-blk
      kvm tools: Add support for multiple virtio-blk
      kvm tools: Add cmdline options for loading multiple images
      kvm tools: Abolishment of uint*_t types
      kvm tools: virtio-blk code cleanup
      kvm tools: virtio-console code cleanup
      kvm tools: virtio-net code cleanup
      kvm tools: virtio-rng code cleanup
      kvm tools: Fix loading root device as image
      kvm tools: Enable SMP support
      kvm tools: Simplify search for root device
      kvm tools: Introduce IRQ registry
      kvm tools: Dynamically add devices when creating mptable
      kvm tools: Convert virtio devices to use IRQ registry
      kvm tools: Rename pci_device to pci_hdr for clarity
      kvm tools: Add missing space after kernel params
      kvm tools: Add memory gap for larger RAM sizes
      kvm tools: Prevent PFN wraparound
      kvm tools: Use definitions from kernel headers
      kvm tools: Rename 'self' variables
      kvm tools: Use constants for commonly used mmap flags
      kvm tools: Add boot test to checks
      kvm tools: Return correct values from disk IOV functions
      kvm tools: Add interval red-black tree helper
      kvm tools: Add MMIO address mapper
      kvm tools: Use virtio IDs from <linux/virtio_ids.h>
      kvm tools: Exit properly on SMP guests
      kvm tools: Default guest cpu count to host cpu count
      kvm tools: Copy net/9p/9p.h
      kvm tools: Add virtio-9p
      kvm tools: Cleanup e820 code
      kvm tools: Fix rbtree-interval balancing
      kvm tools: Modify ioport to use interval rbtree
      kvm tools: Add optional parameter used in ioport callbacks
      kvm tools: Add basic ioport dynamic allocation
      kvm tools: Use ioport context to control blk devices
      kvm tools: Add support for multiple virtio-rng devices
      kvm tools: Use dynamic IO port allocation in vesa driver
      kvm tools: Use dynamic IO port allocation in 9p driver
      kvm tools: Use dynamic IO port allocation in virtio-console
      kvm tools: Use dynamic IO port allocation in virtio-net
      kvm tools: Prevent double assignment of guest memory info
      kvm tools: Exit VCPU thread only when SIGKVMEXIT is received
      kvm tools: Add ioeventfd support
      kvm tools: Use ioeventfd in virtio-blk
      kvm tools: Use ioeventfd in virtio-net
      kvm tools: Use ioeventfd in virtio-rng
      kvm tools: Use correct value for user signal base
      kvm tools: Remove wrong global definition of kvm
      kvm tools: Add APIs to allow pausing guests
      kvm tools: Pause/resume guest using SIGUSR2
      kvm tools: Add a brlock
      kvm tools: Add rwlock wrapper
      kvm tools: Add debug mode to brlock
      kvm tools: Use brlock in MMIO and IOPORT
      kvm tools: Use vesa reserved space for strings and modes
      kvm tools: Add MMIO coalescing support
      kvm tools: Fix some SDL keyboard translations
      kvm tools: Use double buffering with SDL
      kvm tools: Add 'kvm pause' command
      kvm tools: Signal only one thread when injecting console interrupts
      kvm tools: Fix attempt to free mmaped memory
      kvm tools: Implement keyboard reset method
      kvm tools: Use ioeventfd in virtio-9p
      kvm tools: Don't dynamically allocate threadpool jobs
      kvm tools: Process virtio-blk requests in parallel
      kvm tools: Allow giving instance names
      kvm tools: Provide instance name when running 'kvm debug'
      kvm tools: Provide instance name when running 'kvm pause'
      kvm tools: Add virtio-balloon device
      kvm tools: Advise memory allocated for guest RAM as KSM mergable
      kvm tools: Add 'kvm balloon' command
      kvm tools: Stop VCPUs before freeing struct kvm
      kvm tools: Fix home dir resolution
      kvm tools: Give guest instances default name
      kvm tools: Add instance enumerator
      kvm tools: Add 'kvm list' command
      kvm tools: Allow pausing and debugging all running instances
      kvm tools: Export kvm__remove_pidfile
      kvm tools: Clean ghost pid files in 'kvm list'
      kvm tools: Add 'kvm version' command
      kvm tools: Properly add 'kvm list' to command list
      kvm tools: Properly add 'kvm debug' to command list
      kvm tools: Update 'kvm pause' documentation
      kvm tools: Properly add 'kvm balloon' to command list
      kvm tools: Rename command source files
      kvm tools: Rename debug options under 'kvm run'
      kvm tools: Fix leaked descriptors
      kvm tools: Update README
      kvm tools: Implement VIRTIO_BLK_T_GET_ID
      kvm tools: Update max VCPU limit
      kvm tools: Fix warning on 32bit
      kvm tools: Set hardcoded MAC to local administered
      kvm tools: Use GSI routing
      kvm tools: Fix PCI probing
      kvm tools: Add a void ptr to be passed to mmio callback
      kvm tools: Implement MSI-X for virtio-rng
      kvm tools: Add support for 9p2000.u
      kvm tools: Use '-d' to boot a directory as a rootfs
      kvm tools: Add 'kvm stop'
      kvm tools: Remove version file on 'make clean'
      kvm tools: Fix PCI masking on probes
      kvm tools: Split 'kvm pause' and add 'kvm resume'
      kvm tools: Change method of retrieving process name
      kvm tools: Use correct size for VESA memory bar
      kvm tools: Add kvm__trigger_irq()
      kvm tools: Add MSI-X support to virtio-net
      kvm tools: Make keyboard termination go through regular termination path
      kvm tools: Fix IRQ mapping
      kvm tools: Speed up PS/2 mouse detection
      kvm tools: Use correct offset for virtio-net config space
      kvm tools: Missing braces in BAR index calculation
      kvm tools: Print version when running 'kvm --version'
      kvm tools: Connect existing command helpers to 'kvm help'
      kvm tools: Improve 'kvm stop' parameters
      kvm tools: Improve 'kvm resume' parameters
      kvm tools: Improve 'kvm pause' parameters
      kvm tools: Improve 'kvm debug' parameters
      kvm tools: Improve 'kvm balloon' parameters
      kvm tools: Fix wrong kill() PID in commands
      kvm tools: Add 'kvm stat' command
      kvm tools: Use correct data type for pid
      kvm tools: Guest kernel compatability
      kvm tools: Add guest compatability warning to virtio-rng
      kvm tools: Add guest compatability warning to virtio-blk
      kvm tools: Add guest compatability warning to virtio-9p
      kvm tools: Add guest compatability warning to virtio-net
      kvm tools: Add guest compatability warning to virtio-console
      kvm tools: Add guest compatability warning to virtio-balloon
      kvm tools: Add helper to retrieve the field used in virtio config space
      kvm tools: Fix offset calculation for config space and MSI-X
      kvm tools: Separate virtio-pci layer
      kvm tools: Separate virtio-pci layer out of virtio-rng
      kvm tools: Separate virtio-pci layer out of virtio-net
      kvm tools: Separate virtio-pci layer out of virtio-balloon
      kvm tools: Separate virtio-pci layer out of virtio-9p
      kvm tools: Separate virtio-pci layer out of virtio-blk
      kvm tools: Move ioeventfd registration to virtio-pci
      kvm tools: Separate pci layer out of virtio-console
      kvm tools: MSI-X fixes
      kvm tools: Add ivshmem device
      kvm tools: Remove unconditional warning in ivshmem
      kvm tools: Fix 32bit warnings
      kvm tools: Attach default 'root=' only if required
      kvm tools: Teach 'run' to handle guestfs
      kvm tools: Add guestfs network autoconfiguration
      kvm tools: Modify 'kvm run' to use virt fs
      kvm tools: Fix compat message formatting
      kvm tools: Fix 32bit build errors
      kvm tools: Use kernel dhcp for network autoconfiguration
      kvm tools: Don't use i8042 AUX port
      kvm tools: Allow remapping guest TTY into host PTS
      kvm tools: Don't copy network autoconfiguration script
      kvm tools: Use host's resolv.conf within the guest
      kvm tools: Use correct subsys id in virtio-pci
      kvm tools: Fix INTx handling
      kvm tools: Document steps to debug kernel using KGDB
      kvm tools: Set active console before running /bin/sh
      kvm tools: Support multiple net devices
      kvm tools: Fix spelling mistake
      kvm tools: Use compat message per device instead of per instance
      kvm tools: Improve compat message
      kvm tools: Add basic help when starting 'kvm' without args
      kvm tools: Add help and info messages to 'kvm setup'
      kvm tools: Modify 'kvm setup' parameters
      kvm tools: Add option to list rootfs in 'kvm list'
      kvm tools: Enable fast string operations
      kvm tools: Switch to using UNIX sockets instead of signals
      kvm tools: Move memory stat print to client
      kvm tools: Allow piping debug output to file descriptor
      kvm tools: Simplify msi message handling
      kvm tools: Add method to stop ipc thread
      kvm tools: Fix SDL exit on window close
      kvm tools: Avoid overwriting socket files with same name
      kvm tools: Handle only relevant events in epoll
      kvm tools: Cleanup ghost socket files
      kvm tools: Switch to using an enum for disk image types
      kvm tools: Remove the non-iov interface from disk image ops
      kvm tools: Modify disk ops usage
      kvm tools: Modify behaviour on missing ops ptr
      kvm tools: Add optional callback on disk op completion
      kvm tools: Remove qcow nowrite function
      kvm tools: Split io request from completion
      kvm tools: Hook virtio-blk completion to disk op completion
      kvm tools: Add aio read write functions
      kvm tools: Use native vectored AIO in virtio-blk
      config: Add 'make kvmconfig'
      kconfig: Update 'make kvmconfig'
      kvm tools: Add missing 9p remove handler
      kvm tools: Add missing 9p rename handler
      kvm tools: Remove async flag from QCOW
      kvm tools: Use correct config defines
      kvm tools: Clean up remove/rename in 9p
      kvm tools: Create /etc/passwd in shared rootfs
      kvm tools: Add abstract virtio transport layer
      kvm tools: Fix parameter to virtio device features config
      kvm tools: Use IRQ line 5+ for devices
      kvm tools: Add optional callbacks for VQs
      kvm tools: Add vhost-net support
      kvm tools: Add '--no-dhcp' to disable kernel DHCP
      kvm tools: Prepare support for VIRTIO_RING_F_EVENT_IDX
      kvm tools: Support event idx in virtio-net
      kvm tools: Add event idx support to virtio-blk
      kvm tools: Support virtio indirect buffers
      kvm tools: Remove double 'init=' kernel param
      kvm tools: Ninja out support for VIRTIO_F_FEATURES_HIGH
      kvm tools: Zero out event before calling epoll_ctl()
      kvm tools: Initialize irq_routing before using it
      kvm tools: Link ld.so.conf to the file on the host
      kvm tools: Document virtio-console usage
      kvm tools: Allow the user to pass a FD to use as a TAP device
      kvm tools: Fix serial port probing
      kvm tools: Don't use 64bit BARs
      kvm tools: Free up the MSI-X PBA BAR
      kvm tools: Split custom rootfs init into two stages
      kvm tools: Allow easily sandboxing applications within a guest
      kvm tools: Ignore parameters after dashdash in 'kvm run'
      kvm tools: Add 'kvm sandbox'
      kvm tools: Add NMI ability to 'kvm debug'
      kvm tools: Clean up LINT assignment code
      kvm tools: Clean up 'kvm debug'
      kvm tools: Don't always coalesce MMIOs
      kvm tools: Fix MMIO ordering problem cause due to coalescing
      kvm tools: Add kvm__has_cap() to check whether a cap is available on the host
      kvm tools: Don't use ioeventfds if no KVM_CAP_IOEVENTFD
      kvm tools: Use kvm__supports_extension instead of kvm__has_cap
      Revert "kvm tools: Add kvm__has_cap() to check whether a cap is available on the host"
      kvm tools: Fix rootfs name resolving when specified with image
      kvm tools: Trivial cleanup
      kvm tools: Fix 'make kvmconfig'
      kvm tools: Don't panic guest when exiting from custom rootfs
      kvm tool: Exit init only when /bin/sh itself stops
      kvm tools: Improve 'lkvm sandbox' syntax
      kvm tools: Split kvm_cmd_run into init, work and exit
      kvm tools: Fixes for symbol resolving module
      kvm tools: Fixes for IRQ module
      kvm tools: Fixes for UI modules
      kvm tools: Fixes for ioport module
      kvm tools: Fixes for ioeventfd module
      kvm tools: Fixes for serial module
      kvm tools: Fixes for mptable module
      kvm tools: Fixes for PCI module
      kvm tools: Fixes for rtc module
      kvm tools: Fixes for disk image module
      kvm tools: Fixes for virtio module
      kvm tools: fix sigsegv in irq__exit
      kvm tools: use bitwise 'and' in kvm-ipc
      kvm tools: use accessor function for virtio-9p FIDs
      kvm tools: increase amount of virtio-9p FIDs
      kvm tools: support 9p flush command
      kvm tools: set the HYPERVISOR flag in cpuid
      kvm tools: dynamically allocate p9 fids
      kvm tools: support injecting arbitrary sysrqs
      kvm tools: remove unused field from virtio-blk
      kvm tools: use correct error value for virtio-9p RLERROR
      kvm tools: prevent guest softlockup errors when pausing
      kvm tools: don't bother tracking is_dir
      kvm tools: clean garbage from ioeventfd code
      kvm tools: Use the new KVM_SIGNAL_MSI ioctl to inject interrupts directly.
      kvm tools: fix warnings in virtio-blk
      kvm tools: enable LTO
      kvm tools: 9p don't nuke fids on attach
      kvm tools: simplify virtio config handling
      kvm tools: add HOME env var to hostfs
      kvm tools: introduce kvm_config to store instance-specific config options
      kvm tools: generate command line options dynamically
      kvm tools: split struct kvm into arch specific part
      kvm tools: move kvm_config into struct kvm
      kvm tools: remove redundancy between kvm_config and kvm
      kvm tools: move ioport_debug into struct kvm_config
      kvm tools: move mmio_debug into struct kvm_config
      kvm tools: move active_console into struct kvm_config
      kvm tools: add private ptr to option parser
      kvm tools: disk image related cleanup
      kvm tools: move nrcpus into struct kvm_config
      kvm tools: move kvm_cpus into struct kvm
      kvm tools: improve framebuffer manager initialization
      kvm tools: improve term init/exit functions
      kvm tools: threadpool exit routine
      kvm tools: timer cleanup
      kvm tools: virtio-console init/exit
      kvm tools: virtio-rng init/exit
      kvm tools: virtio-bln init/exit
      kvm tools: pci-shmem init-exit
      kvm tools: virtio-net init/exit
      kvm tools: kvm-ipc cleanup
      kvm tools: kbd initialization check
      kvm tools: ui improvements
      kvm tools: kernel load/firmware cleanup
      kvm tools: ioport arch init
      kvm tools: ram init
      kvm tools: move the rest of the config initializations
      kvm tools: virtio-9p cleanup
      kvm tools: initialize the threadpool job iterator before using
      kvm tools: fix build optimization
      kvm tools: add init/exit automatic calls
      kvm tools: use init/exit where possible
      kvm tools: pass kvm ptr directly to timer injection
      kvm tools: remove global kvm object
      kvm tools: fix SMP
      kvm tools: fix SDL build error when libsdl isn't installed
      kvm tools: don't die if sdl wasn't compiled in and we don't try using it
      kvm tools: support build-time checks
      kvm tools: don't exit on debug ioport write

Thomas Gleixner (5):
      kvm tool: serial: Cleanup coding style
      kvm tool: serial: Simplify switch cases
      kvm tool: serial: Fix interrupt handling
      kvm tools: serial: Make it work with non rt guests as well
      kvm tool: Implement a serial FIFO emulation

Wanlong Gao (7):
      kvm tools: Don't add the -Wunused-result flag
      kvm tools: prevent the redefined error
      kvm tools: change the binary name kvm to lkvm in Documentation
      kvm tools: change the binary name from kvm to lkvm in README
      kvm tools: change the binary name from kvm to lkvm for commands' usage
      kvm tools: change the binary name from kvm to lkvm in print message
      kvm tools: cleanup useless arguments in kvm__arch_init

Xiao Guangrong (2):
      kvm tools: fix repeated io emulation
      kvm tools: remove count in io emulation callbacks

Xiaochen Wang (1):
      kvm tools: fix a typo in x86/bios.c

Yang Bai (5):
      kvm tools: Stop init if check_extensions failed
      kvm tools: unite the error handle in kvm__init
      kvm tools: if kvm_ipc__start failed, return negative
      kvm tools: ensure kvm_ipc__register_handler success
      kvm tools: Add guest/init_stage2 to .gitignore

 MAINTAINERS                                  |    8 +
 arch/x86/Kconfig                             |   31 +
 scripts/kconfig/Makefile                     |    7 +-
 tools/kvm/.gitignore                         |   12 +
 tools/kvm/CREDITS-Git                        |   30 +
 tools/kvm/Documentation/kernel-debugging.txt |   15 +
 tools/kvm/Documentation/kvm-balloon.txt      |   24 +
 tools/kvm/Documentation/kvm-debug.txt        |   16 +
 tools/kvm/Documentation/kvm-list.txt         |   16 +
 tools/kvm/Documentation/kvm-pause.txt        |   16 +
 tools/kvm/Documentation/kvm-resume.txt       |   16 +
 tools/kvm/Documentation/kvm-run.txt          |   62 +
 tools/kvm/Documentation/kvm-sandbox.txt      |   16 +
 tools/kvm/Documentation/kvm-setup.txt        |   15 +
 tools/kvm/Documentation/kvm-stat.txt         |   19 +
 tools/kvm/Documentation/kvm-stop.txt         |   16 +
 tools/kvm/Documentation/kvm-version.txt      |   21 +
 tools/kvm/Documentation/virtio-console.txt   |   41 +
 tools/kvm/Makefile                           |  457 ++++++++
 tools/kvm/README                             |  112 ++
 tools/kvm/builtin-balloon.c                  |   80 ++
 tools/kvm/builtin-debug.c                    |  110 ++
 tools/kvm/builtin-help.c                     |   63 ++
 tools/kvm/builtin-list.c                     |  149 +++
 tools/kvm/builtin-pause.c                    |   88 ++
 tools/kvm/builtin-resume.c                   |   88 ++
 tools/kvm/builtin-run.c                      |  697 ++++++++++++
 tools/kvm/builtin-sandbox.c                  |    9 +
 tools/kvm/builtin-setup.c                    |  262 +++++
 tools/kvm/builtin-stat.c                     |  127 +++
 tools/kvm/builtin-stop.c                     |   70 ++
 tools/kvm/builtin-version.c                  |   15 +
 tools/kvm/code16gcc.h                        |   15 +
 tools/kvm/command-list.txt                   |   15 +
 tools/kvm/config/feature-tests.mak           |  177 +++
 tools/kvm/config/utilities.mak               |  196 ++++
 tools/kvm/disk/blk.c                         |   76 ++
 tools/kvm/disk/core.c                        |  354 ++++++
 tools/kvm/disk/qcow.c                        | 1529 ++++++++++++++++++++++++++
 tools/kvm/disk/raw.c                         |  141 +++
 tools/kvm/framebuffer.c                      |   80 ++
 tools/kvm/guest/init.c                       |   72 ++
 tools/kvm/guest_compat.c                     |   99 ++
 tools/kvm/hw/i8042.c                         |  355 ++++++
 tools/kvm/hw/pci-shmem.c                     |  405 +++++++
 tools/kvm/hw/rtc.c                           |  139 +++
 tools/kvm/hw/serial.c                        |  452 ++++++++
 tools/kvm/hw/vesa.c                          |   89 ++
 tools/kvm/include/asm/hweight.h              |    8 +
 tools/kvm/include/bios/memcpy.h              |    9 +
 tools/kvm/include/kvm/8250-serial.h          |   11 +
 tools/kvm/include/kvm/apic.h                 |   17 +
 tools/kvm/include/kvm/brlock.h               |   41 +
 tools/kvm/include/kvm/builtin-balloon.h      |    9 +
 tools/kvm/include/kvm/builtin-debug.h        |   20 +
 tools/kvm/include/kvm/builtin-help.h         |    6 +
 tools/kvm/include/kvm/builtin-list.h         |   10 +
 tools/kvm/include/kvm/builtin-pause.h        |    9 +
 tools/kvm/include/kvm/builtin-resume.h       |    9 +
 tools/kvm/include/kvm/builtin-run.h          |   11 +
 tools/kvm/include/kvm/builtin-sandbox.h      |    6 +
 tools/kvm/include/kvm/builtin-setup.h        |   11 +
 tools/kvm/include/kvm/builtin-stat.h         |    9 +
 tools/kvm/include/kvm/builtin-stop.h         |    9 +
 tools/kvm/include/kvm/builtin-version.h      |    6 +
 tools/kvm/include/kvm/compiler.h             |   10 +
 tools/kvm/include/kvm/disk-image.h           |   96 ++
 tools/kvm/include/kvm/e820.h                 |   13 +
 tools/kvm/include/kvm/framebuffer.h          |   36 +
 tools/kvm/include/kvm/guest_compat.h         |    9 +
 tools/kvm/include/kvm/i8042.h                |   12 +
 tools/kvm/include/kvm/ioeventfd.h            |   28 +
 tools/kvm/include/kvm/ioport.h               |   70 ++
 tools/kvm/include/kvm/irq.h                  |   33 +
 tools/kvm/include/kvm/kvm-cmd.h              |   17 +
 tools/kvm/include/kvm/kvm-config.h           |   60 +
 tools/kvm/include/kvm/kvm-cpu.h              |   26 +
 tools/kvm/include/kvm/kvm-ipc.h              |   26 +
 tools/kvm/include/kvm/kvm.h                  |  121 ++
 tools/kvm/include/kvm/msi.h                  |   10 +
 tools/kvm/include/kvm/mutex.h                |   33 +
 tools/kvm/include/kvm/parse-options.h        |  218 ++++
 tools/kvm/include/kvm/pci-shmem.h            |   32 +
 tools/kvm/include/kvm/pci.h                  |   95 ++
 tools/kvm/include/kvm/qcow.h                 |  133 +++
 tools/kvm/include/kvm/rbtree-interval.h      |   28 +
 tools/kvm/include/kvm/read-write.h           |   43 +
 tools/kvm/include/kvm/rtc.h                  |    9 +
 tools/kvm/include/kvm/rwsem.h                |   39 +
 tools/kvm/include/kvm/sdl.h                  |   28 +
 tools/kvm/include/kvm/segment.h              |   21 +
 tools/kvm/include/kvm/strbuf.h               |   20 +
 tools/kvm/include/kvm/symbol.h               |   30 +
 tools/kvm/include/kvm/term.h                 |   24 +
 tools/kvm/include/kvm/threadpool.h           |   38 +
 tools/kvm/include/kvm/types.h                |    7 +
 tools/kvm/include/kvm/uip.h                  |  360 ++++++
 tools/kvm/include/kvm/util-init.h            |   51 +
 tools/kvm/include/kvm/util.h                 |   97 ++
 tools/kvm/include/kvm/vesa.h                 |   18 +
 tools/kvm/include/kvm/virtio-9p.h            |   76 ++
 tools/kvm/include/kvm/virtio-balloon.h       |    9 +
 tools/kvm/include/kvm/virtio-blk.h           |   12 +
 tools/kvm/include/kvm/virtio-console.h       |   10 +
 tools/kvm/include/kvm/virtio-mmio.h          |   58 +
 tools/kvm/include/kvm/virtio-net.h           |   30 +
 tools/kvm/include/kvm/virtio-pci-dev.h       |   38 +
 tools/kvm/include/kvm/virtio-pci.h           |   49 +
 tools/kvm/include/kvm/virtio-rng.h           |    9 +
 tools/kvm/include/kvm/virtio-scsi.h          |   26 +
 tools/kvm/include/kvm/virtio.h               |  102 ++
 tools/kvm/include/kvm/vnc.h                  |   22 +
 tools/kvm/include/linux/bitops.h             |   33 +
 tools/kvm/include/linux/byteorder.h          |    7 +
 tools/kvm/include/linux/compiler.h           |   20 +
 tools/kvm/include/linux/kernel.h             |   39 +
 tools/kvm/include/linux/module.h             |    6 +
 tools/kvm/include/linux/prefetch.h           |    6 +
 tools/kvm/include/linux/stddef.h             |   16 +
 tools/kvm/include/linux/types.h              |   51 +
 tools/kvm/ioeventfd.c                        |  216 ++++
 tools/kvm/ioport.c                           |  198 ++++
 tools/kvm/kvm-cmd.c                          |   91 ++
 tools/kvm/kvm-cpu.c                          |  242 ++++
 tools/kvm/kvm-ipc.c                          |  498 +++++++++
 tools/kvm/kvm.c                              |  458 ++++++++
 tools/kvm/main.c                             |   19 +
 tools/kvm/mmio.c                             |  139 +++
 tools/kvm/net/uip/arp.c                      |   30 +
 tools/kvm/net/uip/buf.c                      |  114 ++
 tools/kvm/net/uip/core.c                     |  190 ++++
 tools/kvm/net/uip/csum.c                     |   92 ++
 tools/kvm/net/uip/dhcp.c                     |  202 ++++
 tools/kvm/net/uip/icmp.c                     |   29 +
 tools/kvm/net/uip/ipv4.c                     |   29 +
 tools/kvm/net/uip/tcp.c                      |  345 ++++++
 tools/kvm/net/uip/udp.c                      |  236 ++++
 tools/kvm/pci.c                              |  215 ++++
 tools/kvm/powerpc/boot.c                     |    8 +
 tools/kvm/powerpc/cpu_info.c                 |  195 ++++
 tools/kvm/powerpc/cpu_info.h                 |   42 +
 tools/kvm/powerpc/include/kvm/barrier.h      |    6 +
 tools/kvm/powerpc/include/kvm/kvm-arch.h     |   68 ++
 tools/kvm/powerpc/include/kvm/kvm-cpu-arch.h |   76 ++
 tools/kvm/powerpc/ioport.c                   |   18 +
 tools/kvm/powerpc/irq.c                      |   56 +
 tools/kvm/powerpc/kvm-cpu.c                  |  290 +++++
 tools/kvm/powerpc/kvm.c                      |  529 +++++++++
 tools/kvm/powerpc/spapr.h                    |   93 ++
 tools/kvm/powerpc/spapr_hcall.c              |  134 +++
 tools/kvm/powerpc/spapr_hvcons.c             |  108 ++
 tools/kvm/powerpc/spapr_hvcons.h             |   19 +
 tools/kvm/powerpc/spapr_pci.c                |  423 +++++++
 tools/kvm/powerpc/spapr_pci.h                |   57 +
 tools/kvm/powerpc/spapr_rtas.c               |  233 ++++
 tools/kvm/powerpc/xics.c                     |  522 +++++++++
 tools/kvm/powerpc/xics.h                     |   18 +
 tools/kvm/symbol.c                           |  133 +++
 tools/kvm/term.c                             |  171 +++
 tools/kvm/tests/Makefile                     |   19 +
 tools/kvm/tests/boot/Makefile                |   13 +
 tools/kvm/tests/boot/init.c                  |   11 +
 tools/kvm/tests/kernel/.gitignore            |    2 +
 tools/kvm/tests/kernel/Makefile              |   20 +
 tools/kvm/tests/kernel/README                |   16 +
 tools/kvm/tests/kernel/kernel.S              |    8 +
 tools/kvm/tests/pit/.gitignore               |    2 +
 tools/kvm/tests/pit/Makefile                 |   20 +
 tools/kvm/tests/pit/README                   |   16 +
 tools/kvm/tests/pit/tick.S                   |  101 ++
 tools/kvm/ui/sdl.c                           |  321 ++++++
 tools/kvm/ui/vnc.c                           |  248 +++++
 tools/kvm/util/KVMTOOLS-VERSION-GEN          |   40 +
 tools/kvm/util/generate-cmdlist.sh           |   23 +
 tools/kvm/util/init.c                        |   69 ++
 tools/kvm/util/kvm-ifup-vbr0                 |    6 +
 tools/kvm/util/parse-options.c               |  577 ++++++++++
 tools/kvm/util/rbtree-interval.c             |   89 ++
 tools/kvm/util/read-write.c                  |  354 ++++++
 tools/kvm/util/set_private_br.sh             |   51 +
 tools/kvm/util/strbuf.c                      |   62 +
 tools/kvm/util/threadpool.c                  |  173 +++
 tools/kvm/util/util.c                        |  133 +++
 tools/kvm/virtio/9p-pdu.c                    |  287 +++++
 tools/kvm/virtio/9p.c                        | 1432 ++++++++++++++++++++++++
 tools/kvm/virtio/balloon.c                   |  270 +++++
 tools/kvm/virtio/blk.c                       |  315 ++++++
 tools/kvm/virtio/console.c                   |  203 ++++
 tools/kvm/virtio/core.c                      |  233 ++++
 tools/kvm/virtio/mmio.c                      |  264 +++++
 tools/kvm/virtio/net.c                       |  670 +++++++++++
 tools/kvm/virtio/pci.c                       |  398 +++++++
 tools/kvm/virtio/rng.c                       |  193 ++++
 tools/kvm/virtio/scsi.c                      |  309 ++++++
 tools/kvm/x86/bios.c                         |  174 +++
 tools/kvm/x86/bios/.gitignore                |    3 +
 tools/kvm/x86/bios/bios-rom.S                |   12 +
 tools/kvm/x86/bios/e820.c                    |   72 ++
 tools/kvm/x86/bios/entry.S                   |   92 ++
 tools/kvm/x86/bios/gen-offsets.sh            |   14 +
 tools/kvm/x86/bios/int10.c                   |  110 ++
 tools/kvm/x86/bios/int15.c                   |   18 +
 tools/kvm/x86/bios/local.S                   |    7 +
 tools/kvm/x86/bios/macro.S                   |   25 +
 tools/kvm/x86/bios/memcpy.c                  |   23 +
 tools/kvm/x86/bios/rom.ld.S                  |   16 +
 tools/kvm/x86/boot.c                         |   41 +
 tools/kvm/x86/cpuid.c                        |   60 +
 tools/kvm/x86/include/kvm/assembly.h         |   24 +
 tools/kvm/x86/include/kvm/barrier.h          |   20 +
 tools/kvm/x86/include/kvm/bios-export.h      |   13 +
 tools/kvm/x86/include/kvm/bios.h             |   93 ++
 tools/kvm/x86/include/kvm/boot-protocol.h    |   16 +
 tools/kvm/x86/include/kvm/cpufeature.h       |   41 +
 tools/kvm/x86/include/kvm/interrupt.h        |   26 +
 tools/kvm/x86/include/kvm/kvm-arch.h         |   43 +
 tools/kvm/x86/include/kvm/kvm-cpu-arch.h     |   49 +
 tools/kvm/x86/include/kvm/mptable.h          |    9 +
 tools/kvm/x86/interrupt.c                    |   28 +
 tools/kvm/x86/ioport.c                       |   77 ++
 tools/kvm/x86/irq.c                          |  224 ++++
 tools/kvm/x86/kvm-cpu.c                      |  425 +++++++
 tools/kvm/x86/kvm.c                          |  362 ++++++
 tools/kvm/x86/mptable.c                      |  289 +++++
 224 files changed, 25508 insertions(+), 1 deletions(-)
 create mode 100644 tools/kvm/.gitignore
 create mode 100644 tools/kvm/CREDITS-Git
 create mode 100644 tools/kvm/Documentation/kernel-debugging.txt
 create mode 100644 tools/kvm/Documentation/kvm-balloon.txt
 create mode 100644 tools/kvm/Documentation/kvm-debug.txt
 create mode 100644 tools/kvm/Documentation/kvm-list.txt
 create mode 100644 tools/kvm/Documentation/kvm-pause.txt
 create mode 100644 tools/kvm/Documentation/kvm-resume.txt
 create mode 100644 tools/kvm/Documentation/kvm-run.txt
 create mode 100644 tools/kvm/Documentation/kvm-sandbox.txt
 create mode 100644 tools/kvm/Documentation/kvm-setup.txt
 create mode 100644 tools/kvm/Documentation/kvm-stat.txt
 create mode 100644 tools/kvm/Documentation/kvm-stop.txt
 create mode 100644 tools/kvm/Documentation/kvm-version.txt
 create mode 100644 tools/kvm/Documentation/virtio-console.txt
 create mode 100644 tools/kvm/Makefile
 create mode 100644 tools/kvm/README
 create mode 100644 tools/kvm/builtin-balloon.c
 create mode 100644 tools/kvm/builtin-debug.c
 create mode 100644 tools/kvm/builtin-help.c
 create mode 100644 tools/kvm/builtin-list.c
 create mode 100644 tools/kvm/builtin-pause.c
 create mode 100644 tools/kvm/builtin-resume.c
 create mode 100644 tools/kvm/builtin-run.c
 create mode 100644 tools/kvm/builtin-sandbox.c
 create mode 100644 tools/kvm/builtin-setup.c
 create mode 100644 tools/kvm/builtin-stat.c
 create mode 100644 tools/kvm/builtin-stop.c
 create mode 100644 tools/kvm/builtin-version.c
 create mode 100644 tools/kvm/code16gcc.h
 create mode 100644 tools/kvm/command-list.txt
 create mode 100644 tools/kvm/config/feature-tests.mak
 create mode 100644 tools/kvm/config/utilities.mak
 create mode 100644 tools/kvm/disk/blk.c
 create mode 100644 tools/kvm/disk/core.c
 create mode 100644 tools/kvm/disk/qcow.c
 create mode 100644 tools/kvm/disk/raw.c
 create mode 100644 tools/kvm/framebuffer.c
 create mode 100644 tools/kvm/guest/init.c
 create mode 100644 tools/kvm/guest_compat.c
 create mode 100644 tools/kvm/hw/i8042.c
 create mode 100644 tools/kvm/hw/pci-shmem.c
 create mode 100644 tools/kvm/hw/rtc.c
 create mode 100644 tools/kvm/hw/serial.c
 create mode 100644 tools/kvm/hw/vesa.c
 create mode 100644 tools/kvm/include/asm/hweight.h
 create mode 100644 tools/kvm/include/bios/memcpy.h
 create mode 100644 tools/kvm/include/kvm/8250-serial.h
 create mode 100644 tools/kvm/include/kvm/apic.h
 create mode 100644 tools/kvm/include/kvm/brlock.h
 create mode 100644 tools/kvm/include/kvm/builtin-balloon.h
 create mode 100644 tools/kvm/include/kvm/builtin-debug.h
 create mode 100644 tools/kvm/include/kvm/builtin-help.h
 create mode 100644 tools/kvm/include/kvm/builtin-list.h
 create mode 100644 tools/kvm/include/kvm/builtin-pause.h
 create mode 100644 tools/kvm/include/kvm/builtin-resume.h
 create mode 100644 tools/kvm/include/kvm/builtin-run.h
 create mode 100644 tools/kvm/include/kvm/builtin-sandbox.h
 create mode 100644 tools/kvm/include/kvm/builtin-setup.h
 create mode 100644 tools/kvm/include/kvm/builtin-stat.h
 create mode 100644 tools/kvm/include/kvm/builtin-stop.h
 create mode 100644 tools/kvm/include/kvm/builtin-version.h
 create mode 100644 tools/kvm/include/kvm/compiler.h
 create mode 100644 tools/kvm/include/kvm/disk-image.h
 create mode 100644 tools/kvm/include/kvm/e820.h
 create mode 100644 tools/kvm/include/kvm/framebuffer.h
 create mode 100644 tools/kvm/include/kvm/guest_compat.h
 create mode 100644 tools/kvm/include/kvm/i8042.h
 create mode 100644 tools/kvm/include/kvm/ioeventfd.h
 create mode 100644 tools/kvm/include/kvm/ioport.h
 create mode 100644 tools/kvm/include/kvm/irq.h
 create mode 100644 tools/kvm/include/kvm/kvm-cmd.h
 create mode 100644 tools/kvm/include/kvm/kvm-config.h
 create mode 100644 tools/kvm/include/kvm/kvm-cpu.h
 create mode 100644 tools/kvm/include/kvm/kvm-ipc.h
 create mode 100644 tools/kvm/include/kvm/kvm.h
 create mode 100644 tools/kvm/include/kvm/msi.h
 create mode 100644 tools/kvm/include/kvm/mutex.h
 create mode 100644 tools/kvm/include/kvm/parse-options.h
 create mode 100644 tools/kvm/include/kvm/pci-shmem.h
 create mode 100644 tools/kvm/include/kvm/pci.h
 create mode 100644 tools/kvm/include/kvm/qcow.h
 create mode 100644 tools/kvm/include/kvm/rbtree-interval.h
 create mode 100644 tools/kvm/include/kvm/read-write.h
 create mode 100644 tools/kvm/include/kvm/rtc.h
 create mode 100644 tools/kvm/include/kvm/rwsem.h
 create mode 100644 tools/kvm/include/kvm/sdl.h
 create mode 100644 tools/kvm/include/kvm/segment.h
 create mode 100644 tools/kvm/include/kvm/strbuf.h
 create mode 100644 tools/kvm/include/kvm/symbol.h
 create mode 100644 tools/kvm/include/kvm/term.h
 create mode 100644 tools/kvm/include/kvm/threadpool.h
 create mode 100644 tools/kvm/include/kvm/types.h
 create mode 100644 tools/kvm/include/kvm/uip.h
 create mode 100644 tools/kvm/include/kvm/util-init.h
 create mode 100644 tools/kvm/include/kvm/util.h
 create mode 100644 tools/kvm/include/kvm/vesa.h
 create mode 100644 tools/kvm/include/kvm/virtio-9p.h
 create mode 100644 tools/kvm/include/kvm/virtio-balloon.h
 create mode 100644 tools/kvm/include/kvm/virtio-blk.h
 create mode 100644 tools/kvm/include/kvm/virtio-console.h
 create mode 100644 tools/kvm/include/kvm/virtio-mmio.h
 create mode 100644 tools/kvm/include/kvm/virtio-net.h
 create mode 100644 tools/kvm/include/kvm/virtio-pci-dev.h
 create mode 100644 tools/kvm/include/kvm/virtio-pci.h
 create mode 100644 tools/kvm/include/kvm/virtio-rng.h
 create mode 100644 tools/kvm/include/kvm/virtio-scsi.h
 create mode 100644 tools/kvm/include/kvm/virtio.h
 create mode 100644 tools/kvm/include/kvm/vnc.h
 create mode 100644 tools/kvm/include/linux/bitops.h
 create mode 100644 tools/kvm/include/linux/byteorder.h
 create mode 100644 tools/kvm/include/linux/compiler.h
 create mode 100644 tools/kvm/include/linux/kernel.h
 create mode 100644 tools/kvm/include/linux/module.h
 create mode 100644 tools/kvm/include/linux/prefetch.h
 create mode 100644 tools/kvm/include/linux/stddef.h
 create mode 100644 tools/kvm/include/linux/types.h
 create mode 100644 tools/kvm/ioeventfd.c
 create mode 100644 tools/kvm/ioport.c
 create mode 100644 tools/kvm/kvm-cmd.c
 create mode 100644 tools/kvm/kvm-cpu.c
 create mode 100644 tools/kvm/kvm-ipc.c
 create mode 100644 tools/kvm/kvm.c
 create mode 100644 tools/kvm/main.c
 create mode 100644 tools/kvm/mmio.c
 create mode 100644 tools/kvm/net/uip/arp.c
 create mode 100644 tools/kvm/net/uip/buf.c
 create mode 100644 tools/kvm/net/uip/core.c
 create mode 100644 tools/kvm/net/uip/csum.c
 create mode 100644 tools/kvm/net/uip/dhcp.c
 create mode 100644 tools/kvm/net/uip/icmp.c
 create mode 100644 tools/kvm/net/uip/ipv4.c
 create mode 100644 tools/kvm/net/uip/tcp.c
 create mode 100644 tools/kvm/net/uip/udp.c
 create mode 100644 tools/kvm/pci.c
 create mode 100644 tools/kvm/powerpc/boot.c
 create mode 100644 tools/kvm/powerpc/cpu_info.c
 create mode 100644 tools/kvm/powerpc/cpu_info.h
 create mode 100644 tools/kvm/powerpc/include/kvm/barrier.h
 create mode 100644 tools/kvm/powerpc/include/kvm/kvm-arch.h
 create mode 100644 tools/kvm/powerpc/include/kvm/kvm-cpu-arch.h
 create mode 100644 tools/kvm/powerpc/ioport.c
 create mode 100644 tools/kvm/powerpc/irq.c
 create mode 100644 tools/kvm/powerpc/kvm-cpu.c
 create mode 100644 tools/kvm/powerpc/kvm.c
 create mode 100644 tools/kvm/powerpc/spapr.h
 create mode 100644 tools/kvm/powerpc/spapr_hcall.c
 create mode 100644 tools/kvm/powerpc/spapr_hvcons.c
 create mode 100644 tools/kvm/powerpc/spapr_hvcons.h
 create mode 100644 tools/kvm/powerpc/spapr_pci.c
 create mode 100644 tools/kvm/powerpc/spapr_pci.h
 create mode 100644 tools/kvm/powerpc/spapr_rtas.c
 create mode 100644 tools/kvm/powerpc/xics.c
 create mode 100644 tools/kvm/powerpc/xics.h
 create mode 100644 tools/kvm/symbol.c
 create mode 100644 tools/kvm/term.c
 create mode 100644 tools/kvm/tests/Makefile
 create mode 100644 tools/kvm/tests/boot/Makefile
 create mode 100644 tools/kvm/tests/boot/init.c
 create mode 100644 tools/kvm/tests/kernel/.gitignore
 create mode 100644 tools/kvm/tests/kernel/Makefile
 create mode 100644 tools/kvm/tests/kernel/README
 create mode 100644 tools/kvm/tests/kernel/kernel.S
 create mode 100644 tools/kvm/tests/pit/.gitignore
 create mode 100644 tools/kvm/tests/pit/Makefile
 create mode 100644 tools/kvm/tests/pit/README
 create mode 100644 tools/kvm/tests/pit/tick.S
 create mode 100644 tools/kvm/ui/sdl.c
 create mode 100644 tools/kvm/ui/vnc.c
 create mode 100755 tools/kvm/util/KVMTOOLS-VERSION-GEN
 create mode 100755 tools/kvm/util/generate-cmdlist.sh
 create mode 100644 tools/kvm/util/init.c
 create mode 100755 tools/kvm/util/kvm-ifup-vbr0
 create mode 100644 tools/kvm/util/parse-options.c
 create mode 100644 tools/kvm/util/rbtree-interval.c
 create mode 100644 tools/kvm/util/read-write.c
 create mode 100755 tools/kvm/util/set_private_br.sh
 create mode 100644 tools/kvm/util/strbuf.c
 create mode 100644 tools/kvm/util/threadpool.c
 create mode 100644 tools/kvm/util/util.c
 create mode 100644 tools/kvm/virtio/9p-pdu.c
 create mode 100644 tools/kvm/virtio/9p.c
 create mode 100644 tools/kvm/virtio/balloon.c
 create mode 100644 tools/kvm/virtio/blk.c
 create mode 100644 tools/kvm/virtio/console.c
 create mode 100644 tools/kvm/virtio/core.c
 create mode 100644 tools/kvm/virtio/mmio.c
 create mode 100644 tools/kvm/virtio/net.c
 create mode 100644 tools/kvm/virtio/pci.c
 create mode 100644 tools/kvm/virtio/rng.c
 create mode 100644 tools/kvm/virtio/scsi.c
 create mode 100644 tools/kvm/x86/bios.c
 create mode 100644 tools/kvm/x86/bios/.gitignore
 create mode 100644 tools/kvm/x86/bios/bios-rom.S
 create mode 100644 tools/kvm/x86/bios/e820.c
 create mode 100644 tools/kvm/x86/bios/entry.S
 create mode 100644 tools/kvm/x86/bios/gen-offsets.sh
 create mode 100644 tools/kvm/x86/bios/int10.c
 create mode 100644 tools/kvm/x86/bios/int15.c
 create mode 100644 tools/kvm/x86/bios/local.S
 create mode 100644 tools/kvm/x86/bios/macro.S
 create mode 100644 tools/kvm/x86/bios/memcpy.c
 create mode 100644 tools/kvm/x86/bios/rom.ld.S
 create mode 100644 tools/kvm/x86/boot.c
 create mode 100644 tools/kvm/x86/cpuid.c
 create mode 100644 tools/kvm/x86/include/kvm/assembly.h
 create mode 100644 tools/kvm/x86/include/kvm/barrier.h
 create mode 100644 tools/kvm/x86/include/kvm/bios-export.h
 create mode 100644 tools/kvm/x86/include/kvm/bios.h
 create mode 100644 tools/kvm/x86/include/kvm/boot-protocol.h
 create mode 100644 tools/kvm/x86/include/kvm/cpufeature.h
 create mode 100644 tools/kvm/x86/include/kvm/interrupt.h
 create mode 100644 tools/kvm/x86/include/kvm/kvm-arch.h
 create mode 100644 tools/kvm/x86/include/kvm/kvm-cpu-arch.h
 create mode 100644 tools/kvm/x86/include/kvm/mptable.h
 create mode 100644 tools/kvm/x86/interrupt.c
 create mode 100644 tools/kvm/x86/ioport.c
 create mode 100644 tools/kvm/x86/irq.c
 create mode 100644 tools/kvm/x86/kvm-cpu.c
 create mode 100644 tools/kvm/x86/kvm.c
 create mode 100644 tools/kvm/x86/mptable.c
