Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab0GINro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:47:44 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:50244 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755882Ab0GINrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:47:43 -0400
Date: Fri, 9 Jul 2010 15:47:39 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Greg Ungerer <gerg@uclinux.org>,
       Thiago Farina <tfransosi@gmail.com>,
       Sonic Zhang <sonic.zhang@analog.com>,
       Mike Frysinger <vapier@gentoo.org>, Graf Yang <graf.yang@analog.com>,
       Alan Cox <alan@linux.intel.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 00/11] Removing dead code
Message-ID: <cover.1278682302.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

        As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

	      I've been running a check on the arch/arm sourcetree for
config Items not defined in Kconfig and found 33 such
cases. Sourcecode
blocks depending on these Items are not reachable from a vanilla
kernel -- dead code. I've seen such dead blocks made on purpose
e.g. while integrating new features into the kernel but generally
they're just useless.

	Each of the patches in this patchset removes on such dead
config Item, I'd be glad if you consider applying them. I've been
doing deeper analysis of such issues before and can do so again but
I'm not so sure they were fastly usefull. Unfortunately arm doesn't
allow some allyesconfig build covering all of that code so I couldn't
build-test all of them, sorry for that.

        Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

        Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

Christoph Egger (11):
  Removing dead 68328_SERIAL_UART
  Removing dead CONSOLE_*
  Removing dead PP04
  Removing dead (ALMA_ANS | DRAGONIXVZ | M68EZ328ADS)
  Removing dead ETRAX_RS485_ON_PORT_G
  Removing dead ETRAX_RS485_LTC1387
  Removing dead ETRAX_EXTERN_PB6CLK_ENABLED
  Removing dead ETRAX_SERIAL_PROC_ENTRY
  Removing dead SERIAL_BFIN_{HARD_,}CTSRTS
  Removing dead SERIAL_BFIN_SPORT_CTSRTS
  Removing dead SERIAL_BFIN_SPORT_CONSOLE

 drivers/serial/68328serial.c     |   16 ++----
 drivers/serial/68328serial.h     |    5 --
 drivers/serial/68360serial.c     |   26 +---------
 drivers/serial/bfin_5xx.c        |  103 --------------------------------------
 drivers/serial/bfin_sport_uart.c |  100 ++-----------------------------------
 drivers/serial/crisv10.c         |   71 --------------------------
 6 files changed, 12 insertions(+), 309 deletions(-)

