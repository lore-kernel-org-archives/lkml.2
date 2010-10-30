Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab0J3Msz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 08:48:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38080 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab0J3Msx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 08:48:53 -0400
Date: Sat, 30 Oct 2010 13:48:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] audit
Message-ID: <20101030124850.GY19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted fixes.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b64

Shortlog:
Al Viro (3):
      in untag_chunk() we need to do alloc_chunk() a bit earlier
      audit: make link()/linkat() match "attribute change" predicate
      audit mmap

Miloslav Trmac (1):
      Audit: add support to match lsm labels on user audit messages

Stephen Hemminger (1):
      audit: make functions static

Thomas Gleixner (3):
      audit: Call tty_audit_push_task() outside preempt disabled
      audit: Do not send uninitialized data for AUDIT_TTY_GET
      audit: Use rcu for task lookup protection

Diffstat:
 drivers/char/tty_audit.c                |   38 +++++++++++++-----
 include/asm-generic/audit_change_attr.h |    4 ++
 include/linux/audit.h                   |    9 ++++
 include/linux/tty.h                     |    9 ++--
 kernel/audit.c                          |   67 ++++++++++++++-----------------
 kernel/audit.h                          |    5 +--
 kernel/audit_tree.c                     |    9 +++-
 kernel/audit_watch.c                    |    4 +-
 kernel/auditfilter.c                    |   12 ++++++
 kernel/auditsc.c                        |   16 +++++++
 mm/mmap.c                               |    2 +
 mm/nommu.c                              |    2 +
 12 files changed, 118 insertions(+), 59 deletions(-)
