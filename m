Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab0JFSGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:06:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759569Ab0JFSGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:06:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/8] arm: use generic header files where possible
Date: Wed,  6 Oct 2010 20:06:12 +0200
Message-Id: <1286388380-20646-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:EgUTsECGAp25lVzHPwEkquAfTN+DscmyNBCkQAA90JK
 vZXYNo/cV7G+TwEyeSmkXz3RP906Y+yoATlHN16r6eBtMSDfyO
 jLfNgNkO0aydueC3RqnoYS/6gAEjJTtLztm1Ap6dyLyNIq82EI
 LpAe5lWZf6MudDjxC8H2vNKUNHrAM74wZsk0wWbNvlTmxXISOQ
 cJJvwL8WTF06ciChE2cEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many header files in the arm architecture already use the
common asm-generic implementation, but I found a number that
don't yet.

A signficant amount of code can be saved by either directly
falling back to the common implementation, where it has no
effect on compilation, or by using a combination of the
common file with arm-specific additions in the other cases.

In order to make this more appropriate for both review
and bisection in case of problems, I first change the headers
to be identical to the common version, aside from the
introductory copyright statement and include guard, and
in the second step replace the common parts with an
#include.

Arnd Bergmann (8):
  arm: generalize IPC header files
  arm: trivial changes to make headers more generic
  arm: remove unused asm/segment.h contents
  arm: make asm/ioctls.h mostly generic
  arm: generalize asm/posix_types.h
  arm: generalize asm/signal.h
  arm: generalize asm/termios.h
  arm: remove generic asm header file contents

 arch/arm/include/asm/ioctls.h      |   84 +---------------
 arch/arm/include/asm/ipcbuf.h      |   30 +-----
 arch/arm/include/asm/msgbuf.h      |   32 +------
 arch/arm/include/asm/param.h       |   32 +------
 arch/arm/include/asm/parport.h     |   19 +----
 arch/arm/include/asm/posix_types.h |   68 ++++--------
 arch/arm/include/asm/segment.h     |   12 +--
 arch/arm/include/asm/sembuf.h      |   26 +-----
 arch/arm/include/asm/serial.h      |   20 +----
 arch/arm/include/asm/shmbuf.h      |   43 +--------
 arch/arm/include/asm/signal.h      |  147 +-------------------------
 arch/arm/include/asm/socket.h      |   66 +------------
 arch/arm/include/asm/sockios.h     |   14 +---
 arch/arm/include/asm/termbits.h    |  199 +-----------------------------------
 arch/arm/include/asm/termios.h     |   93 +-----------------
 arch/arm/include/asm/timex.h       |    8 +--
 arch/arm/include/asm/types.h       |   32 +------
 17 files changed, 44 insertions(+), 881 deletions(-)
