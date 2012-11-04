Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2KDNeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 08:34:20 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36039 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab2KDNeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 08:34:19 -0500
Date: Sun, 4 Nov 2012 13:34:13 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Subject: lzma targets always get rebuilt
Message-ID: <20121104133412.GA19301@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ emake -j2 O=../build/omap4/ uImage V=2
...
  CHK     include/generated/compile.h
echo '  Kernel: arch/arm/boot/Image is ready'
  Kernel: arch/arm/boot/Image is ready
  LZMA    arch/arm/boot/compressed/piggy.lzma - due to command line change
  AS      arch/arm/boot/compressed/piggy.lzma.o - due to: arch/arm/boot/compressed/piggy.lzma
  LD      arch/arm/boot/compressed/vmlinux - due to: arch/arm/boot/compressed/piggy.lzma.o
  OBJCOPY arch/arm/boot/zImage - due to: arch/arm/boot/compressed/vmlinux
echo '  Kernel: arch/arm/boot/zImage is ready'
  Kernel: arch/arm/boot/zImage is ready
  UIMAGE  arch/arm/boot/uImage - due to: arch/arm/boot/zImage
Image Name:   Linux-3.7.0-rc3+
Created:      Sun Nov  4 13:31:13 2012
Image Type:   ARM Linux Kernel Image (uncompressed)
Data Size:    1756112 Bytes = 1714.95 kB = 1.67 MB
Load Address: 0x80008000
Entry Point:  0x80008000
echo '  Image arch/arm/boot/uImage is ready'
  Image arch/arm/boot/uImage is ready

This happens every time - Kbuild always thinks that the LZMA command has
changed.  Here's the .cmd file for this:

cmd_arch/arm/boot/compressed/piggy.lzma := (cat arch/arm/boot/compressed/../Image | lzma -9 && printf \\\\200\\\\111\\\\113\\\\000) > arch/arm/boot/compressed/piggy.lzma || (rm -f arch/arm/boot/compressed/piggy.lzma ; false)

I suspect it's those multiple \ which are causing problems...

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
