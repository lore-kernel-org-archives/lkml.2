Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab1LEP4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 10:56:36 -0500
Received: from icf.org.ru ([91.193.236.10]:54945 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374Ab1LEP4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 10:56:33 -0500
X-Greylist: delayed 1265 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Dec 2011 10:56:32 EST
Date: Mon, 5 Dec 2011 19:12:56 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 00/11] [ANNOUNCE] 3.0.12-rt30-rc2
In-Reply-To: <20111204185444.411298317@goodmis.org>
Message-ID: <alpine.DEB.2.02.1112051909260.13044@icf.org.ru>
References: <20111204185444.411298317@goodmis.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-1169811240-1323097976=:13044"
X-Daemon-Classification: INNOCENT
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Dec  5 19:12:56 2011
X-DSPAM-Confidence: 0.9997
X-DSPAM-Improbability: 1 in 310705 chance of being spa
X-DSPAM-Probability: 0.0000(0)
X-DSPAM-Signature: 4edcdf7821165563417655
X-DSPAM-Factors: 27,
	*From+#+Mon, 0.00010,
	files+changed, 0.00010,
	files+#+#+insertions, 0.00010,
	changed+#+insertions, 0.00010,
	include+linux, 0.00010,
	include+linux, 0.00010,
	linux+#+h, 0.00010,
	linux+#+h, 0.00010,
	include+#+#+h, 0.00010,
	include+#+#+h, 0.00010,
	insertions+#+deletions, 0.00010,
	changed+#+#+#+deletions, 0.00010,
	Wednesday+#+#+2011, 0.00010,
	*MAILER-DAEMON+Mon, 0.00010,
	instead+of, 0.00010,
	*From+MAILER-DAEMON, 0.00010,
	ru+#+#+#+org, 0.00011,
	this+patch, 0.00013,
	ath9k+hw, 0.00015,
	linux+kernel, 0.00017,
	on+#+#+7, 0.00017,
	h+4, 0.00018,
	c+8, 0.00018,
	org+#+#+#+icf, 0.00019,
	IT+Service, 0.00019,
	the+#+patch, 0.00020,
	Service+Ltd, 0.00020
X-Bounce-ID: icf.org.ru
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-1169811240-1323097976=:13044
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On 2011-12-04 13:54 -0500, Steven Rostedt wrote linux-kernel@vger.kernel.or...:

Hi, seems there is regression in 3.0.12-rt30-rc1/2 somethere in acpi part:

[ 1961.003200] BUG: scheduling while atomic: irq/9-acpi/14/0x00000002
[ 1961.003206] Modules linked in: cpufreq_conservative aes_i586 aes_generic xt_TCPMSS xt_tcpudp iptable_mangle ip_tables x_tables ipv6 pci_slot pktcdvd tcp_cubic microcode fuse hso pata_pcmcia firewire_net firewire_ohci firewire_core crc_itu_t tcp_hybla cdc_acm usbmouse usb_storage usb_libusual usbhid uhci_hcd ohci_hcd ehci_hcd usbcore snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq snd_rawmidi snd_seq_device cpufreq_userspace acpi_cpufreq mperf msr cpuid nvram arc4 joydev mousedev snd_intel8x0m 8250_pci 8250_pnp radeon ttm drm_kms_helper pcmcia drm snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss psmouse snd_pcm ath9k mac80211 ath9k_common ath9k_hw ath backlight i2c_algo_bit i2c_core cfbcopyarea cfbimgblt snd_timer snd_page_alloc yenta_socket cfbfillrect pcmcia_rsrc battery processor button ac pcmcia_core serio_raw pcspkr cfg80211 rfkill 8250 intel_agp intel_gtt agpgart power_supply serial_core evdev raid0 btrfs crc32c libcrc32c thermal sr_mod thermal_sys cdrom 8139too atkbd hwmon [last unloaded: scsi_wait_scan]
[ 1961.003364] Pid: 14, comm: irq/9-acpi Not tainted 3.0.12-rt30-rc2-r233 #1
[ 1961.003370] Call Trace:
[ 1961.003379]  [<792d740d>] ? 0x792d740d
[ 1961.003385]  [<790221f4>] ? 0x790221f4
[ 1961.003391]  [<7902246a>] ? 0x7902246a
[ 1961.003396]  [<79022dc9>] ? 0x79022dc9
[ 1961.003402]  [<792d760f>] ? 0x792d760f
[ 1961.003407]  [<792d8615>] ? 0x792d8615
[ 1961.003414]  [<7918d1d3>] ? 0x7918d1d3
[ 1961.003418]  [<7919de5e>] ? 0x7919de5e
[ 1961.003424]  [<7918d2cf>] ? 0x7918d2cf
[ 1961.003429]  [<791908d4>] ? 0x791908d4
[ 1961.003434]  [<79196bd5>] ? 0x79196bd5
[ 1961.003439]  [<7919e040>] ? 0x7919e040
[ 1961.003444]  [<79196e77>] ? 0x79196e77
[ 1961.003450]  [<791958ff>] ? 0x791958ff
[ 1961.003455]  [<791889c7>] ? 0x791889c7
[ 1961.003460]  [<7905d9f0>] ? 0x7905d9f0
[ 1961.003465]  [<7905d864>] ? 0x7905d864
[ 1961.003470]  [<7905d9d0>] ? 0x7905d9d0
[ 1961.003476]  [<7905d770>] ? 0x7905d770
[ 1961.003481]  [<7903ea94>] ? 0x7903ea94
[ 1961.003486]  [<7903ea20>] ? 0x7903ea20
[ 1961.003491]  [<792d99fe>] ? 0x792d99fe

it's appears periodicaly again and again, while it occurse system freezes about 0.5-1 second then
work again fine.

SR>
SR>Dear RT Folks,
SR>
SR>This is the RT stable review cycle of patch 3.0.12-rt30-rc2.
SR>
SR>Please scream at me if I messed something up. Please test the patches too.
SR>
SR>The difference between this and -rc1 was I fixed up the patches to
SR>add the changes, instead of removing them :)
SR>
SR>I also added the missing commit: 
SR>KVM: fix XSAVE bit scanning (now properly)
SR>That Thomas pointed out was missing.
SR>
SR>
SR>The -rc release will be uploaded to kernel.org and will be deleted when
SR>the final release is out. This is just a review release (or release candidate).
SR>
SR>The pre-releases will not be pushed to the git repository, only the
SR>final release is.
SR>
SR>If all goes well, this patch will be converted to the main release
SR>next on Wednesday (11/7/2011).
SR>
SR>Enjoy,
SR>
SR>-- Steve
SR>
SR>
SR>To build 3.0.12-rt30-rc2 directly, the following patches should be applied:
SR>
SR>  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz
SR>
SR>  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.12.xz
SR>
SR>  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.12-rt30-rc2.patch.xz
SR>
SR>You can also build from 3.0.12-rt29 by applying the incremental patch:
SR>
SR>http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.12-rt29-rt30-rc2.patch.xz
SR>
SR>
SR>Changes from 3.0.12-rt29:
SR>
SR>---
SR>
SR>
SR>Andre Przywara (1):
SR>      KVM: fix XSAVE bit scanning (now properly)
SR>
SR>Avi Kivity (1):
SR>      KVM: Sanitize cpuid
SR>
SR>Edward Donovan (1):
SR>      genirq: fix regression in irqfixup, irqpoll
SR>
SR>Ingo Molnar (1):
SR>      tasklet/rt: Prevent tasklets from going into infinite spin in RT
SR>
SR>Peter Zijlstra (2):
SR>      slab, lockdep: Fix silly bug
SR>      slab, lockdep: Annotate all slab caches
SR>
SR>Roland Dreier (1):
SR>      intel-iommu: Fix AB-BA lockdep report
SR>
SR>Steven Rostedt (1):
SR>      Linux v3.0.12-rt30-rc2
SR>
SR>Thomas Gleixner (3):
SR>      wait: Provide __wake_up_all_locked
SR>      pci: Use __wake_up_all_locked pci_unblock_user_cfg_access()
SR>      acpi: Make gbl_[hardware|gpe]_lock raw
SR>
SR>----
SR> arch/x86/kvm/x86.c              |   44 +++++++-
SR> drivers/acpi/acpica/acglobal.h  |    4 +-
SR> drivers/acpi/acpica/evgpe.c     |    4 +-
SR> drivers/acpi/acpica/evgpeblk.c  |    8 +-
SR> drivers/acpi/acpica/evgpeutil.c |   12 +-
SR> drivers/acpi/acpica/evxface.c   |   10 +-
SR> drivers/acpi/acpica/evxfgpe.c   |   24 +++---
SR> drivers/acpi/acpica/hwregs.c    |    4 +-
SR> drivers/acpi/acpica/hwxface.c   |    4 +-
SR> drivers/acpi/acpica/utmutex.c   |   21 +----
SR> drivers/pci/access.c            |    2 +-
SR> drivers/pci/intel-iommu.c       |    4 +-
SR> include/linux/interrupt.h       |   39 ++++----
SR> include/linux/wait.h            |    5 +-
SR> kernel/irq/spurious.c           |    4 +-
SR> kernel/sched.c                  |    4 +-
SR> kernel/softirq.c                |  208 ++++++++++++++++++++++++++++-----------
SR> localversion-rt                 |    2 +-
SR> mm/slab.c                       |   55 ++++++-----
SR> 19 files changed, 290 insertions(+), 168 deletions(-)
SR>

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-1169811240-1323097976=:13044--
