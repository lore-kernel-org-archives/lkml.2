Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1EVHHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 03:07:37 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46754 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855Ab1EVHHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 03:07:33 -0400
Subject: [GIT PULL] parisc updates for the 2.6.38 merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 May 2011 11:07:25 +0400
Message-ID: <1306048045.4092.3.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are is one major fix in this: hopefully a final end to some of the
segfault issues on the platform caused by aggressive icache speculation.
Also, all of the currently missing syscalls on the platform are wired up

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/parisc-2.6.git#for-linus

The short changelog is:

James Bottomley (6):
      [PARISC] wire up syncfs syscall
      [PARISC] wire up the fhandle syscalls
      [PARISC] wire up clock_adjtime syscall
      [PARISC] wire up fanotify syscalls
      [PARISC] prevent speculative re-read on cache flush
      [PARISC] only make executable areas executable

Meelis Roos (1):
      [PARISC] fix pacache .size with new binutils

And the diffstat:

 arch/parisc/include/asm/cacheflush.h |    5 +-
 arch/parisc/include/asm/pgtable.h    |    9 +-
 arch/parisc/include/asm/unistd.h     |    8 +-
 arch/parisc/kernel/cache.c           |   13 ++-
 arch/parisc/kernel/entry.S           |    3 +
 arch/parisc/kernel/head.S            |    5 +-
 arch/parisc/kernel/module.c          |   10 ++-
 arch/parisc/kernel/pacache.S         |    6 +-
 arch/parisc/kernel/sys_parisc32.c    |    8 +
 arch/parisc/kernel/syscall_table.S   |    6 +
 arch/parisc/kernel/vmlinux.lds.S     |    1 +
 arch/parisc/mm/init.c                |  260 +++++++++++++++++++---------------
 12 files changed, 205 insertions(+), 129 deletions(-)

James


