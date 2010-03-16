Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab0CPCfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 22:35:18 -0400
Received: from mail-qy0-f191.google.com ([209.85.221.191]:41127 "EHLO
	mail-qy0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab0CPCfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 22:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:cc:references:in-reply-to:subject:date:message-id:mime-version
         :content-type:content-transfer-encoding:x-mailer:thread-index
         :content-language;
        b=EUdxSUb7dPYSIpYqirv/nYwC784++U1Uc8q0Tn4bT/ccDmtDp8UOheMy4dTUAD46IQ
         IhO4zK2V8NdCsk5jKORL60nH2zFffJ33Z7Y2sR+o0NuctkBUfGwqoGam+tB8Eb/9mzRG
         v/1Rk5e4SJIeyO3QoiasFPAWHhHnIhdTdld7A=
From: "Will L Givens" <wlgivens@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-alpha@vger.kernel.org>
References: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com>
In-Reply-To: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com>
Subject: RE: Will's kernel compilation error
Date: Mon, 15 Mar 2010 21:34:55 -0500
Message-ID: <001d01cac4b1$44711e80$cd535b80$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcrElJbwrW9iduizQVOineCjTjJafwAGdRgw
Content-Language: en-us
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  AS      arch/alpha/lib/strncpy.o
> >  CC      arch/alpha/lib/udelay.o
> >  AR      arch/alpha/lib/lib.a
> >  LD      vmlinux.o
> >  MODPOST vmlinux.o
> > WARNING: modpost: Found 1 section mismatch(es).
> > To see full details build your kernel with:
> > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> >  GEN     .version
> >  CHK     include/generated/compile.h
> >  UPD     include/generated/compile.h
> >  CC      init/version.o
> >  LD      init/built-in.o
> >  LD      .tmp_vmlinux1
> > kernel/built-in.o: In function `kthread_create':
> > (.text+0x1ece4): relocation truncated to fit: GPREL16 against symbol
> > `kthreadd_task' defined in .sbss section in kernel/built-in.o
> > kernel/built-in.o: In function `check_cpu_itimer':
> > (.text+0x21784): relocation truncated to fit: GPREL16 against `.sbss'
> > kernel/built-in.o: In function `check_cpu_itimer':
> > (.text+0x2179c): relocation truncated to fit: GPREL16 against `.sbss'
> > kernel/built-in.o: In function `free_nsproxy':
> > (.text+0x23064): relocation truncated to fit: GPREL16 against `.sbss'
> > kernel/built-in.o: In function `create_new_namespaces':
> > (.text+0x230a4): relocation truncated to fit: GPREL16 against `.sbss'
> > kernel/built-in.o: In function `create_new_namespaces':
> > (.text+0x23254): relocation truncated to fit: GPREL16 against `.sbss'

Found a patch for the 'section mismatch'... the GPREL16 error still remains
though.

[root@jericho linux]# cat ../kernels/linux-2.6.x-PCI_REGISER_SET_VGA.patch
---
a/drivers/pci/pci.c~pci-kill-off-pci_register_set_vga_state-symbol-export
+++ a/drivers/pci/pci.c
@@ -3023,7 +3023,6 @@  EXPORT_SYMBOL(pcim_pin_device);
 EXPORT_SYMBOL(pci_disable_device);
 EXPORT_SYMBOL(pci_find_capability);
 EXPORT_SYMBOL(pci_bus_find_capability);
-EXPORT_SYMBOL(pci_register_set_vga_state);
 EXPORT_SYMBOL(pci_release_regions);
 EXPORT_SYMBOL(pci_request_regions);
 EXPORT_SYMBOL(pci_request_regions_exclusive);

