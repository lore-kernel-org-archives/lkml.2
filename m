Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab1GDXJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 19:09:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586Ab1GDXJz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 19:09:55 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 4 Jul 2011 16:09:29 -0700
Message-ID: <CA+55aFxQw4T07hxz8JSm12x3FOH_Dcf=G5mvLrxiTuLxjbw+Mg@mail.gmail.com>
Subject: Linux 3.0-rc6 ..
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and a happy Independence Day to all the US kernel people out there.

There is not a lot to be said about -rc6. The biggest part by far is
the inclusion of the intel isci driver - I was admittedly a bit
doubtful about it, but it's not like it is going to cause regressions
for any existing Linux users, so whatever.

And quite frankly, Christoph Hellwig has now _twice_ said good things
about that driver, which is pretty unusual. It might mean that the
driver is great. Of course, it's way more likely that space aliens are
secretly testing their happy drugs on Christoph. Or maybe he's just
naturally mellowing.

Other than the isci driver, the rest really is just lots of random
small stuff. It's getting to the point where I'm thinking I should
just release 3.0, because it's been pretty quiet, and the fixes
haven't been earth-shakingly exciting. Some drm (radeon and intel)
fixes might be noticeable to more people, the rest would tend to be
pretty esoteric.

And so, I'm off to make s'mores,

                  Linus

---
Adam Gruchala (2):
      isci: merge phy substates
      isci: Added support for C0 to SCU Driver

Alan Cox (1):
      8250_pci: Fix missing const from merges

Alan Stern (3):
      USB: change maintainership of ohci-hcd and ehci-hcd
      USB: don't let the hub driver prevent system sleep
      USB: don't let errors prevent system sleep

Alex Deucher (4):
      drm/radeon/kms: increase rom size for atrm method
      drm/radeon/kms: Fix chremap setup on RV770 CE
      drm/radeon/kms: use correct reg on fusion when reading back mem config
      drm/radeon/kms: fix typo in cayman reg offset

Alex He (2):
      xHCI 1.0: Force Stopped Event(FSE)
      xHCI 1.0: Incompatible Device Error

Andrew Morton (1):
      drivers/base/platform.c: don't mark
platform_device_register_resndata() as __init_or_module

Artur Wojcik (1):
      isci: unify isci_host data structures

Arvid Brodin (1):
      usb/isp1760: Fix bug preventing the unlinking of control urbs

Avi Kivity (1):
      KVM: x86 emulator: fix %rip-relative addressing with immediate
source operand

Axel Lin (1):
      watchdog: gef_wdt: fix MODULE_ALIAS

Bartosz Barcinski (2):
      isci: sparse warnings cleanup
      isci: audit usage of BUG_ON macro in isci driver

Ben Skeggs (1):
      Revert "drm/nvc0: recognise 0xdX chipsets as NV_C0"

Ben Widawsky (2):
      drm/i915: forcewake fix after reset
      drm/i915: Don't call describe_obj on NULL pointers

Boojin Kim (1):
      ARM: SAMSUNG: serial: Fix on handling of one clock source for UART

Brian King (1):
      [SCSI] ibmvfc: Fix Virtual I/O failover hang

Chris Wilson (2):
      drm/i915: Use chipset-specific irq installers
      drm/i915/overlay: Fix unpinning along init error paths

Christian Dietrich (2):
      powerpc/rtas-rtc: remove sideeffects of printk_ratelimit
      arch/powerpc: use printk_ratelimited instead of printk_ratelimit

Christoph Hellwig (7):
      isci: remove mmio wrappers
      isci: remove base_controller abstraction
      isci: remove base_request abstraction
      isci: kill dead data structurs in scic_io_request.h
      isci: simplify request state handlers
      isci: simplify dma coherent allocation
      isci: remove scic_controller state handlers

Clemens Ladisch (1):
      hwmon: (k10temp) Update documentation for Fam12h

Damian Hobson-Garcia (1):
      fbdev: sh_mobile_meram: Correct pointer check for YCbCr chroma plane

Dan Carpenter (1):
      net/usb/kalmia: signedness bug in kalmia_bind()

Dan Williams (142):
      isci: Intel(R) C600 Series Chipset Storage Control Unit Driver
      isci: kill SCI_IO_REQUEST_DATA_DIRECTION
      isci: cleanup core consolidation leftovers
      isci: kill a callback cast
      isci: remove SCIC_DEBUG_ENABLED, and fixup an odd macro
      isci: bypass scic_controller_get_handler_methods()
      isci: cleanup "starting" state handling
      isci: implement error isr
      isci: advertise linkrate
      isci: debug fixes
      isci: phy state machine cleanup step1
      isci: clean up remaining silicon revision ifdefs in phy init
      isci: fix sas address reporting
      isci: rework timer api
      isci: fix hang after target reset
      isci: pad stp and smp request sizes
      isci: enable isci for dmar builds
      isci: kill isci_host list in favor of an array
      isci: remove sci_device_handle
      isci: kill "host quiesce" mechanism
      isci: replace isci_remote_device completion with event queue
      isci: preallocate remote devices
      isci: replace remote_device_lock  with scic_lock
      isci: cleanup debug leftovers in isci.h
      isci: Errors in the submit path for SATA devices manage the ap lock.
      isci: add "isci_id" attribute
      isci: fix incorrect assumptions about task->dev and
task->dev->port being NULL
      isci: task.h compile and checkpatch fixes
      isci: reset hardware at init
      isci: Add support for probing OROM for OEM params
      isci: fixup with testing from isci OROM in BIOS
      isci: fix oem parameter initialization and mode detection
      isci: fix apc mode definition
      isci: fix a build warning
      isci: reorder init to cleanup unneeded declarations
      isci: kill some long macros
      isci: namespacecheck cleanups
      isci: remove unused "remote_device_started"
      isci: cleanup isci_remote_device[_not]_ready interface
      isci: fix fragile/conditional isci_host lookups
      isci: replace sci_sas_link_rate with sas_linkrate
      isci: fix oem parameter header definition
      isci: validate oem parameters early, and fallback
      isci: rely on irq core for intx multiplexing, and silence screaming intx
      isci: make a remote_node_context a proper member of a remote_device
      isci: remove rnc->device back pointer
      isci: unify remote_device data structures
      isci: move remote_device handling out of the core
      isci: cleanup remote device construction and comments
      isci: kill smp_discover_response_protocols in favor of
domain_device.dev_type
      isci: kill smp_discover_response
      isci: remove usage of sci_sas_address in scic_sds_remote_device
      isci: remove scic_sds_remote_device_get_port_index
      isci: allow fallback to option-rom if efi variable retrieval fails
      isci: merge remote_device substates into a single state machine
      isci: kill scic_remote_device_get_connection_rate
      isci: fix remote_device start_io regressions
      isci: unify remote_device start_handlers
      isci: unify remote_device stop_handlers
      isci: kill remote_device fail_handler
      isci: unify remote_device destruct_handlers
      isci: unify remote_device reset_handlers
      isci: unify remote_device reset_complete_handlers
      isci: unify remote_device start_io_handlers
      isci: unify remote_device complete_io_handlers
      isci: kill remote_device continue_io_handler
      isci: unify remote_device start_task_handlers
      isci: kill remote_device complete_task_handler
      isci: unify remote_device suspend_handlers
      isci: kill remote_device resume_handler
      isci: unify remote_device event_handlers
      isci: unify remote_device frame_handlers
      isci: kill scic_sds_remote_device.state_handlers
      isci: remove compile-time (Kconfig) silicon configuration
      isci: fix ata locking
      isci: implement I_T_nexus_reset
      isci: unify phy data structures
      isci: unify port data structures
      isci: move stp request info to scic_sds_request
      isci: make sgl explicit/aligned request object member
      isci: move task context alignment from run-time to compile time
      isci: make command/response iu explicit request object members
      isci: unify request data structures
      isci: unify constants
      isci: move core/controller to host
      isci: uplevel register hardware data structures and unsolicited
frame handling
      isci: uplevel state machine
      isci: uplevel request infrastructure
      isci: uplevel phy infrastructure
      isci: uplevel port infrastructure
      isci: merge ssp task management substates into primary state machine
      isci: merge smp request substates into primary state machine
      isci: merge stp request substates into primary state machine
      isci: unify request abort handlers
      isci: unify request frame handlers
      isci: remove request task context completion state handler
      isci: remove the completion and event state handlers
      isci: unify phy start handlers
      isci: unify phy stop handlers
      isci: unify phy reset handlers
      isci: remove phy destruct handlers
      isci: unify phy frame handlers
      isci: unify phy event handlers
      isci: unify phy consume_power handlers
      isci: clarify phy to port lookups
      isci: unify port start_io and complete_io handlers
      isci: unify rnc event handlers
      isci: unify rnc destruct handlers
      isci: unify rnc suspend/resume handlers
      isci: unify rnc start{io|task} handlers
      isci: add some type safety to the state machine interface
      isci: remove 'min memory' infrastructure
      isci: fix isci_terminate_pending() list management
      isci: cleanup/optimize pool implementation
      isci: cleanup tag macros
      isci: cleanup/optimize queue increment macros
      isci: cleanup request allocation
      isci: fix ssp response iu buffer size in isci_tmf
      isci: atomic device lookup and reference counting
      isci: kill isci_remote_device_change_state()
      isci: kill device_sequence
      isci: fix smp response frame overrun
      isci: fix dma_unmap_sg usage
      isci: fix support for arbitrarily large smp requests
      isci: fix isci_task_execute_tmf completion
      isci: fix frame received locking
      isci: unify can_queue tracking on the tci_pool, uplevel tag assignment
      isci: combine request flags
      isci: preallocate requests
      isci: rename / clean up scic_sds_stp_request
      isci: unify isci_request and scic_sds_request
      isci: unify isci_phy and scic_sds_phy
      isci: fix scic_sds_remote_device_terminate_requests
      isci: unify isci_port and scic_sds_port
      isci: unify isci_remote_device and scic_sds_remote_device
      isci: unify isci_host and scic_sds_controller
      isci: retire scic_sds_ and scic_ prefixes
      isci: kill 'get/set' macros
      isci: merge sata.[ch] into request.c
      isci: merge scu_unsolicited_frame.h into unsolicited_frame_control.h
      isci: cleanup silicon revision detection
      isci: pare back error messsages

Daniel J Blueman (1):
      vesafb: fix memory leak

Dave Jiang (38):
      isci: removing unused loglevel module param
      isci: Move firmware loading to per PCI device
      isci: Removed special macros that does 64bit address math
      isci: Make the driver copy data directly from and to sg for PIO
      isci: have the driver use native SG calls and DMA-API
      isci: Change event notify calls from scic_cb_* to isci_event_*
      isci: Removing deprecated functions
      isci: Adding support for phy enable and disable
      isci: Cleanup warning messages for phy resets
      isci: Adding EFI variable skeletal support
      isci: update efi variable name and guid
      isci: copy the oem parameters instead of assign
      isci: Fixup for OEM parameter EFI variable retrieval
      isci: exposing user parameters via module params
      isci: Remove event_* calls as they are just wrappers
      isci: Remove "screaming" data types
      isci: replace this_* and the_* variables with more meaningful names
      isci: removing non-working ATAPI code
      isci: Remove excessive log noise with expander hot-unplug
      isci: Removing unused define SCIC_SDS_4_ENABLED
      isci: Convert SATA fis data structures to Linux native
      isci: Convert ATA defines to Linux native defines
      isci: Convert SAS identify address frame to Linux Native format
      isci: Collapsing of phy_type data structure
      isci: renaming sas_capabilities to scic_phy_cap
      isci: Fixup SSP command IU and task IU
      isci: Convert of sci_ssp_response_iu to ssp_response_iu
      isci: Fixup of smp request
      isci: Converting smp_response to Linux native smp_resp
      isci: remove redundant copies of IAF
      isci: fixup SAS iaf protocols data structure
      isci: Remove SCIC_SWAP_DWORD()
      isci: Using Linux SSP frame header
      isci: removing intel_*.h headers
      isci: Removing unnecessary functions in request.c
      isci: removing the kmalloc in smp request construct
      isci: Retrieve the EFI variable for OEM parameter
      isci: Removing unused variables compiler warnings

Dave Jones (1):
      usbnet: Remove over-broad module alias from zaurus.

David Henningsson (2):
      ALSA: HDA: Add a new Conexant codec ID (506c)
      ALSA: HDA: Add model=auto quirk for Acer Aspire 3830TG

David S. Miller (1):
      net+crypto: Use vmalloc for zlib inflate buffers.

Edmund Nadolski (17):
      isci: remove unused SC_LIBRARY_HANDLE_T typedef
      isci: remove SCI_INVALID_HANDLE
      isci: kill sci_types.h
      isci: enable interrupts during controller start, and flush discovery
      isci: remove scic_controller_get_handler_methods and ilk
      isci: kill scic_controller_get_port_handle function
      isci: remove scic_sds_port_increment_request_count
      isci: replace isci_timer list with proper embedded timers
      isci: convert port config agent timer to sci_timer
      isci: convert phy sata_timeout_timer to sci_timer
      isci: convert power control timer to sci_timer
      isci: convert scic_timeout_timer to sci_timer
      isci: convert phy_startup_timer to sci_timer
      isci: Remove tmf timeout_timer
      isci: remove isci_timer interface
      isci: state machine cleanup
      isci: additional state machine cleanup

Florian Fainelli (3):
      watchdog: mtx1-wdt: request gpio before using it
      watchdog: mtx1-wdt: fix GPIO toggling
      watchdog: mtx1-wdt: fix section mismatch

Francois Romieu (1):
      r8169: fix wrong register use.

Gabor Juhos (1):
      USB: ehci-ath79: fix a NULL pointer dereference

Geert Uytterhoeven (1):
      Staging: iio: Make IIO depend on GENERIC_HARDIRQS

Goldwyn Rodrigues (1):
      RDMA: Check for NULL mode in .devnode methods

Greg Kroah-Hartman (3):
      Staging: brcm80211: disable drivers for PPC platforms
      Staging: brcm80211: disable drivers except for X86 or MIPS platforms
      Staging: comedi: fix build breakages on some platforms

Guennadi Liakhovetski (1):
      ARM: mach-shmobile: make a struct in board-ap4evb.c static

Guenter Roeck (4):
      hwmon: (pmbus) Drop check for PMBus revision register in probe function
      hwmon: (adm1275) Free allocated memory if probe function fails
      hwmon: (pmbus) Improve fan detection
      hwmon: (pmbus) Auto-detect temp2 and temp3 registers/attributes

Hans de Goede (2):
      hwmon: Use <> rather than () around my e-mail address
      hwmon: (f71882fg) Add support for the F71869A

Hans-Christian Egtvedt (3):
      ALSA: atmel - update author email for ABDAC, AC97C and AT73C213
      watchdog: update author email for at32ap700x_wdt
      MAINTAINERS: update AVR32 and AT32AP maintainers

Havard Skinnemoen (1):
      isci: Initialize proc_name field in scsi_host_template

Henrik Ahlgren (1):
      CREDITS: Fix typo

Henryk Dembkowski (6):
      isci: remote device and node cleanup step1
      isci: coding style changes for remote device
      isci: c99 tables cleanup step1
      isci: coding style changes for remote device
      isci: Move transport layer registers from port to phy
      isci: add support for 2 more oem parmeters

Herbert Xu (1):
      bridge: Only flood unregistered groups to routers

Ilia Kolomisnky (1):
      Bluetooth: Fix L2CAP connection establishment

J Freyensee (3):
      pti: double-free security PTI fix
      pti: ENXIO error case memory leak PTI fix.
      pti: PTI semantics fix in pti_tty_cleanup.

Jacek Danecki (2):
      isci: Add support for user parameters in SCIC layer
      isci: rnc state machine table c99 conversion

James Bottomley (1):
      [SCSI] isci: fix checkpatch errors

Jean Delvare (3):
      i2c-taos-evm: Fix log messages
      hwmon: (emc6w201) Properly handle all errors
      hwmon-vid: Fix typo in VIA CPU name

Jean-Christophe PLAGNIOL-VILLARD (3):
      at91: fix at91_set_serial_console: use platform device id
      atmel_serial: fix internal port num
      at91: fix udc, ehci and mmc clock device name for cap9/9g45/9rl

Jeff Layton (1):
      cifs: set socket send and receive timeouts before attempting connect

Jeff Skirvin (27):
      isci: isci_request_cleanup_completed_loiterer checks task before task_done
      isci: Changes in isci_host_completion_routine
      isci: fix completion / abort path.
      isci: Any reset indicated on an I/O completion escalates it to
the error path.
      isci: save the i/o tag outside the scic request structure.
      isci: Cleaning up task execute path.
      isci: Code review change for completion pointer cleanup.
      isci: Termination handling cleanup, added termination timeouts.
      isci: Fix TMF build for SAS/SATA LUN reset cases.
      isci: Fixed BUG_ON in isci_abort_task_process_cb callback.
      isci: Always set response/status for requests going into the error path.
      isci: All pending requests are terminated before stopping the device.
      isci: don't hold scic_lock over calls to sas_task_abort()
      isci: Properly handle requests in the "aborting" state.
      isci: Free host lock for SATA/STP abort escalation at submission time.
      isci: Fix use of SATA soft reset state machine.
      isci: Qualify when the host lock is managed for STP/SATA callbacks.
      isci: Move the reset delay after the remote node resumption.
      isci: filter broadcast change notifications during SMP phy resets
      isci: Add decode for SMP request retry error condition
      isci: Requests that do not start must be set to "complete"
      isci: Handle timed-out request terminations correctly
      isci: Explicitly decode remote node ready and suspended states
      isci: Hard reset failure will link reset all phys in the port
      isci: Disable link layer hang detection
      isci: Terminate dev requests on FIS err bit rx in NCQ
      isci: Device reset should request sas_phy_reset(phy, true)

Jesper Juhl (3):
      USB: TI 3410/5052 USB Serial Driver: Fix mem leak when firmware
is too big.
      watchdog: Intel SCU Watchdog: Fix build and remove duplicate code
      Update version number references in README

Jesse Barnes (4):
      drm/i915: split page flip queueing into per-chipset functions
      drm/i915: add Ivy Bridge page flip support
      drm/i915: move IRQ function table init to i915_irq.c
      drm/i915: apply HWSTAM writes to Ivy Bridge as well

Jiri Slaby (2):
      TTY: ldisc, do not close until there are readers
      TTY: ntty, add one more sanity check

Joachim Eastwood (1):
      at91: Use "pclk" as con_id on at91cap9 and at91rm9200

Johan Hedberg (1):
      Bluetooth: Fix accepting connect requests for defer_setup

John (Jay) Hernandez (1):
      cxgb3: skb_record_rx_queue now records the queue index relative
to the net_device.

Julian Anastasov (1):
      netfilter: Fix ip_route_me_harder triggering ip_rt_bug

K. Y. Srinivasan (2):
      Connector: Set the CN_NETLINK_USERS correctly
      Connector: Correctly set the error code in case of success when
dispatching receive callbacks

Keith Packard (1):
      drm/i915: Hold struct_mutex during i915_save_state/i915_restore_state

Kevin Hilman (1):
      PM: Documentation: fix typo: pm_runtime_idle_sync() doesn't exist.

Kim Phillips (1):
      crypto: caam - fix operator precedence in shared descriptor allocation

Konrad Rzeszutek Wilk (2):
      xen/mmu: Fix for linker errors when CONFIG_SMP is not defined.
      xen/pci: Use the INT_SRC_OVR IRQ (instead of GSI) to preset the
ACPI SCI IRQ.

Kuninori Morimoto (1):
      ARM: mach-shmobile: mackerel: change usbhs devices order

Larry Finger (2):
      rtlwifi: rtl8192se: Handle duplicate PCI ID 0x10ec:0x8192
conflict with r8192e_pci
      rtl8192cu: Fix missing firmware load

Lennart Sorensen (1):
      serial: ioremap warning fix for jsm driver.

Linus Torvalds (2):
      ahci: change 'masking port_map' printk to KERN_WARNING level
      Linux 3.0-rc6

Loïc Minier (1):
      fbdev: amba: Link fb device to its parent

Luiz Augusto von Dentz (1):
      Bluetooth: Fix L2CAP security check

Maarten Lankhorst (1):
      xhci: Add reset on resume quirk for asrock p67 host

Maciej Patelczyk (10):
      isci: Implement SCU AFE recipe 10.
      isci: Removed struct sci_base_object from state machine.
      isci: Removed sci_base_object from scic_sds_controller.
      isci: Removed sci_base_object from scic_sds_phy.
      isci: Removed sci_base_object from scic_sds_port.
      isci: Removed sci_base_object from scic_sds_remote_device.
      isci: Removed sci_base_object from scic_sds_remote_node_context.
      isci: Removed sci_base_object from scic_sds_request.
      isci: Removed sci_object.h from project.
      isci: possible buffer overflow in isci_parse_oem_parameters fixed

Maciej Trela (3):
      isci: remove base_remote_device abstraction
      isci: remove base_port abstraction
      isci: remove base_phy abstraction

Marc Kleine-Budde (1):
      net/can: activate bit-timing calculation and netlink based
drivers by default

Marius B. Kotsbak (1):
      net/usb: kalmia: Various fixes for better support of non-x86
architectures.

Mark Brown (1):
      watchdog: Handle multiple wm831x watchdogs being registered

Maxime Bizon (1):
      serial: bcm63xx_uart: fix irq storm after rx fifo overrun.

Michael Neuling (1):
      powerpc/pseries: remove duplicate SCSI_BNX2_ISCSI in pseries_defconfig

Mike Frysinger (2):
      MAINTAINERS: mark socketcan-core lists as subscribers-only
      MAINTAINERS: drop Michael from bfin_mac driver

Márton Németh (1):
      usb: musb: host: compare status for negative error values

NeilBrown (1):
      md: avoid endless recovery loop when waiting for fail device to complete.

Nicolas Ferre (1):
      AT91: Change nand buswidth logic to match hardware default configuration

Paul Mundt (2):
      sh: Fix up unmet dependency warnings with USB EHCI/OHCI selects.
      sh: use printk_ratelimited instead of printk_ratelimit

Pavel Shved (1):
      hecubafb: add module_put on error path in hecubafb_probe()

Pawel Marek (1):
      isci: controller stop/start fixes

Petri Gynther (1):
      i2c/pca954x: Initialize the mux to disconnected state

Piotr Sawicki (11):
      isci: fix for asserts during aborts/resets to SAS/SATA in APC mode
      isci: handle cases where a d2h fis is used report an ncq error
      isci: unify request start handlers
      isci: c99 port state handlers
      isci: merge port ready substates into primary state machine
      isci: remove port start handler
      isci: unify port stop handlers
      isci: remove port destruct handler
      isci: unify port reset, add_phy, and remove_phy handlers
      isci: remove port frame and event handlers
      isci: unify port link_up and link_down handlers

Rafael J. Wysocki (1):
      PM / Runtime: Update documentation regarding driver removal

Ralf Baechle (1):
      Staging: Comedi: Build only on arches providing PAGE_KERNEL_NOCACHE

Randy Dunlap (6):
      firmware: fix GOOGLE_SMI kconfig dependency warning
      netconsole: fix build when CONFIG_NETCONSOLE_DYNAMIC is turned on
      gx1fb: Fix section mismatch warnings
      sm501fb: fix section mismatch warning
      Staging: fix more iio builds when IIO_RING_BUFFER is not enabled
      Staging: fix iio builds when IIO_RING_BUFFER is not enabled

Ron Mercer (1):
      qlge: Add maintainer.

Russ Gorby (2):
      tty: n_gsm: Fixed logic to decode break signal from modem status
      tty: n_gsm: improper skb_pull() use was leaking framed data

Sarah Sharp (5):
      xhci: Reject double add of active endpoints.
      USB: Free bandwidth when usb_disable_device is called.
      xhci: Don't warn about zeroed bMaxBurst descriptor field.
      xhci: Always set urb->status to zero for isoc endpoints.
      USB: Fix up URB error codes to reflect implementation.

Scott Wood (1):
      powerpc/e500: fix breakage with fsl_rio_mcheck_exception

Shahar Lev (1):
      drivers:misc: ti-st: fix skipping of change remote baud

Shaohui Xie (1):
      powerpc/85xx: fix NAND_CMD_READID read bytes number

Shreshtha Kumar Sahu (2):
      amba pl011: workaround for uart registers lockup
      amba pl011: platform data for reg lockup and glitch v2

Simon Horman (1):
      ARM: mach-shmobile: ag5evm: consistently name sdhi info structures

Steffen Klassert (2):
      ipv4: Fix packet size calculation in __ip_append_data
      ipv4: Fix IPsec slowpath fragmentation problem

Stephen M. Cameron (2):
      [SCSI] hpsa: fix dma unmap error in hpsa_passthru_ioctl
      [SCSI] hpsa: fix potential overrun while memcpy'ing sense data

Steven Rostedt (1):
      st_kim: Handle case of no device found for ID 0

Sven Eckelmann (1):
      MAINTAINERS: Remove Sven Eckelmann from BATMAN ADVANCED

Takashi Iwai (3):
      ALSA: cs5535 - Fix invalid big-endian conversions
      ALSA: hdspm - Fix compile warnings with PPC
      ALSA: sb16 - Fix build errors on MIPS and others with 13bit ioctl size

Timur Tabi (2):
      powerpc/p1022ds: fix audio-related properties in the device tree
      fsl-diu-fb: remove check for pixel clock ranges

Tomas Winkler (1):
      Staging: mei: fix suspend failure

Tomasz Chudy (3):
      isci: fix "no outbound task timeout" default value
      isci: Add Support for new TC completion codes
      isci: workaround port task scheduler starvation issue

Tomoya MORINAGA (1):
      8250_pci: add -ENODEV code for Intel EG20T PCH

Uwe Bonnes (1):
      USB: Add new FT232H chip to drivers/usb/serial/ftdi_sio.c

Vasiliy Kulikov (1):
      proc: restrict access to /proc/PID/io

William Katsak (1):
      udlfb: Correct sub-optimal resolution selection.

Wu Fengguang (1):
      ALSA: HDMI - fix ELD monitor name length

Xufeng Zhang (2):
      ipv6/udp: Use the correct variable to determine non-blocking condition
      udp/recvmsg: Clear MSG_TRUNC flag when starting over for a new packet

Yauheni Kaliuta (1):
      usb: musb: gadget: clear TXPKTRDY flag when set FLUSHFIFO

Yinglin Luan (1):
      rionet: fix NULL pointer dereference in rionet_remove

Yoshihiro Shimoda (6):
      sh: fix compile error using sh7757lcr_defconfig
      sh: add platform_device of EHCI/OHCI to setup-sh7757
      sh: add to select the new configuration for USB EHCI/OHCI
      usb: r8a66597-hcd: fix cannot detect low/full speed device
      sh: fix the INTC vector for IRQ and IRL in setup-sh7757
      sh: fix the value of sh_dmae_slave_config in setup-sh7757

leitao@linux.vnet.ibm.com (1):
      8250: Fix capabilities when changing the port type

matt mooney (1):
      MAINTAINERS: add myself as maintainer of USB/IP
