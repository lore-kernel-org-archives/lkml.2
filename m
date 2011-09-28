Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1I1CGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 22:06:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40680 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab1I1CGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 22:06:46 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 27 Sep 2011 19:06:23 -0700
X-Google-Sender-Auth: Npeb_zWBv0kykmcXGrf4M3nZRDg
Message-ID: <CA+55aFwFN33fnvkHRD2FfMiucvyOhcFzdzmAm0MV6Z6OLRffEQ@mail.gmail.com>
Subject: Linux 3.1-rc8
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc at

  git://github.com/torvalds/linux

and this time it really is quite noticeably smaller. The diffstat is
pretty tiny, with some coretemp and clock_ops patches standing out,
along with a small perf-tool update and everything else being pretty
much one- or few-liners. And not that many of those either.

If you are an automount users (either the autofs variety or the nfs
one), please give this a try. There's been some changes in the
automount logic: they are small and fairly obvious, and I doubt
anybody will notice anything at all, but I'd still ask automount
people to try it out.

Other than that, it really is getting quite calm. We're _still_
discussing some USB unplug issues in the block layer, but there are
patches floating around. So if somebody can actually trigger problems
reliably, please contact Jens and Cc me.

Other than that - please just test it out for any surprises..

                         Linus

---

Alex Deucher (1):
      drm/radeon/kms: fix DDIA enable on some rs690 systems

Anton Blanchard (6):
      perf symbols: Fix ppc64 SEGV in dso__load_sym with debuginfo files
      perf symbols: /proc/kallsyms does not sort module symbols
      perf symbols: Preserve symbol scope when parsing /proc/kallsyms
      perf symbols: Add some heuristics for choosing the best duplicate symbol
      perf symbols: Synthesize anonymous mmap events
      perf sort: Fix symbol sort output by separating unresolved samples by type

Arnaldo Carvalho de Melo (2):
      perf top: Fix userspace sample addr map offset
      perf python: Add missing perf_event__parse_sample 'swapped' parm

Avi Kivity (1):
      KVM: x86 emulator: fix Src2CL decode

Axel Lin (2):
      ASoC: bf5xx-ad73311: Fix prototype for bf5xx_probe
      TPM: tpm_nsc: Fix a double free of pdev in cleanup_nsc

Ben Hutchings (2):
      ALSA: fm801: Fix double free in case of error in tuner detection
      ALSA: fm801: Gracefully handle failure of tuner auto-detect

Chris Peterson (1):
      hwmon: (w83791d) rename prototype parameter from 'register' to 'reg'

Christian Borntraeger (2):
      [S390] kvm: fix address mode switching
      [S390] kvm: extension capability for new address space layout

Darren Hart (1):
      perf tools: Add support for disabling -Werror via WERROR=0

Dave Airlie (1):
      Revert "drm/radeon/kms: fix typo in r100_blit_copy"

David Ahern (2):
      perf record: Create events initially disabled and enable after init
      perf tool: Fix endianness handling of u32 data in samples

David Henningsson (1):
      ALSA: HDA: No power nids on 92HD93

David Rientjes (1):
      thp: fix khugepaged defrag tunable documentation

Fabio Estevam (1):
      spi/imx: Fix spi-imx when the hardware SPI chipselects are used

Geert Uytterhoeven (2):
      zorro: Defer device_register() until all devices have been identified
      TPM: TCG_ATMEL should depend on HAS_IOPORT

Guenter Roeck (1):
      hwmon: (coretemp) Don't use threshold registers for tempX_max

Heiko Stuebner (1):
      ARM: S3C2443: Fix bit-reset in setrate of clk_armdiv

Jan Beulich (3):
      hwmon: (coretemp) don't use kernel assigned CPU number as
platform device ID
      hwmon: (coretemp) constify static data
      hwmon: (coretemp) remove struct platform_data * parameter from
create_core_data()

Jarkko Nikula (1):
      ASoC: omap-mcbsp: Do not attempt to change DAI sysclk if stream is active

Jean Delvare (2):
      hwmon: (coretemp) Drop duplicate function get_pkg_tjmax
      hwmon: (coretemp) Let the user force TjMax

Jeff Harris (1):
      spi: Fix WARN when removing spi-fsl-spi module

Lars-Peter Clausen (1):
      ASoC: ssm2602: Re-enable oscillator after suspend

Linus Torvalds (3):
      vfs pathname lookup: Add LOOKUP_AUTOMOUNT flag
      vfs: remove LOOKUP_NO_AUTOMOUNT flag
      Linux 3.1-rc8

Marek Szyprowski (1):
      ARM: S5P: fix incorrect loop iterator usage on gpio-interrupt

Mark Brown (2):
      ASoC: Remove bitrotted wm8962_resume()
      ASoC: Ensure we generate a driver name

Masami Hiramatsu (1):
      perf probe: Fix regression of variable finder

Oleg Nesterov (1):
      ptrace: PTRACE_LISTEN forgets to unlock ->siglock

Peter Huewe (2):
      TPM: Call tpm_transmit with correct size
      TPM: Zero buffer after copying to userspace

Rafael J. Wysocki (1):
      PM / Clocks: Do not acquire a mutex under a spinlock

Randy Dunlap (2):
      scsi: SCSI_ISCI needs to select SCSI_SAS_HOST_SMP, fixes build error
      scsi: fix qla2xxx printk format warning

Roland Stigge (1):
      hwmon: (ds620) Fix handling of negative temperatures

Russell King (3):
      ARM: nommu: fix warning with checksyscalls.sh
      ARM: fix vmlinux.lds.S discarding sections
      ARM: dma-mapping: free allocated page if unable to map

Stephane Eranian (1):
      perf symbols: Fix issue with binaries using 16-bytes buildids (v2)

Sylwester Nawrocki (2):
      ARM: S5PV210: Rename sclk_cam clocks for FIMC media driver
      ARM: EXYNOS4: Rename sclk_cam clocks for FIMC driver

Takashi Iwai (2):
      ALSA: hda/realtek - Avoid bogus HP-pin assignment
      ALSA: hda/realtek - Don't detect LO jack when identical with HP

Thomas Pfaff (2):
      ALSA: usb-audio - clear chip->probing on error exit
      ALSA: usb-audio: Check for possible chip NULL pointer before
clearing probing flag

Trond Myklebust (1):
      VFS: Fix the remaining automounter semantics regressions

Will Deacon (2):
      ARM: 7091/1: errata: D-cache line maintenance operation by MVA
may not succeed
      ARM: 7099/1: futex: preserve oldval in SMP __futex_atomic_op

Zhao Jin (1):
      KVM: MMU: fix incorrect return of spte
