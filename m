Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982Ab2FBUfv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 16:35:51 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:52367 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759804Ab2FBUfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 16:35:50 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Breeds <tony@bakeyournoodle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] h8300 fixes
Date: Sat,  2 Jun 2012 22:35:34 +0200
Message-Id: <1338669339-23214-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Sato-san, Andrew,

The following patch set makes h8300 defconfig build again.
Due to lack of hardware, there's no guarantee this makes it actually boot.

I used the h8300-elf-gcc from
http://kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/.

I had two issues with this compiler, though:

1. I got 2 ICEs:

fs/read_write.c: In function 'sys_pread64':
fs/read_write.c:514:1: internal compiler error: in based_loc_descr, at dwarf2out.c:13636
Please submit a full bug report,
with preprocessed source if appropriate.
See <http://gcc.gnu.org/bugs.html> for instructions.
make[4]: *** [fs/read_write.o] Error 1
  CC      fs/dcache.o
fs/dcache.c: In function '__d_path':
fs/dcache.c:2662:1: internal compiler error: in based_loc_descr, at dwarf2out.c:13636
Please submit a full bug report,
with preprocessed source if appropriate.
See <http://gcc.gnu.org/bugs.html> for instructions.

2. I also got several warnings of the form:

warning: format '%zx' expects argument of type 'size_t', but argument 4 has type 'unsigned int'

while the actual parameter type is size_t, not unsigned int. 
Could this be because the compiler is h8300-elf-gcc and not h8300-linux-gcc?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
