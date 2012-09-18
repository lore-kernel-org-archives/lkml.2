Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab2IRSPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:15:35 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50433 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2IRSPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:15:30 -0400
MIME-Version: 1.0
In-Reply-To: <1347991700-22730-1-git-send-email-geert@linux-m68k.org>
References: <1347991700-22730-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 18 Sep 2012 20:15:29 +0200
X-Google-Sender-Auth: D9HEcOLrb3v6OHcpB3h4cGG9wb4
Message-ID: <CAMuHMdUDQTUvFNavKy6VX1LNqy4jJ_OyMusu86eVd7QspzbUCw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.6-rc6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 8:08 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.6-rc6 to v3.6-rc5[3], the summaries are:
>   - build errors: +14/-16

14 regressions:
  + arch/powerpc/mm/tlb_nohash_low.S: Error: bad expression:  => 212,
234, 232, 230
  + arch/powerpc/mm/tlb_nohash_low.S: Error: junk at end of line,
first unrecognized character is `r':  => 212, 234, 232, 230
  + arch/powerpc/mm/tlb_nohash_low.S: Error: missing ')':  => 212, 234, 232, 230

44x/currituck_defconfig

  + error: ci13xxx_imx.c: undefined reference to `devm_clk_get':  =>
.devinit.text+0x4b154)
  + error: exynos-rng.c: undefined reference to `devm_clk_get':  =>
.devinit.text+0x2da54)
  + error: flexcan.c: undefined reference to `devm_clk_get':  =>
.devinit.text+0x43148), .devinit.text+0x430c8)

powerpc-randconfig

  + error: fore200e.c: relocation truncated to fit: R_PPC64_REL24
against symbol `.ktime_get_real' defined in .text section in
kernel/built-in.o:  => (.text+0x1ff8928)
  + error: fore200e.c: relocation truncated to fit: R_PPC64_REL24
against symbol `.msecs_to_jiffies' defined in .text section in
kernel/built-in.o:  => (.text+0x1ff9068)
  + error: fore200e.c: relocation truncated to fit: R_PPC64_REL24
against symbol `.panic' defined in .text.unlikely section in
kernel/built-in.o:  => (.text+0x1ff9be4)
  + error: fore200e.c: relocation truncated to fit: R_PPC64_REL24
against symbol `_restgpr0_14' defined in .text.save.restore section in
arch/powerpc/lib/built-in.o:  => (.text+0x1ff876c)
  + error: fore200e.c: relocation truncated to fit: R_PPC64_REL24
against symbol `_savegpr0_20' defined in .text.save.restore section in
arch/powerpc/lib/built-in.o:  => (.text+0x1ff8774)
  + error: fore200e.c: relocation truncated to fit: R_PPC64_REL24
against symbol `_savegpr0_23' defined in .text.save.restore section in
arch/powerpc/lib/built-in.o:  => (.text+0x1ff9358)
  + error: fore200e.c: relocation truncated to fit: R_PPC64_REL24
against symbol `_savegpr0_29' defined in .text.save.restore section in
arch/powerpc/lib/built-in.o:  => (.text+0x1ff8ebc)

powerpc-allyesconfig

  + kernel/sys.c: error: 'mmap_min_addr' undeclared (first use in this
function): 1868:34 => 1868:37, 1868:34

sh-allyesconfig, sh-allmodconfig, sh-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/5424/ (117 out of 116 configs)

Doh, forgot to update my scripts for the increase in configs...

> [3] http://kisskb.ellerman.id.au/kisskb/head/5400/ (all 116 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
