Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab2IROxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 10:53:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39876 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163Ab2IROxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:53:31 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Roland McGrath <roland@hack.frob.com>, Pedro Alves <palves@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH -mm v2 0/2] coredump: add a new elf note with siginfo of the signal
Date: Tue, 18 Sep 2012 16:53:13 +0200
Message-Id: <1347979995-1452-1-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changeset is on top of "add support for %d=__get_dumpable() in core name"
patch currently in -mm.

Changes since previous version:
* save data in the form of siginfo_t structure instead of inventing
  yet another representation of this data
* use copy_siginfo_to_user to copy it

Denys Vlasenko (2):
  coredump: pass siginfo_t* to do_coredump() and below, not merely
    signr
  coredump: add a new elf note with siginfo of the signal

 fs/binfmt_aout.c         |    2 +-
 fs/binfmt_elf.c          |   36 +++++++++++++++++++++++++++---------
 fs/binfmt_elf_fdpic.c    |    6 +++---
 fs/binfmt_flat.c         |    2 +-
 fs/coredump.c            |   10 +++++-----
 include/linux/binfmts.h  |    2 +-
 include/linux/coredump.h |    4 ++--
 include/linux/elf.h      |    5 +++++
 kernel/signal.c          |    2 +-
 9 files changed, 46 insertions(+), 23 deletions(-)

-- 
1.7.7.6

