Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab0JXVSc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 17:18:32 -0400
Received: from mail.openrapids.net ([64.15.138.104]:48517 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932970Ab0JXVSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 17:18:30 -0400
Date: Sun, 24 Oct 2010 17:18:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [BUG 2.6.36] early serial console undefined refs
Message-ID: <20101024211824.GA19172@Krystal>
References: <20101023144352.GA2818@Krystal> <4CC31D6E.6040206@kernel.org> <4CC31DF9.9020307@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC31DF9.9020307@kernel.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:16:49 up 32 days,  1:19,  4 users,  load average: 0.14, 0.20,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu (yinghai@kernel.org) wrote:
> On 10/23/2010 10:37 AM, Yinghai Lu wrote:
> > On 10/23/2010 07:43 AM, Mathieu Desnoyers wrote:
> >> Hi,
> >>
> >> Building 2.6.36 fails for me with the following link error (config below).
> >> I think commit f4ed2877b16e8146427306aea8819adac5c88374 is very likely to be the
> >> culprit, but given other changes that were done afterward, the fix is not as
> >> easy as a simple revert.
> >>
> >> Thoughts ?
> >>
> >>   Building modules, stage 2.
> >>   MODPOST 65 modules
> >>   LD      arch/x86/boot/setup.elf
> >> arch/x86/boot/early_serial_console.o: In function `early_serial_init':
> >> /home/compudj/git/morestable/linux-2.6-lttng/arch/x86/boot/early_serial_console.c:40: undefined reference to `early_serial_base'
> > 
> > your tree may have problem. Did you try clean tree from Linus ?
> > 
> > early_seria_console.c
> > 
> > #include "boot.h"
> > ...
> > static void early_serial_init(int port, int baud)
> > 
> > 
> > and in boot.h, we have
> > /* early_serial_console.c */
> > extern int early_serial_base;
> 
> at least linus's tree and tip are ok with your config

I did a make clean, and it fixed the problem. I tried checking out a 2.6.35.7
kernel, build it, checkout 2.6.36 on top, then build without make clean, and it
works fine now. So I cannot reproduce the problem.

Thanks for the hint!

Mathieu


> 
>   MODPOST 65 modules
>   CC      arch/x86/boot/a20.o
>   CC      arch/x86/boot/cmdline.o
>   AS      arch/x86/boot/copy.o
>   HOSTCC  arch/x86/boot/mkcpustr
>   CC      arch/x86/ia32/ia32_aout.mod.o
>   CC      arch/x86/boot/cpucheck.o
>   CC      arch/x86/kvm/kvm-intel.mod.o
>   CC      arch/x86/boot/early_serial_console.o
>   CC      arch/x86/boot/edd.o
>   CC      arch/x86/kvm/kvm.mod.o
>   VOFFSET arch/x86/boot/voffset.h
>   CC      arch/x86/oprofile/oprofile.mod.o
>   CC      crypto/crc32c.mod.o
>   CC      drivers/ata/sata_mv.mod.o
>   CC      drivers/base/firmware_class.mod.o
>   LDS     arch/x86/boot/compressed/vmlinux.lds
>   AS      arch/x86/boot/compressed/head_64.o
>   CC      drivers/block/cryptoloop.mod.o
>   CC      arch/x86/boot/compressed/misc.o
>   CC      drivers/block/loop.mod.o
>   CC      drivers/cpufreq/cpufreq_ondemand.mod.o
>   CC      drivers/firmware/dcdbas.mod.o
>   CC      drivers/hwmon/hwmon-vid.mod.o
>   CC      drivers/hwmon/it87.mod.o
>   CC      drivers/input/input-polldev.mod.o
>   CC      drivers/md/dm-crypt.mod.o
>   CC      arch/x86/boot/compressed/string.o
>   CC      drivers/md/dm-delay.mod.o
>   CC      arch/x86/boot/compressed/cmdline.o
>   CC      drivers/md/dm-log.mod.o
>   CC      arch/x86/boot/compressed/early_serial_console.o
>   CC      drivers/md/dm-mirror.mod.o
>   OBJCOPY arch/x86/boot/compressed/vmlinux.bin
>   CC      drivers/md/dm-multipath.mod.o
>   GZIP    arch/x86/boot/compressed/vmlinux.bin.gz
>   CC      drivers/md/dm-region-hash.mod.o
>   CC      drivers/md/dm-round-robin.mod.o
>   CC      drivers/md/dm-snapshot.mod.o
>   CC      drivers/md/dm-zero.mod.o
>   CC      drivers/net/bonding/bonding.mod.o
>   CC      drivers/net/dummy.mod.o
>   CC      drivers/net/e1000/e1000.mod.o
>   CC      drivers/net/e1000e/e1000e.mod.o
>   CC      drivers/net/s2io.mod.o
>   CC      drivers/net/skge.mod.o
>   CC      drivers/net/sky2.mod.o
>   CC      drivers/net/tun.mod.o
>   CC      drivers/scsi/dpt_i2o.mod.o
>   CC      drivers/scsi/qla4xxx/qla4xxx.mod.o
>   CC      drivers/scsi/scsi_transport_iscsi.mod.o
>   CC      drivers/scsi/scsi_wait_scan.mod.o
>   MKPIGGY arch/x86/boot/compressed/piggy.S
>   AS      arch/x86/boot/compressed/piggy.o
>   CC      drivers/usb/misc/cytherm.mod.o
>   LD      arch/x86/boot/compressed/vmlinux
>   CC      arch/x86/boot/main.o
>   CC      drivers/usb/serial/pl2303.mod.o
>   CC      arch/x86/boot/mca.o
>   CC      arch/x86/boot/memory.o
>   CC      drivers/usb/serial/usbserial.mod.o
>   CC      arch/x86/boot/pm.o
>   AS      arch/x86/boot/pmjump.o
>   CC      drivers/video/output.mod.o
>   CC      arch/x86/boot/printf.o
>   CC      lib/libcrc32c.mod.o
>   CC      arch/x86/boot/regs.o
>   CC      arch/x86/boot/string.o
>   CC      net/ipv4/inet_diag.mod.o
>   CC      arch/x86/boot/tty.o
>   CC      arch/x86/boot/video.o
>   CC      net/ipv4/tcp_diag.mod.o
>   CC      arch/x86/boot/video-mode.o
>   CC      net/netfilter/nfnetlink.mod.o
>   CC      arch/x86/boot/version.o
>   CC      net/netfilter/nfnetlink_log.mod.o
>   CC      arch/x86/boot/video-vga.o
>   CC      arch/x86/boot/video-vesa.o
>   CC      net/netfilter/nfnetlink_queue.mod.o
>   CC      arch/x86/boot/video-bios.o
>   CC      samples/kprobes/jprobe_example.mod.o
>   OBJCOPY arch/x86/boot/vmlinux.bin
>   CPUSTR  arch/x86/boot/cpustr.h
>   ZOFFSET arch/x86/boot/zoffset.h
>   CC      samples/kprobes/kprobe_example.mod.o
>   CC      arch/x86/boot/cpu.o
>   AS      arch/x86/boot/header.o
>   LD      arch/x86/boot/setup.elf
>   CC      samples/kprobes/kretprobe_example.mod.o
>   OBJCOPY arch/x86/boot/setup.bin
>   BUILD   arch/x86/boot/bzImage
> Root device is (8, 6)
> Setup is 12972 bytes (padded to 13312 bytes).
> System is 3475 kB
> CRC f34900df
> Kernel: arch/x86/boot/bzImage is ready  (#210)

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
