Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab1ERSzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:55:21 -0400
Received: from mx1.unsolicited.net ([173.255.193.191]:53934 "EHLO
	mx1.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933554Ab1ERSzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:55:18 -0400
Message-ID: <4DD41613.4040102@unsolicited.net>
Date: Wed, 18 May 2011 19:55:15 +0100
From: David <david@unsolicited.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Latest kernel fails to build multi-threaded on ecryptfs home
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing some unpleasant things when building multithreaded when running the latest kernels. The compiler complains of truncated files and implausible characters. Single threaded builds seem fine.
This seems to be connected with the following errors in dmesg :-

[ 4421.923887] ecryptfs_decrypt_page: Error attempting to read lower page; rc = [-4]
[ 4421.923898] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 4421.923951] ecryptfs_decrypt_page: Error attempting to read lower page; rc = [-4]
[ 4421.923957] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 4421.923967] ecryptfs_decrypt_page: Error attempting to read lower page; rc = [-4]
[ 4421.923972] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 4421.923989] ecryptfs_decrypt_page: Error attempting to read lower page; rc = [-4]
[ 4421.923994] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 4421.924003] ecryptfs_decrypt_page: Error attempting to read lower page; rc = [-4]
[ 4421.924008] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 4421.924016] ecryptfs_decrypt_page: Error attempting to read lower page; rc = [-4]
[ 4421.924020] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 4421.924028] ecryptfs_decrypt_page: Error attempting to read lower page; rc = [-4]
[ 4421.924033] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 4421.924040] ecryptfs_decrypt_page: Error attempting to read lower page; rc = [-4]
[ 4421.924045] ecryptfs_readpage: Error decrypting page; rc = [-4]
[ 4421.924053] ecryptfs_decrypt_page: Error attempting to read lower page; rc = [-4]
[ 4421.924057] ecryptfs_readpage: Error decrypting page; rc = [-4]

I'm (obviously) compiling from an encrypted home directory (Ubuntu 10.04)

david@david:~/src/kernel/linux-2.6.38$ uname -a
Linux david 2.6.39-rc7-git12 #5 SMP Tue May 17 19:42:44 BST 2011 x86_64 GNU/Linux

david@david:~/src/kernel/linux-2.6.38$ make -j4 > ../test.out
security/selinux/ss/services.c: In function ‘security_load_policy’:
security/selinux/ss/services.c:1933: warning: the frame size of 1120 bytes is larger than 1024 bytes
drivers/mfd/twl6030-irq.c: In function ‘twl6030_init_irq’:
drivers/mfd/twl6030-irq.c:334: warning: cast to pointer from integer of different size
drivers/media/video/sn9c102/sn9c102_core.c: In function ‘sn9c102_ioctl_v4l2’:
drivers/media/video/sn9c102/sn9c102_core.c:3202: warning: the frame size of 1056 bytes is larger than 1024 bytes
drivers/pci/pcie/portdrv_core.c:17:23: warning: include/linux/aer.h is shorter than expected
drivers/staging/tm6000/tm6000-video.c: In function ‘tm6000_irq_callback’:
drivers/staging/tm6000/tm6000-video.c:231: warning: ‘vbuf’ may be used uninitialized in this function
drivers/staging/tm6000/tm6000-video.c:231: note: ‘vbuf’ was declared here
drivers/usb/storage/scsiglue.c:57:19: warning: drivers/usb/storage/debug.h is shorter than expected
drivers/video/efifb.c: In function ‘set_system’:
drivers/video/efifb.c:247: warning: cast to pointer from integer of different size
drivers/video/via/via-core.c: In function ‘via_pci_probe’:
drivers/video/via/via-core.c:684: warning: assignment discards qualifiers from pointer target type
In file included from arch/x86/boot/cmdline.c:15:
arch/x86/boot/boot.h:26:22: warning: /home/david/src/kernel/linux-2.6.38/arch/x86/include/asm/boot.h is shorter than expected
In file included from arch/x86/boot/video-mode.c:20:
arch/x86/boot/vesa.h:73:1: warning: null character(s) ignored
In file included from arch/x86/boot/video-mode.c:20:
arch/x86/boot/vesa.h:73: error: stray ‘\227’ in program
arch/x86/boot/vesa.h:73: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before numeric constant
arch/x86/boot/vesa.h:73: error: stray ‘\325’ in program
arch/x86/boot/vesa.h:73: error: stray ‘\376’ in program
arch/x86/boot/vesa.h:73: error: stray ‘\23’ in program
arch/x86/boot/vesa.h:73:2147: warning: missing terminating ' character
arch/x86/boot/vesa.h:73: error: missing terminating ' character
In file included from arch/x86/boot/video-mode.c:20:
arch/x86/boot/vesa.h:74: error: stray ‘\356’ in program
arch/x86/boot/vesa.h:74: error: stray ‘\330’ in program
arch/x86/boot/vesa.h:74: error: stray ‘\337’ in program
arch/x86/boot/vesa.h:78: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘can’
arch/x86/boot/vesa.h:81: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘version’
arch/x86/boot/vesa.h:82: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘herein’
arch/x86/boot/vesa.h:146:1: warning: null character(s) ignored
In file included from arch/x86/boot/video-mode.c:20:
arch/x86/boot/vesa.h:146: error: stray ‘\342’ in program
arch/x86/boot/vesa.h:146: error: stray ‘\202’ in program
arch/x86/boot/vesa.h:146: error: stray ‘\17’ in program
arch/x86/boot/vesa.h:146: error: stray ‘\370’ in program
arch/x86/boot/vesa.h:146: error: stray ‘\210’ in program
arch/x86/boot/vesa.h:146: error: stray ‘\205’ in program
arch/x86/boot/vesa.h:146: error: stray ‘\222’ in program
arch/x86/boot/vesa.h:146: error: stray ‘\323’ in program
In file included from arch/x86/boot/video-mode.c:20:
arch/x86/boot/vesa.h:150: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘can’
arch/x86/boot/vesa.h:153: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘version’
arch/x86/boot/vesa.h:154: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘herein’
arch/x86/boot/vesa.h:218:1: warning: null character(s) ignored
make[1]: *** [arch/x86/boot/video-mode.o] Error 1
make[1]: *** Waiting for unfinished jobs....
^Cmake[2]: *** Deleting file `arch/x86/boot/compressed/vmlinux.bin.gz'
make[1]: *** [__modpost] Interrupt
make: *** [modules] Interrupt
make[2]: *** [arch/x86/boot/compressed/vmlinux.bin.gz] Interrupt
make[1]: *** [arch/x86/boot/compressed/vmlinux] Interrupt
make: *** [bzImage] Interrupt

