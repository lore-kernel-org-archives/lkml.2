Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0DPHcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 03:32:10 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:46296 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab0DPHcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 03:32:08 -0400
Message-ID: <4BC81273.4000406@petalogix.com>
Date: Fri, 16 Apr 2010 09:32:03 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Move isa_dma_bridge_buggy to generic location
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Microblaze misses isa_dma_bridge_buggy and I can easily add it but I 
think that we should move isa_dma_bridge_buggy to generic location. What 
is the correct location?

This is what all archs have in headers.

#ifdef CONFIG_PCI
extern int isa_dma_bridge_buggy;
#else
#define isa_dma_bridge_buggy 	(0)
#endif

Below is just grep where isa_dma_bridge_buggy is.

Thanks,
Michal


arch/mips/include/asm/dma.h:310:extern int isa_dma_bridge_buggy;
arch/mips/include/asm/dma.h:312:#define isa_dma_bridge_buggy    (0)
arch/arm/include/asm/dma.h:144:extern int isa_dma_bridge_buggy;
arch/arm/include/asm/dma.h:146:#define isa_dma_bridge_buggy    (0)
arch/frv/include/asm/dma.h:120:extern int isa_dma_bridge_buggy;
arch/frv/include/asm/dma.h:122:#define isa_dma_bridge_buggy     (0)
arch/powerpc/include/asm/dma.h:352:extern int isa_dma_bridge_buggy;
arch/powerpc/include/asm/dma.h:354:#define isa_dma_bridge_buggy (0)
arch/ia64/include/asm/dma.h:15:  extern int isa_dma_bridge_buggy;
arch/ia64/include/asm/dma.h:17:# define isa_dma_bridge_buggy    (0)
arch/mn10300/include/asm/dma.h:113:extern int isa_dma_bridge_buggy;
arch/mn10300/include/asm/dma.h:115:#define isa_dma_bridge_buggy         (0)
arch/parisc/include/asm/dma.h:180:extern int isa_dma_bridge_buggy;
arch/parisc/include/asm/dma.h:182:#define isa_dma_bridge_buggy  (0)
arch/sparc/include/asm/dma.h:87:extern int isa_dma_bridge_buggy;
arch/sparc/include/asm/dma.h:89:#define isa_dma_bridge_buggy    (0)
arch/m68k/include/asm/dma.h:489:#define isa_dma_bridge_buggy    (0)
arch/cris/include/asm/dma.h:16:extern int isa_dma_bridge_buggy;
arch/cris/include/asm/dma.h:18:#define isa_dma_bridge_buggy     (0)
arch/sh/include/asm/dma.h:154:extern int isa_dma_bridge_buggy;
arch/sh/include/asm/dma.h:156:#define isa_dma_bridge_buggy      (0)
arch/alpha/include/asm/dma.h:370:extern int isa_dma_bridge_buggy;
arch/alpha/include/asm/dma.h:372:#define isa_dma_bridge_buggy   (0)
arch/xtensa/include/asm/dma.h:56:extern int isa_dma_bridge_buggy;
arch/xtensa/include/asm/dma.h:58:#define isa_dma_bridge_buggy   (0)
arch/x86/include/asm/dma.h:313:extern int isa_dma_bridge_buggy;
arch/x86/include/asm/dma.h:315:#define isa_dma_bridge_buggy     (0)
arch/x86/kernel/cpu/cyrix.c:273:                isa_dma_bridge_buggy = 2;
drivers/pci/pci.c:33:int isa_dma_bridge_buggy;
drivers/pci/pci.c:34:EXPORT_SYMBOL(isa_dma_bridge_buggy);
drivers/pci/quirks.c:28:#include <asm/dma.h>    /* isa_dma_bridge_buggy */
drivers/pci/quirks.c:135:       if (!isa_dma_bridge_buggy) {
drivers/pci/quirks.c:136:               isa_dma_bridge_buggy=1;
sound/core/isadma.c:92: if (!isa_dma_bridge_buggy)
sound/core/isadma.c:98:  * isa_dma_bridge_buggy is set.
sound/core/isadma.c:101:        if (!isa_dma_bridge_buggy)
sound/oss/ad1848.c:1340:                if(!isa_dma_bridge_buggy)
sound/oss/ad1848.c:1348:                if(!isa_dma_bridge_buggy)
sound/oss/ad1848.c:1375:                if(!isa_dma_bridge_buggy)
sound/oss/ad1848.c:1383:                if(!isa_dma_bridge_buggy)
sound/oss/soundcard.c:558:              isa_dma_bridge_buggy = dmabug;
sound/oss/dmabuf.c:77:  if(isa_dma_bridge_buggy==2)
sound/oss/dmabuf.c:652:         if(!isa_dma_bridge_buggy)
sound/oss/dmabuf.c:675:         if(!isa_dma_bridge_buggy)
sound/oss/dmabuf.c:1042:                if(!isa_dma_bridge_buggy)
sound/oss/dmabuf.c:1046:                if(!isa_dma_bridge_buggy)
sound/oss/dmabuf.c:1143:                if(!isa_dma_bridge_buggy)
sound/oss/dmabuf.c:1147:                if(!isa_dma_bridge_buggy)



-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
