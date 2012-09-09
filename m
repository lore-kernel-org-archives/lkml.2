Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2IIATB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 20:19:01 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40543 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2IIAS6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 20:18:58 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 8 Sep 2012 17:18:36 -0700
X-Google-Sender-Auth: hxO6QgnST1E3TXD1uYZeaATxPRQ
Message-ID: <CA+55aFwnPfdyTTG6WTuhChomg=t9nSS18xracq3iQ3F5+PWOog@mail.gmail.com>
Subject: Linux 3.6-rc5
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, we're back to the *regular* release schedule, with weekly -rc's and all.

So 3.6-rc5 is out there, and everything is looking fairly calm. Too
calm, in fact, I'm waiting for the other shoe to drop, when Greg
finally crawls his way out from under his mailbox after the kernel
summit and kayaking. I suspect a few other developers may also have
been quiet because of the kernel summit and related travel.

I have some more travel myself coming up, but if it stays this quiet
it will hopefully not even be noticeable.

Anyway, what's new? Not a whole lot, and what is there is really
spread pretty much all over, but we're back to the usual situation
with the bulk of it being drivers: sound, mmc, networking (both wired
and wireless), pci, video.

There's some ARM (and to a lesser degree powerpc) updates too, and
some cifs stuff. And random one-liners scattered pretty much all over.
The shortlog is appended, so scan over it just to get a feel for
things,

                    Linus

---


Alan Cox (1):
      dj: memory scribble in logi_dj

Alan Stern (1):
      HID: add NOGET quirk for Eaton Ellipse MAX UPS

Aleksander Morgado (1):
      net: qmi_wwan: new device: Foxconn/Novatel E396

Alex Shi (1):
      xen: fix logical error in tlb flushing

Alexey Khoroshilov (1):
      can: softing: Fix potential memory leak in softing_load_fw()

Amerigo Wang (1):
      netpoll: revert 6bdb7fe3104 and fix be_poll() instead

Andres Freund (1):
      HID: tpkbd: work even if the new Lenovo Keyboard driver is not configured

Andrew Lunn (1):
      ARM: Kirkwood: Fix 'SZ_1M' undeclared here for db88f6281-bp-setup.c

Anton Blanchard (4):
      powerpc: Update DSCR on all CPUs when writing sysfs dscr_default
      powerpc: Keep thread.dscr and thread.dscr_inherit in sync
      powerpc: Fix DSCR inheritance in copy_thread()
      powerpc: Restore correct DSCR in context switch

Artem Bityutskiy (1):
      UBI: fix a horrible memory deallocation bug

Axel Lin (3):
      gpio: mc9s08dz60: Fix build error if I2C=m
      gpio: em: Fix checking return value of irq_alloc_descs
      gpio: rdc321x: Prevent removal of modules exporting active GPIOs

Ben Hutchings (1):
      sfc: Fix reporting of IPv4 full filters through ethtool

Benjamin Herrenschmidt (1):
      powerpc: Don't use __put_user() in patch_instruction

Bin Liu (1):
      net: ethernet: fix kernel OOPS when remove davinci_mdio module

Bjorn Helgaas (1):
      PCI: Don't print anything while decoding is disabled

Bjørn Mork (1):
      net: qmi_wwan: add several new Gobi devices

Bo Shen (1):
      ARM: at91/dts: remove partial parameter in at91sam9g25ek.dts

Bruce Allan (1):
      e1000e: DoS while TSO enabled caused by link partner with small MSS

Bruno Prémont (1):
      fbcon: Fix bit_putcs() call to kmalloc(s, GFP_KERNEL)

Claudiu Manoil (1):
      gianfar: fix default tx vlan offload feature flag

Dan Carpenter (2):
      video: mb862xxfb: prevent divide by zero bug
      fddi: 64 bit bug in smt_add_para()

Daniel Mack (4):
      ALSA: snd-usb: Fix URB cancellation at stream start
      ALSA: snd-usb: restore delay information
      ALSA: snd-usb: fix calls to next_packet_size
      ALSA: snd-usb: fix cross-interface streaming devices

Dave Jones (1):
      Remove user-triggerable BUG from mpol_to_str

David Henningsson (1):
      ALSA: hda - Do not set GPIOs for speakers on IDT if there are no speakers

Dmitry Torokhov (1):
      Input: i8042 - add Gigabyte T1005 series netbooks to noloop table

Doug Anderson (1):
      mmc: dw_mmc: Disable low power mode if SDIO interrupts are used

Eric Dumazet (3):
      ipv4: properly update pmtu
      ipv4: take rt_uncached_lock only if needed
      ipv4: must use rcu protection while calling fib_lookup

Fengguang Wu (1):
      af_packet: match_fanout_group() can be static

Francesco Ruggeri (1):
      net: ipv4: ipmr_expire_timer causes crash when removing net namespace

Giuseppe CAVALLARO (2):
      stmmac: fix GMAC syn ID
      stmmac: fix a typo in the macro used to mask the mmc irq

Grazvydas Ignotas (1):
      OMAPFB: fix framebuffer console colors

Guenter Roeck (2):
      Input: edt-ft5x06 - fix build error when compiling wthout CONFIG_DEBUG_FS
      linux/kernel.h: Fix DIV_ROUND_CLOSEST to support negative dividends

Henrik Rydberg (1):
      HID: Only dump input if someone is listening

Hiroshi Doyu (4):
      ARM: dma-mapping: atomic_pool with struct page **pages
      ARM: dma-mapping: Refactor out to introduce __in_atomic_pool
      ARM: dma-mapping: Introduce __atomic_get_pages() for __iommu_get_pages()
      ARM: dma-mapping: IOMMU allocates pages from atomic_pool with GFP_ATOMIC

Huang Ying (4):
      PCI/PM: Enable D3/D3cold by default for most devices
      PCI/PM: Keep parent bridge active when probing device
      PCI/PM: Fix config reg access for D3cold and bridge suspending
      PCI/PM: Add ABI document for sysfs file d3cold_allowed

Ian Campbell (1):
      xen-netfront: use __pskb_pull_tail to ensure linear area is big
enough on RX

Ian Chen (1):
      mmc: card: Skip secure erase on MoviNAND; causes unrecoverable corruption.

Jaccon Bastiaansen (1):
      cs89x0 : packet reception not working

Jason Gerecke (1):
      Input: wacom - add support for EMR on Cintiq 24HD touch

Jesse Larrew (1):
      powerpc/vphn: Fix arch_update_cpu_topology() return value

Johannes Berg (2):
      iwlwifi: fix flow handler debug code
      iwlwifi: protect SRAM debugfs

Julia Lawall (7):
      drivers/net/wireless/ipw2x00/ipw2100.c: introduce missing initialization
      drivers/video/auo_k190x.c: drop kfree of devm_kzalloc's data
      ipvs: fix error return code
      netfilter: ctnetlink: fix error return code in init path
      netfilter: nfnetlink_log: fix error return code in init path
      net: ipv6: fix error return code
      net/xfrm/xfrm_state.c: fix error return code

Konrad Rzeszutek Wilk (2):
      xen/p2m: Fix one-off error in checking the P2M tree directory.
      xen/pciback: Fix proper FLR steps.

Kuninori Morimoto (5):
      ARM: shmobile: sh73a0: fixup RELOC_BASE of intca_irq_pins_desc
      ARM: shmobile: marzen: fixup smsc911x id for regulator
      ARM: shmobile: armadillo800eva: fixup: sound card detection order
      ARM: shmobile: mackerel: fixup usb module order
      ARM: shmobile: armadillo800eva: enable rw rootfs mount

Laurent Pinchart (2):
      ARM: mach-shmobile: armadillo800eva: Fix GPIO buttons descriptions
      ARM: mach-shmobile: armadillo800eva: Enable power button as wakeup source

Lauri Hintsala (2):
      mmc: mxs-mmc: fix deadlock in SDIO IRQ case
      mmc: mxs-mmc: fix deadlock caused by recursion loop

Linus Torvalds (1):
      Linux 3.6-rc5

Linus Walleij (1):
      ARM: gemini: fix the gemini build

Ludovic Desroches (4):
      ARM: at91: fix system timer irq issue due to sparse irq support
      ARM: at91: fix rtc-at91sam9 irq issue due to sparse irq support
      ARM: at91/feature-removal-schedule: delay at91_mci removal
      mmc: atmel-mci: not busy flag has also to be used for read operations

Marek Szyprowski (5):
      mm: cma: fix alignment requirements for contiguous regions
      ARM: relax conditions required for enabling Contiguous Memory Allocator
      ARM: DMA-Mapping: add function for setting coherent pool size
from platform code
      ARM: DMA-Mapping: print warning when atomic coherent allocation fails
      ARM: Kirkwood: increase atomic coherent pool size

Mark Asselstine (1):
      firmware: fix directory creation rule matching with make 3.82

Merav Sicron (2):
      bnx2x: Move netif_napi_add to the open call
      bnx2x: Correct the ndo_poll_controller call

Michael Grzeschik (1):
      Input: imx_keypad - reset the hardware before enabling

Michal Marek (1):
      link-vmlinux.sh: Fix stray "echo" in error message

Miklos Szeredi (1):
      uml: fix compile error in deliver_alarm()

Mikulas Patocka (1):
      Fix order of arguments to compat_put_time[spec|val]

Nicolas Ferre (1):
      ARM: at91/clock: fix PLLA overclock warning

Oliver Neukum (1):
      usbnet: fix deadlock in resume

Pablo Neira Ayuso (3):
      netlink: fix possible spoofing from non-root processes
      netfilter: nf_nat_sip: fix incorrect handling of EBUSY for RTCP
expectation
      netfilter: nf_conntrack: fix racy timer handling with reliable events

Patrick McHardy (1):
      netfilter: nfnetlink_log: fix NLA_PUT macro removal bug

Paul Cercueil (1):
      fbcon: prevent possible buffer overflow.

Paul Mackerras (3):
      powerpc: Give hypervisor decrementer interrupts their own handler
      powerpc/powernv: Always go into nap mode when CPU is offline
      powerpc: Make sure IPI handlers see data written by IPI senders

Paul Walmsley (1):
      mmc: omap: fix broken PIO mode

Pavel Roskin (1):
      ALSA: snd-usb: use list_for_each_safe for endpoint resources

Pavel Shilovsky (2):
      CIFS: Fix log messages in packet checking for SMB2
      CIFS: Fix cifs_do_create error hadnling

Rayagond Kokatanur (1):
      stmmac: add header inclusion protection

Ronny Hegewald (1):
      xen: Use correct masking in xen_swiotlb_alloc_coherent.

Seungwon Jeon (3):
      mmc: dw_mmc: amend using error interrupt status
      mmc: dw_mmc: correct mishandling error interrupt
      mmc: dw_mmc: fix error handling in PIO mode

Shawn Guo (1):
      mmc: sdhci-esdhc: break out early if clock is 0

Sonic Zhang (1):
      mmc: bfin_sdh: fix dma_desc_array build error

Steve French (2):
      CIFS: Protect i_nlink from being negative
      cifs: print error code if smb signature verification fails

Sven Schmitt (1):
      can: sja1000_platform: fix wrong flag IRQF_SHARED for interrupt sharing

Takashi Iwai (2):
      ALSA: hda - Avoid unnecessary parameter read for EPSS
      ALSA: hda - Don't trust codec EPSS bit for IDT 92HD83xx & co

Thierry Reding (1):
      gpio: Fix debug message in of_get_named_gpio_flags()

Thomas Huehn (1):
      ath5k: fix wrong max power per rate eeprom reads for 802.11a

Thomas Pedersen (1):
      mac80211: fix DS to MBSS address translation

Tomi Valkeinen (1):
      OMAPDSS: Fix SDI PLL locking

Vladimir Zapolskiy (1):
      brcm80211: smac: set interface down on reset

Yuchung Cheng (1):
      tcp: fix cwnd reduction for non-sack recovery

Yuval Mintz (1):
      bnx2x: fix 57840_MF pci id

xeb@mail.ru (1):
      l2tp: avoid to use synchronize_rcu in tunnel free function
