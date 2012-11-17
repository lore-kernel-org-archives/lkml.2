Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2KQCNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 21:13:06 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48857 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab2KQCNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 21:13:05 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Nov 2012 18:12:42 -0800
X-Google-Sender-Auth: NOHx8JV4nxtDVbujEvI8Ry39aDc
Message-ID: <CA+55aFxdin9yatcyRkTqG--fdBS-KHh0eXnK5RmONw_uJe8sfQ@mail.gmail.com>
Subject: Linux 3.7-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slightly less than a week, but since I'm leaving for vacation
tomorrow, here it is.

Things have continued to be pretty calm. We have a few more commits
here than there were in -rc5, but not enough to make me worry, and
most of the changes really tend to be tiny. And the few commits that
aren't one-liners (or "few-liners") tend to be reverts (eg
re-introducing /proc/<pid>/oom_adj) or some pretty obscure stuff (the
MIPS irqflags functions).

So we've got some arch updates (mainly mips and unicore32, with a
smattering of arm[64] and s390) and driver changes (sound, net, usb).
Along with some networking and mm fixes.

The appended shortlog gives a flavor of the kinds of things that
happened, it's really not all that exciting, but it's short enough to
be easy to read through to get some kind of idea.

I'll have a laptop with me as I'm away, but if things calm down even
further, I'll be happy. I'll do an -rc7, but considering how calm
things have been, I suspect that's the last -rc. Unless something
dramatic happens.

                    Linus

---

Akinobu Mita (1):
      drm/ttm: remove unneeded preempt_disable/enable

Al Viro (2):
      unicore32: switch to generic kernel_thread()/kernel_execve()
      unicore32: switch to generic sys_execve()

Alex Deucher (1):
      drm/radeon: fix logic error in atombios_encoders.c

Alexander Duyck (2):
      vxlan: Fix error that was resulting in VXLAN MTU size being 10
bytes too large
      vxlan: Update hard_header_len based on lowerdev when instantiating VXLAN

Andrew Lunn (1):
      Regulator: core: Unregister when gpio request fails.

Andrew Morton (1):
      revert "mm: fix-up zone present pages"

Andrew Vagin (1):
      tcp: fix retransmission in repair mode

Antonio Quartulli (4):
      batman-adv: fix tt_global_entries flags update
      batman-adv: correctly pass the client flag on tt_response
      batman-adv: don't add TEMP clients belonging to other backbone nodes
      batman-adv: process broadcast packets in BLA earlier

Arik Nemtsov (1):
      mac80211: sync acccess to tx_filtered/ps_tx_buf queues

Aristeu Rozanski (1):
      device_cgroup: fix unchecked cgroup parent usage

Artem Bityutskiy (2):
      UBIFS: introduce categorized lprops counter
      UBIFS: fix mounting problems after power cuts

Axel Lin (2):
      irqchip: irq-bcm2835: Add terminating entry for of_device_id table
      tty: serial: max310x: Add terminating entry for spi_device_id table

Benjamin Poirier (1):
      menuconfig: Replace CIRCLEQ by list_head-style lists.

Bjørn Mork (2):
      USB: keyspan: fix typo causing GPF on open
      net: cdc_ncm: add Huawei devices

Catalin Marinas (1):
      arm64: Distinguish between user and kernel XN bits

Charles Keepax (2):
      ASoC: bells: Correct type in sub speaker DAI name for WM5102
      regulator: core: Avoid deadlock when regulator_register fails

Christoph Fritz (1):
      ARM: imx: ehci: fix host power mask bit

Colin Cross (1):
      Revert "Staging: Android alarm: IOCTL command encoding fix"

Colin Ian King (1):
      pstore: Fix NULL pointer dereference in console writes

Dan Carpenter (3):
      ALSA: es1968: precedence bug in snd_es1968_tea575x_get_pins()
      ALSA: fm801: precedence bug in snd_fm801_tea575x_get_pins()
      vmwgfx: return an -EFAULT if copy_to_user() fails

Dan Williams (2):
      USB: option: add Novatel E362 and Dell Wireless 5800 USB IDs
      USB: option: add Alcatel X220/X500D USB IDs

David Howells (1):
      UAPI: (Scripted) Disintegrate arch/unicore32/include/asm

David Rientjes (3):
      mm, oom: reintroduce /proc/pid/oom_adj
      mm: fix build warning for uninitialized value
      mips, arc: fix build failure

David S. Miller (1):
      Revert "drivers/net/phy/mdio-bitbang.c: Call mdiobus_unregister
before mdiobus_free"

David Spinadel (1):
      mac80211: init sched_scan_ies

Dimitris Papastamos (2):
      ASoC: bells: Add missing select of WM0010
      ASoC: bells: Select WM1250-EV1 Springbank audio I/O module

Eric Dumazet (2):
      tcp: tcp_replace_ts_recent() should not be called from
tcp_validate_incoming()
      tcp: handle tcp_net_metrics_init() order-5 memory allocation failures

Eric Millbrandt (1):
      ASoC: wm8978: pll incorrectly configured when codec is master

Fabio Estevam (3):
      ASoC: mxs-saif: Add MODULE_ALIAS
      ASoC: mxs-saif: Fix channel swap for 24-bit format
      ARM: boot: Fix usage of kecho

Felipe Balbi (1):
      Revert "usb: musb: use DMA mode 1 whenever possible"

Felix Fietkau (2):
      mac80211: do not call ieee80211_configure_filter if no interfaces are up
      mac80211: call skb_dequeue/ieee80211_free_txskb instead of
__skb_queue_purge

Greg Kroah-Hartman (1):
      Revert "USB/host: Cleanup unneccessary irq disable code"

Guan Xuetao (4):
      UniCore32 bugfix: add missed CONFIG_ZONE_DMA
      UniCore32-bugfix: fix mismatch return value of __xchg_bad_pointer
      UniCore32-bugfix: Remove definitions in asm/bug.h to solve
difference between native and cross compiler
      unicore32: Use Kbuild infrastructure for kvm_para.h

Guenter Roeck (1):
      i2c-mux-pinctrl: Fix probe error path

Hannes Frederic Sowa (1):
      ipv6: setsockopt(IPIPPROTO_IPV6, IPV6_MINHOPCOUNT) forgot to set
return value

Hauke Mehrtens (1):
      brcmfmac: fix typo in CONFIG_BRCMISCAN

Heiko Carstens (5):
      s390/topology: fix core id vs physical package id mix-up
      s390/gup: add missing TASK_SIZE check to get_user_pages_fast()
      s390/gup: fix access_ok() usage in __get_user_pages_fast()
      s390/mm: have 16 byte aligned struct pages
      s390/3215: fix tty close handling

Hugh Dickins (3):
      memcg: fix hotplugged memory zone oops
      tmpfs: fix shmem_getpage_gfp() VM_BUG_ON
      tmpfs: change final i_blocks BUG to WARNING

Igor Mazanov (1):
      clk: remove inline usage from clk-provider.h

Jan Beulich (1):
      USB: fix build with XEN and EARLY_PRINTK_DBGP enabled but
USB_SUPPORT disabled

Jani Nikula (3):
      drm/i915/crt: fix DPMS standby and suspend mode handling
      drm/i915/sdvo: clean up connectors on intel_sdvo_init() failures
      drm/i915: do not ignore eDP bpc settings from vbt

Jean Delvare (1):
      MAINTAINERS: i2c: 7 years, this is it

Jim Quinlan (3):
      MIPS: bitops.h: Change use of 'unsigned short' to 'int'
      MIPS: Remove irqflags.h dependency from bitops.h
      MIPS: Make irqflags.h functions preempt-safe for non-mipsr2 cpus

Jiri Pirko (1):
      net: correct check in dev_addr_del()

Jiri Slaby (1):
      HID: microsoft: do not use compound literal - fix build

Johan Hedberg (2):
      Bluetooth: Fix having bogus entries in mgmt_read_index_list reply
      Bluetooth: Fix memory leak when removing a UUID

Johan Hovold (2):
      USB: usb_wwan: fix bulk-urb allocation
      ARM: at91/usbh: fix overcurrent gpio setup

Johannes Berg (5):
      iwlwifi: handle DMA mapping failures
      iwlwifi: use ieee80211_free_txskb
      mac80211: fix memory leak in device registration error path
      mac80211: don't send null data packet when not associated
      wireless: allow 40 MHz on world roaming channels 12/13

Kamlakant Patel (1):
      net/smsc911x: Fix ready check in cases where WORD_SWAP is needed

Kautuk Consul (1):
      unicore32/mm/fault.c: Port OOM changes to do_pf

Kees Cook (1):
      arch/unicore32: remove CONFIG_EXPERIMENTAL

Kevin Hilman (2):
      ARM: OMAP2+: PM: add missing newline to VC warning message
      ARM: OMAP4: PM: fix regulator name for VDD_MPU

Kirill Smelkov (1):
      doc/net: Fix typo in netdev-features.txt

Kishon Vijay Abraham I (3):
      drivers: bus: ocp2scp: add pdata support
      ARM: OMAP4: add _dev_attr_ to ocp2scp for representing usb_phy
      ARM: OMAP: ocp2scp: create omap device for ocp2scp

Len Brown (2):
      tools/power turbostat: Repair Segmentation fault when using -i option
      tools/power turbostat: graceful fail on garbage input

Linus Torvalds (1):
      Linux 3.7-rc6

Marcel Holtmann (1):
      Bluetooth: Notify about device registration before power on

Marcos Chaparro (1):
      Bluetooth: ath3k: Add support for VAIO VPCEH [0489:e027]

Marek Szyprowski (1):
      regulator: fix voltage check in regulator_is_supported_voltage()

Mark Brown (1):
      ASoC: wm5102: Write register value corrections after SYSCLK is enabled

Marko Katic (1):
      ARM: pxa/spitz_pm: Fix hang when resuming from STR

Martin Schwidefsky (1):
      s390/signal: set correct address space control

Mel Gorman (1):
      mm: revert "mm: vmscan: scale number of pages reclaimed by
reclaim/compaction based on failures"

Michal Hocko (1):
      memcg: oom: fix totalpages calculation for memory.swappiness==0

Michel Lespinasse (1):
      mm: add anon_vma_lock to validate_mm()

Miguel Vadillo (1):
      ARM: OMAP2+: clockdomain: Fix OMAP4 ISS clk domain to support only SWSUP

Misael Lopez Cruz (1):
      ASoC: dapm: Use card_list during DAPM shutdown

Mukund Navada (1):
      ASoC: core: Double control update err for snd_soc_put_volsw_sx

Nathan Lynch (1):
      ledtrig-cpu: kill useless mutex to fix sleep in atomic context

Nicolas Royer (1):
      ARM: at91/AT91SAM9G45: fix crypto peripherals irq issue due to
sparse irq support

Paul Mackerras (1):
      TTY: hvc_console, fix port reference count going to zero prematurely

Paul Parsons (1):
      ARM: pxa: hx4700: Fix backlight PWM device number

Paul Walmsley (2):
      ARM: OMAP2+: hwmod: add flag to prevent hwmod code from touching
IP block during init
      ARM: OMAP4: hwmod data: do not enable or reset the McPDM during
kernel init

Paulo Sérgio (1):
      Bluetooth: Fix error status when pairing fails

Petr Matousek (1):
      KVM: x86: invalid opcode oops on SET_SREGS with OSXSAVE bit set
(CVE-2012-4461)

Pritesh Raithatha (1):
      ARM: dt: tegra: fix length of pad control and mux registers

Ralf Baechle (4):
      MIPS: compat: Fix use of TIF_32BIT_ADDR vs _TIF_32BIT_ADDR
      MIPS: compat: Implement is_compat_task() by testing for 32-bit
address space.
      MIPS: compat: Delete now unused TIF_32BIT.
      MIPS: Malta: Fix interupt number of CBUS UART.

Rami Rosen (1):
      vxlan: fix a typo.

Randy Dunlap (1):
      rapidio: fix kernel-doc warnings

Rob Herring (1):
      ARM: highbank: retry wfi on reset request

Roger Quadros (1):
      usb: otg: Fix build errors if USB_MUSB_OMAP2PLUS is selected as module

Saurabh Mohan (1):
      ipv4/ip_vti.c: VTI fix post-decryption forwarding

Simon Marchi (1):
      tilegx: request_irq with a non-null device name

Stefan Raspl (1):
      qeth: Fix IPA_CMD_QIPASSIST return code handling

Steve Glendinning (1):
      smsc95xx: set MII_BUSY bit to read/write PHY regs

Takashi Iwai (3):
      ALSA: hda - Add a missing quirk entry for iMac 9,1
      ALSA: usb-audio: Fix mutex deadlock at disconnection
      KVM: x86: Fix invalid secondary exec controls in vmx_cpuid_update()

Tejun Heo (1):
      device_cgroup: fix RCU usage

Tero Kristo (1):
      ARM: OMAP: hwmod: wait for sysreset complete after enabling hwmod

Thomas Gleixner (1):
      futex: Handle futex_pi OWNER_DIED take over correctly

Tom Herbert (1):
      net-rps: Fix brokeness causing OOO packets

Tommi Rantala (1):
      sctp: fix /proc/net/sctp/ memory leak

Ulf Hansson (5):
      clk: ux500: Register i2c clock lookups for u8500
      clk: ux500: Register ssp clock lookups for u8500
      clk: ux500: Register msp clock lookups for u8500
      clk: ux500: Update rtc clock lookup for u8500
      clk: ux500: Register slimbus clock lookups for u8500

Ursula Braun (1):
      qeth: set new mac even if old mac is gone

Wei Yongjun (3):
      usb: musb: ux500: fix 'musbid' undeclared error in ux500_remove()
      ASoC: cs42l52: fix the return value of cs42l52_set_fmt()
      ARM i.MX: fix error-valued pointer dereference in clk_register_gate2()

Will Deacon (1):
      mm: highmem: don't treat PKMAP_ADDR(LAST_PKMAP) as a highmem address

Xi Wang (1):
      ipv4: avoid undefined behavior in do_ip_setsockopt()

Xiaotian Feng (2):
      drivers/net: fix tasklet misuse issue
      swapfile: fix name leak in swapoff

Zhang Rui (1):
      Thermal: Add Linux/Thermal subsystem info in MAINTAINER file

Zhao Yakui (1):
      ttm: Clear the ttm page allocated from high memory zone correctly
