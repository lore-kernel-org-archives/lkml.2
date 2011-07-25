Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1GYR1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 13:27:16 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:37856 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1GYR1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 13:27:12 -0400
Date: Mon, 25 Jul 2011 20:27:01 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: torvalds@linux-foundation.org
cc: mingo@elte.hu, avi@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL v2] Native Linux KVM tool for v3.1
Message-ID: <alpine.DEB.2.00.1107252025070.3090@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's the same pull request with a small fixlet for a compile-time 
problem reported by Ingo Molnar.

                         Pekka

The following changes since commit b6844e8f64920cdee620157252169ba63afb0c89:
   Linus Torvalds (1):
         Merge branch 'for-linus' of master.kernel.org:/home/rmk/linux-2.6-arm

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git kvm-tool-for-linus-v2

Amerigo Wang (2):
       kvm tools: build rbtree.o from source
       kvm tools: implement "help xxx" command

Amos Kong (4):
       kvm tools: Make virt_queue__available return false if queue is not initialized
       kvm tools: Add a script to setup private bridge
       kvm tools: Add a script to setup tap device
       kvm tools: Setup bridged network by a script

Aneesh Kumar K.V (17):
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

Anton Vorontsov (1):
       kvm tools: Fix broken terminal when kvm exits because of a signal

Asias He (115):
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

Cyrill Gorcunov (109):
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

David Ahern (1):
       kvm tools: do not append root=/dev/vda if passed via command line

Emil Renner Berthing (1):
       kvm tools: Update README with instructions for Arch Linux

Giuseppe Calderaro (2):
       kvm tools: Fix compilation issue in virtio-blk.c
       kvm tools: Remove unused handle_sigint() function

Ingo Molnar (11):
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

John Floren (6):
       kvm tools: Add BIOS INT10 handler
       kvm tools: Add video mode to kernel initialization
       kvm tools: Add VESA device
       kvm tools: Update makefile and feature tests
       kvm tools: Initialize and use VESA and VNC
       kvm tools: Add support for PS/2 keyboard system

Konstantin Khlebnikov (1):
       kvm tools: fix instances enumeration

Paul Bolle (1):
       kvm tools: Fix compilation on x86_64

Pekka Enberg (309):
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
       Merge branch 'kvm/core' into kvm-tool-for-linus-v2

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

Sasha Levin (127):
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

  tools/kvm/.gitignore                    |    9 +
  tools/kvm/CREDITS-Git                   |   30 ++
  tools/kvm/Documentation/kvm-balloon.txt |   24 +
  tools/kvm/Documentation/kvm-debug.txt   |   16 +
  tools/kvm/Documentation/kvm-list.txt    |   16 +
  tools/kvm/Documentation/kvm-pause.txt   |   16 +
  tools/kvm/Documentation/kvm-run.txt     |   63 +++
  tools/kvm/Documentation/kvm-version.txt |   21 +
  tools/kvm/Makefile                      |  269 ++++++++++
  tools/kvm/README                        |  109 ++++
  tools/kvm/bios.c                        |  157 ++++++
  tools/kvm/bios/.gitignore               |    3 +
  tools/kvm/bios/bios-rom.S               |   12 +
  tools/kvm/bios/bios.S                   |   89 ++++
  tools/kvm/bios/e820.c                   |   69 +++
  tools/kvm/bios/gen-offsets.sh           |   14 +
  tools/kvm/bios/int10.c                  |  163 ++++++
  tools/kvm/bios/local.S                  |    7 +
  tools/kvm/bios/macro.S                  |   25 +
  tools/kvm/bios/rom.ld.S                 |   17 +
  tools/kvm/builtin-balloon.c             |   34 ++
  tools/kvm/builtin-debug.c               |   32 ++
  tools/kvm/builtin-help.c                |   61 +++
  tools/kvm/builtin-list.c                |   43 ++
  tools/kvm/builtin-pause.c               |   32 ++
  tools/kvm/builtin-run.c                 |  757 +++++++++++++++++++++++++++
  tools/kvm/builtin-version.c             |   15 +
  tools/kvm/code16gcc.h                   |   15 +
  tools/kvm/command-list.txt              |   10 +
  tools/kvm/config/feature-tests.mak      |  148 ++++++
  tools/kvm/config/utilities.mak          |  188 +++++++
  tools/kvm/cpuid.c                       |   51 ++
  tools/kvm/disk/blk.c                    |   39 ++
  tools/kvm/disk/core.c                   |  222 ++++++++
  tools/kvm/disk/qcow.c                   |  845 +++++++++++++++++++++++++++++++
  tools/kvm/disk/raw.c                    |   82 +++
  tools/kvm/framebuffer.c                 |   68 +++
  tools/kvm/hw/i8042.c                    |  348 +++++++++++++
  tools/kvm/hw/rtc.c                      |   87 ++++
  tools/kvm/hw/serial.c                   |  355 +++++++++++++
  tools/kvm/hw/vesa.c                     |   76 +++
  tools/kvm/include/asm/hweight.h         |    8 +
  tools/kvm/include/kvm/8250-serial.h     |   10 +
  tools/kvm/include/kvm/apic.h            |   17 +
  tools/kvm/include/kvm/assembly.h        |   24 +
  tools/kvm/include/kvm/barrier.h         |   15 +
  tools/kvm/include/kvm/bios-export.h     |   13 +
  tools/kvm/include/kvm/bios.h            |   59 +++
  tools/kvm/include/kvm/boot-protocol.h   |   16 +
  tools/kvm/include/kvm/brlock.h          |   41 ++
  tools/kvm/include/kvm/builtin-balloon.h |    6 +
  tools/kvm/include/kvm/builtin-debug.h   |    6 +
  tools/kvm/include/kvm/builtin-help.h    |    6 +
  tools/kvm/include/kvm/builtin-list.h    |    6 +
  tools/kvm/include/kvm/builtin-pause.h   |    6 +
  tools/kvm/include/kvm/builtin-run.h     |    7 +
  tools/kvm/include/kvm/builtin-version.h |    6 +
  tools/kvm/include/kvm/compiler.h        |    6 +
  tools/kvm/include/kvm/cpufeature.h      |   41 ++
  tools/kvm/include/kvm/disk-image.h      |   73 +++
  tools/kvm/include/kvm/e820.h            |   18 +
  tools/kvm/include/kvm/framebuffer.h     |   34 ++
  tools/kvm/include/kvm/i8042.h           |   12 +
  tools/kvm/include/kvm/interrupt.h       |   26 +
  tools/kvm/include/kvm/ioeventfd.h       |   27 +
  tools/kvm/include/kvm/ioport.h          |   64 +++
  tools/kvm/include/kvm/irq.h             |   24 +
  tools/kvm/include/kvm/kvm-cmd.h         |   17 +
  tools/kvm/include/kvm/kvm-cpu.h         |   44 ++
  tools/kvm/include/kvm/kvm.h             |  105 ++++
  tools/kvm/include/kvm/mptable.h         |    8 +
  tools/kvm/include/kvm/mutex.h           |   33 ++
  tools/kvm/include/kvm/parse-options.h   |  211 ++++++++
  tools/kvm/include/kvm/pci.h             |   55 ++
  tools/kvm/include/kvm/qcow.h            |   98 ++++
  tools/kvm/include/kvm/rbtree-interval.h |   27 +
  tools/kvm/include/kvm/read-write.h      |   32 ++
  tools/kvm/include/kvm/rtc.h             |    6 +
  tools/kvm/include/kvm/rwsem.h           |   39 ++
  tools/kvm/include/kvm/sdl.h             |   17 +
  tools/kvm/include/kvm/segment.h         |   16 +
  tools/kvm/include/kvm/strbuf.h          |    6 +
  tools/kvm/include/kvm/symbol.h          |   22 +
  tools/kvm/include/kvm/term.h            |   17 +
  tools/kvm/include/kvm/threadpool.h      |   37 ++
  tools/kvm/include/kvm/types.h           |    7 +
  tools/kvm/include/kvm/uip.h             |  356 +++++++++++++
  tools/kvm/include/kvm/util.h            |   78 +++
  tools/kvm/include/kvm/vesa.h            |   19 +
  tools/kvm/include/kvm/virtio-9p.h       |   73 +++
  tools/kvm/include/kvm/virtio-balloon.h  |    8 +
  tools/kvm/include/kvm/virtio-blk.h      |   12 +
  tools/kvm/include/kvm/virtio-console.h  |    9 +
  tools/kvm/include/kvm/virtio-net.h      |   21 +
  tools/kvm/include/kvm/virtio-pci-dev.h  |   24 +
  tools/kvm/include/kvm/virtio-rng.h      |    9 +
  tools/kvm/include/kvm/virtio.h          |   59 +++
  tools/kvm/include/kvm/vnc.h             |   14 +
  tools/kvm/include/linux/bitops.h        |   33 ++
  tools/kvm/include/linux/byteorder.h     |    7 +
  tools/kvm/include/linux/kernel.h        |   39 ++
  tools/kvm/include/linux/module.h        |    6 +
  tools/kvm/include/linux/prefetch.h      |    6 +
  tools/kvm/include/linux/types.h         |   50 ++
  tools/kvm/interrupt.c                   |   27 +
  tools/kvm/ioeventfd.c                   |  128 +++++
  tools/kvm/ioport.c                      |  187 +++++++
  tools/kvm/irq.c                         |  112 ++++
  tools/kvm/kvm-cmd.c                     |   74 +++
  tools/kvm/kvm-cpu.c                     |  505 ++++++++++++++++++
  tools/kvm/kvm.c                         |  741 +++++++++++++++++++++++++++
  tools/kvm/main.c                        |   14 +
  tools/kvm/mmio.c                        |  130 +++++
  tools/kvm/mptable.c                     |  284 +++++++++++
  tools/kvm/net/uip/arp.c                 |   30 ++
  tools/kvm/net/uip/buf.c                 |  114 +++++
  tools/kvm/net/uip/core.c                |  190 +++++++
  tools/kvm/net/uip/csum.c                |   92 ++++
  tools/kvm/net/uip/dhcp.c                |  195 +++++++
  tools/kvm/net/uip/icmp.c                |   29 +
  tools/kvm/net/uip/ipv4.c                |   29 +
  tools/kvm/net/uip/tcp.c                 |  317 ++++++++++++
  tools/kvm/net/uip/udp.c                 |  236 +++++++++
  tools/kvm/pci.c                         |  115 +++++
  tools/kvm/read-write.c                  |  318 ++++++++++++
  tools/kvm/symbol.c                      |   98 ++++
  tools/kvm/term.c                        |  131 +++++
  tools/kvm/tests/Makefile                |   19 +
  tools/kvm/tests/boot/Makefile           |   13 +
  tools/kvm/tests/boot/init.c             |   11 +
  tools/kvm/tests/kernel/.gitignore       |    2 +
  tools/kvm/tests/kernel/Makefile         |   20 +
  tools/kvm/tests/kernel/README           |   16 +
  tools/kvm/tests/kernel/kernel.S         |    8 +
  tools/kvm/tests/pit/.gitignore          |    2 +
  tools/kvm/tests/pit/Makefile            |   20 +
  tools/kvm/tests/pit/README              |   16 +
  tools/kvm/tests/pit/tick.S              |  109 ++++
  tools/kvm/threadpool.c                  |  146 ++++++
  tools/kvm/ui/sdl.c                      |  150 ++++++
  tools/kvm/ui/vnc.c                      |  218 ++++++++
  tools/kvm/util.c                        |  101 ++++
  tools/kvm/util/KVMTOOLS-VERSION-GEN     |   40 ++
  tools/kvm/util/generate-cmdlist.sh      |   23 +
  tools/kvm/util/kvm-ifup-vbr0            |    6 +
  tools/kvm/util/parse-options.c          |  631 +++++++++++++++++++++++
  tools/kvm/util/rbtree-interval.c        |   90 ++++
  tools/kvm/util/set_private_br.sh        |   51 ++
  tools/kvm/util/strbuf.c                 |   13 +
  tools/kvm/virtio/9p-pdu.c               |  242 +++++++++
  tools/kvm/virtio/9p.c                   |  835 ++++++++++++++++++++++++++++++
  tools/kvm/virtio/balloon.c              |  265 ++++++++++
  tools/kvm/virtio/blk.c                  |  345 +++++++++++++
  tools/kvm/virtio/console.c              |  257 ++++++++++
  tools/kvm/virtio/core.c                 |  102 ++++
  tools/kvm/virtio/net.c                  |  485 ++++++++++++++++++
  tools/kvm/virtio/rng.c                  |  251 +++++++++
  157 files changed, 15411 insertions(+), 0 deletions(-)
  create mode 100644 tools/kvm/.gitignore
  create mode 100644 tools/kvm/CREDITS-Git
  create mode 100644 tools/kvm/Documentation/kvm-balloon.txt
  create mode 100644 tools/kvm/Documentation/kvm-debug.txt
  create mode 100644 tools/kvm/Documentation/kvm-list.txt
  create mode 100644 tools/kvm/Documentation/kvm-pause.txt
  create mode 100644 tools/kvm/Documentation/kvm-run.txt
  create mode 100644 tools/kvm/Documentation/kvm-version.txt
  create mode 100644 tools/kvm/Makefile
  create mode 100644 tools/kvm/README
  create mode 100644 tools/kvm/bios.c
  create mode 100644 tools/kvm/bios/.gitignore
  create mode 100644 tools/kvm/bios/bios-rom.S
  create mode 100644 tools/kvm/bios/bios.S
  create mode 100644 tools/kvm/bios/e820.c
  create mode 100644 tools/kvm/bios/gen-offsets.sh
  create mode 100644 tools/kvm/bios/int10.c
  create mode 100644 tools/kvm/bios/local.S
  create mode 100644 tools/kvm/bios/macro.S
  create mode 100644 tools/kvm/bios/rom.ld.S
  create mode 100644 tools/kvm/builtin-balloon.c
  create mode 100644 tools/kvm/builtin-debug.c
  create mode 100644 tools/kvm/builtin-help.c
  create mode 100644 tools/kvm/builtin-list.c
  create mode 100644 tools/kvm/builtin-pause.c
  create mode 100644 tools/kvm/builtin-run.c
  create mode 100644 tools/kvm/builtin-version.c
  create mode 100644 tools/kvm/code16gcc.h
  create mode 100644 tools/kvm/command-list.txt
  create mode 100644 tools/kvm/config/feature-tests.mak
  create mode 100644 tools/kvm/config/utilities.mak
  create mode 100644 tools/kvm/cpuid.c
  create mode 100644 tools/kvm/disk/blk.c
  create mode 100644 tools/kvm/disk/core.c
  create mode 100644 tools/kvm/disk/qcow.c
  create mode 100644 tools/kvm/disk/raw.c
  create mode 100644 tools/kvm/framebuffer.c
  create mode 100644 tools/kvm/hw/i8042.c
  create mode 100644 tools/kvm/hw/rtc.c
  create mode 100644 tools/kvm/hw/serial.c
  create mode 100644 tools/kvm/hw/vesa.c
  create mode 100644 tools/kvm/include/asm/hweight.h
  create mode 100644 tools/kvm/include/kvm/8250-serial.h
  create mode 100644 tools/kvm/include/kvm/apic.h
  create mode 100644 tools/kvm/include/kvm/assembly.h
  create mode 100644 tools/kvm/include/kvm/barrier.h
  create mode 100644 tools/kvm/include/kvm/bios-export.h
  create mode 100644 tools/kvm/include/kvm/bios.h
  create mode 100644 tools/kvm/include/kvm/boot-protocol.h
  create mode 100644 tools/kvm/include/kvm/brlock.h
  create mode 100644 tools/kvm/include/kvm/builtin-balloon.h
  create mode 100644 tools/kvm/include/kvm/builtin-debug.h
  create mode 100644 tools/kvm/include/kvm/builtin-help.h
  create mode 100644 tools/kvm/include/kvm/builtin-list.h
  create mode 100644 tools/kvm/include/kvm/builtin-pause.h
  create mode 100644 tools/kvm/include/kvm/builtin-run.h
  create mode 100644 tools/kvm/include/kvm/builtin-version.h
  create mode 100644 tools/kvm/include/kvm/compiler.h
  create mode 100644 tools/kvm/include/kvm/cpufeature.h
  create mode 100644 tools/kvm/include/kvm/disk-image.h
  create mode 100644 tools/kvm/include/kvm/e820.h
  create mode 100644 tools/kvm/include/kvm/framebuffer.h
  create mode 100644 tools/kvm/include/kvm/i8042.h
  create mode 100644 tools/kvm/include/kvm/interrupt.h
  create mode 100644 tools/kvm/include/kvm/ioeventfd.h
  create mode 100644 tools/kvm/include/kvm/ioport.h
  create mode 100644 tools/kvm/include/kvm/irq.h
  create mode 100644 tools/kvm/include/kvm/kvm-cmd.h
  create mode 100644 tools/kvm/include/kvm/kvm-cpu.h
  create mode 100644 tools/kvm/include/kvm/kvm.h
  create mode 100644 tools/kvm/include/kvm/mptable.h
  create mode 100644 tools/kvm/include/kvm/mutex.h
  create mode 100644 tools/kvm/include/kvm/parse-options.h
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
  create mode 100644 tools/kvm/include/kvm/util.h
  create mode 100644 tools/kvm/include/kvm/vesa.h
  create mode 100644 tools/kvm/include/kvm/virtio-9p.h
  create mode 100644 tools/kvm/include/kvm/virtio-balloon.h
  create mode 100644 tools/kvm/include/kvm/virtio-blk.h
  create mode 100644 tools/kvm/include/kvm/virtio-console.h
  create mode 100644 tools/kvm/include/kvm/virtio-net.h
  create mode 100644 tools/kvm/include/kvm/virtio-pci-dev.h
  create mode 100644 tools/kvm/include/kvm/virtio-rng.h
  create mode 100644 tools/kvm/include/kvm/virtio.h
  create mode 100644 tools/kvm/include/kvm/vnc.h
  create mode 100644 tools/kvm/include/linux/bitops.h
  create mode 100644 tools/kvm/include/linux/byteorder.h
  create mode 100644 tools/kvm/include/linux/kernel.h
  create mode 100644 tools/kvm/include/linux/module.h
  create mode 100644 tools/kvm/include/linux/prefetch.h
  create mode 100644 tools/kvm/include/linux/types.h
  create mode 100644 tools/kvm/interrupt.c
  create mode 100644 tools/kvm/ioeventfd.c
  create mode 100644 tools/kvm/ioport.c
  create mode 100644 tools/kvm/irq.c
  create mode 100644 tools/kvm/kvm-cmd.c
  create mode 100644 tools/kvm/kvm-cpu.c
  create mode 100644 tools/kvm/kvm.c
  create mode 100644 tools/kvm/main.c
  create mode 100644 tools/kvm/mmio.c
  create mode 100644 tools/kvm/mptable.c
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
  create mode 100644 tools/kvm/read-write.c
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
  create mode 100644 tools/kvm/threadpool.c
  create mode 100644 tools/kvm/ui/sdl.c
  create mode 100644 tools/kvm/ui/vnc.c
  create mode 100644 tools/kvm/util.c
  create mode 100755 tools/kvm/util/KVMTOOLS-VERSION-GEN
  create mode 100755 tools/kvm/util/generate-cmdlist.sh
  create mode 100755 tools/kvm/util/kvm-ifup-vbr0
  create mode 100644 tools/kvm/util/parse-options.c
  create mode 100644 tools/kvm/util/rbtree-interval.c
  create mode 100755 tools/kvm/util/set_private_br.sh
  create mode 100644 tools/kvm/util/strbuf.c
  create mode 100644 tools/kvm/virtio/9p-pdu.c
  create mode 100644 tools/kvm/virtio/9p.c
  create mode 100644 tools/kvm/virtio/balloon.c
  create mode 100644 tools/kvm/virtio/blk.c
  create mode 100644 tools/kvm/virtio/console.c
  create mode 100644 tools/kvm/virtio/core.c
  create mode 100644 tools/kvm/virtio/net.c
  create mode 100644 tools/kvm/virtio/rng.c
