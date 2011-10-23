Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab1JWVVs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 17:21:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41287 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1JWVVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 17:21:47 -0400
MIME-Version: 1.0
Date: Sun, 23 Oct 2011 23:21:46 +0200
X-Google-Sender-Auth: jih-VhnLfyICUjW8HG-_H7HLwiI
Message-ID: <CAMuHMdW6hC1JchxVL9-4f58a8Vg7cF+97BbKePxjEDHY3H8wNw@mail.gmail.com>
Subject: -next: NET_VENDOR_8390 dependencies
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/ethernet/8390/Kconfig:

config NET_VENDOR_8390
        bool "National Semi-conductor 8390 devices"
        default y
        depends on NET_VENDOR_NATSEMI && (AMIGA_PCMCIA || PCI || SUPERH || \
                   ISA || MCA || EISA || MAC || M32R || MACH_TX49XX || \
                   MCA_LEGACY || H8300 || ARM || MIPS || ZORRO || PCMCIA || \
                   EXPERIMENTAL)
        ---help---
          If you have a network (Ethernet) card belonging to this class, say Y
          and read the Ethernet-HOWTO, available from
          <http://www.tldp.org/docs.html#howto>.

          Note that the answer to this question doesn't directly affect the
          kernel: saying N will just cause the configurator to skip all
          the questions about Western Digital cards. If you say Y, you will be
          asked for your specific card in the following questions.

So NET_VENDOR_8390 depends on NET_VENDOR_NATSEMI.

drivers/net/ethernet/natsemi/Kconfig:

config NET_VENDOR_NATSEMI
        bool "National Semi-conductor devices"
        default y
        depends on MCA || MAC || MACH_JAZZ || PCI || XTENSA_PLATFORM_XT2000
        ---help---
          If you have a network (Ethernet) card belonging to this class, say Y
          and read the Ethernet-HOWTO, available from
          <http://www.tldp.org/docs.html#howto>.

          Note that the answer to this question doesn't directly affect the
          kernel: saying N will just cause the configurator to skip all
          the questions about National Semi-conductor devices. If you say Y,
          you will be asked for your specific card in the following questions.

But NET_VENDOR_NATSEMI will never be true for several of the other
dependencies of NET_VENDOR_8390 (e.g. AMIGA_PCMCIA, EISA, H8300, ARM,
ZORRO, PCMCIA)?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
