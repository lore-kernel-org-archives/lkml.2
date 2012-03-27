Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2C0N5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:57:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55793 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab2C0N5d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 09:57:33 -0400
MIME-Version: 1.0
From: Trevor Turner <turn3r.tr3v0r@gmail.com>
Date: Tue, 27 Mar 2012 06:56:51 -0700
X-Google-Sender-Auth: GgM67l6j3n2t-mdXXcUjdO-U2_U
Message-ID: <CANYHJ6jjuO7yV_kbPsnJ6X+KXrsz2PRPPXHN4Rkr-vgoSG-E4A@mail.gmail.com>
Subject: K7/Athlon Optimization Causes Build Fail on Kernel 3.3 i686
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The other day when I was compiling 3.3 on my home server, enabling the
K7/Athlon family optimizations seems to cause the build to fail. It
fails without any erroneous output at the very end of the build and
has been reproducible every time I've built with it enabled. This
machine has a pair of Athlon 2000+ MP's and I'm using Arch Linux's
makepkg system (which calls make localmodconfig, make nconfig, and
make -j3 bzImage modules) to build my kernels. I have experienced this
issue on both the stock -ARCH kernel, and the -CK kernel under a
number of different configurations.

This is a list of the situations I tested:
-CK Localmod only : Success
-CK Localmod, 100Hz Timer and No Pre-empt: Success
-CK Localmod, 100Hz Timer, No Pre-empt and K7: Failed
-CK Localmod and K7: Failed
-ARCH Localmod only: Success
-ARCH Localmod 100Hz timer and no Pre-empt : Success
-ARCH Localmod, 100Hz Timer, No Pre-empt and K7: Failed
-ARCH Localmod and K7 : Failed

This is the end of the output that it fails on:
  LD [M]  sound/soc/snd-soc-core.ko
  LD [M]  sound/soundcore.ko
  LD [M]  sound/synth/emux/snd-emux-synth.ko
  LD [M]  sound/synth/snd-util-mem.ko
  LD [M]  sound/usb/6fire/snd-usb-6fire.ko
  LD [M]  sound/usb/caiaq/snd-usb-caiaq.ko
  LD [M]  sound/usb/snd-usb-audio.ko
  LD [M]  sound/usb/misc/snd-ua101.ko
  LD [M]  sound/usb/snd-usbmidi-lib.ko
  LD [M]  sound/usb/usx2y/snd-usb-us122l.ko
  LD [M]  sound/usb/usx2y/snd-usb-usx2y.ko
  IHEX    firmware/adaptec/starfire_rx.bin
  IHEX    firmware/adaptec/starfire_tx.bin
  IHEX    firmware/bnx2/bnx2-mips-09-6.2.1a.fw
  IHEX    firmware/bnx2/bnx2-rv2p-09ax-6.0.17.fw
  IHEX    firmware/bnx2/bnx2-rv2p-09-6.0.17.fw
  IHEX    firmware/bnx2/bnx2-mips-06-6.2.1.fw
  IHEX    firmware/bnx2/bnx2-rv2p-06-6.0.15.fw
  IHEX    firmware/cxgb3/t3b_psram-1.1.0.bin
  IHEX    firmware/cxgb3/t3c_psram-1.1.0.bin
  IHEX    firmware/cxgb3/t3fw-7.10.0.bin
  IHEX    firmware/cxgb3/ael2005_twx_edc.bin
  IHEX    firmware/cxgb3/ael2005_opt_edc.bin
  IHEX    firmware/cxgb3/ael2020_twx_edc.bin
  IHEX    firmware/radeon/R100_cp.bin
  IHEX    firmware/radeon/R200_cp.bin
  IHEX    firmware/radeon/R300_cp.bin
  IHEX    firmware/radeon/R420_cp.bin
  IHEX    firmware/radeon/RS690_cp.bin
  IHEX    firmware/radeon/RS600_cp.bin
  IHEX    firmware/radeon/R520_cp.bin
  IHEX    firmware/radeon/R600_pfp.bin
  IHEX    firmware/radeon/R600_me.bin
  IHEX    firmware/radeon/RV610_pfp.bin
  IHEX    firmware/radeon/RV610_me.bin
  IHEX    firmware/radeon/RV630_pfp.bin
  IHEX    firmware/radeon/RV630_me.bin
  IHEX    firmware/radeon/RV620_pfp.bin
  IHEX    firmware/radeon/RV620_me.bin
  IHEX    firmware/radeon/RV635_pfp.bin
  IHEX    firmware/radeon/RV635_me.bin
  IHEX    firmware/radeon/RV670_pfp.bin
  IHEX    firmware/radeon/RV670_me.bin
  IHEX    firmware/radeon/RS780_pfp.bin
  IHEX    firmware/radeon/RS780_me.bin
  IHEX    firmware/radeon/RV770_pfp.bin
  IHEX    firmware/radeon/RV770_me.bin
  IHEX    firmware/radeon/RV730_me.bin
  IHEX    firmware/radeon/RV730_pfp.bin
  IHEX    firmware/radeon/RV710_me.bin
  IHEX    firmware/radeon/RV710_pfp.bin
  IHEX    firmware/e100/d101m_ucode.bin
  IHEX    firmware/e100/d101s_ucode.bin
  IHEX    firmware/e100/d102e_ucode.bin
  IHEX    firmware/korg/k1212.dsp
  IHEX    firmware/ositech/Xilinx7OD.bin
  IHEX    firmware/ess/maestro3_assp_kernel.fw
  IHEX    firmware/ess/maestro3_assp_minisrc.fw
  IHEX    firmware/yamaha/ds1_ctrl.fw
  IHEX    firmware/yamaha/ds1_dsp.fw
  IHEX    firmware/yamaha/ds1e_ctrl.fw
  IHEX    firmware/yamaha/yss225_registers.bin
==> ERROR: A failure occurred in build().
    Aborting...

Contents of /proc/cpuinfo:
processor : 0
vendor_id : AuthenticAMD
cpu family : 6
model : 6
model name : AMD Athlon(TM) MP 2000+
stepping : 2
cpu MHz : 1666.797
cache size : 256 KB
fdiv_bug : no
hlt_bug : no
f00f_bug : no
coma_bug : no
fpu : yes
fpu_exception : yes
cpuid level : 1
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow
bogomips : 3333.59
clflush size : 32
cache_alignment : 32
address sizes : 34 bits physical, 32 bits virtual
power management: ts

processor : 1
vendor_id : AuthenticAMD
cpu family : 6
model : 6
model name : AMD Athlon(TM) MP 2000+
stepping : 2
cpu MHz : 1666.797
cache size : 256 KB
fdiv_bug : no
hlt_bug : no
f00f_bug : no
coma_bug : no
fpu : yes
fpu_exception : yes
cpuid level : 1
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow
bogomips : 3333.45
clflush size : 32
cache_alignment : 32
address sizes : 34 bits physical, 32 bits virtual
power management: ts
