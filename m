Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab2DTLMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 07:12:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56457 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab2DTLML convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 07:12:11 -0400
MIME-Version: 1.0
In-Reply-To: <4F911568.7050601@pr.hu>
References: <4F911568.7050601@pr.hu>
Date: Fri, 20 Apr 2012 13:12:10 +0200
X-Google-Sender-Auth: aQOkRZ9_6AkVMOYEDMb5KP2c_HU
Message-ID: <CAMuHMdWCMP8L=k8tWiXv6Mcb5u6iTCx3fb7_mTGVyQSE7V=r_w@mail.gmail.com>
Subject: Re: VESA and VGA16 framebuffer drivers clash sometimes
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Boszormenyi Zoltan <zboszor@pr.hu>
Cc: linux-kernel@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/20 Boszormenyi Zoltan <zboszor@pr.hu>:
> on an embedded x86 board with Intel Atom, text on vesafb
> gets distorted if both vesafb and vga16fb are compiled in.
> The strange thing is that it doesn't happen all the time but
> about once out of 15 boots.
>
> The distortion looks like this:
> http://www.postgresql-support.de/private/IMG_7221.jpg
>
> The relevant kernel messages:
>
> Apr 13 11:14:30 term002 kernel: vesafb: mode is 800x600x16, linelength=1600,
> pages=7
> Apr 13 11:14:30 term002 kernel: vesafb: scrolling: redraw
> Apr 13 11:14:30 term002 kernel: vesafb: Truecolor: size=0:5:6:5,
> shift=0:11:5:0
> Apr 13 11:14:30 term002 kernel: vesafb: framebuffer at 0xa0000000, mapped to
> 0xdf580000, using 1875k, total 8128k
> Apr 13 11:14:30 term002 kernel: Console: switching to colour frame buffer
> device 100x37
> Apr 13 11:14:30 term002 kernel: fb0: VESA VGA frame buffer device
> Apr 13 11:14:30 term002 BOOTLOG: Terminal startup
> Apr 13 11:14:30 term002 kernel: vga16fb: mapped to 0xc00a0000
> Apr 13 11:14:30 term002 kernel: fbcon: VGA16 VGA (fb1) is primary device
> Apr 13 11:14:30 term002 kernel: fbcon: Remapping primary device, fb1, to tty
> 1-63
> Apr 13 11:14:30 term002 kernel: fb1: VGA16 VGA frame buffer device
>
> It's strange that vga16fb is always detected as primary
> and vesafb gets remapped to fb1 even when there is no
> screen distortion. The kernel is compiled for SMP.

IIRC, the request_region()/request_mem_region() calls in vga16fb.c that would
avoid this were removed several years ago. Unfortunately I don't remember
anymore why. Google or full-history-linux may help you...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
