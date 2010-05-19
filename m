Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab0ESRYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:24:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33252 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab0ESRYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:24:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=Q/wcmcEKpIiwJ9m06ko2IE/wywhwllFr4qreh4aPKDyA4Bkl16Qb420p8/8qd3qMMz
         Og9pRFp8lsYVs+tb9KZgiu8qKyCcWfRq1PgPQxSwrsqNrFrWCMxe6ewKgnHM/RT+gXhA
         kJMkgXD2zKY+KqjPRO1Vao6GwtJ9AygfcLlS4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>, Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       "H . Peter Anvin" <hpa@zytor.com>, Ian Kent <raven@themaw.net>,
       "J . Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       Jeff Dike <jdike@addtoit.com>, Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       Jan Kara <jack@suse.cz>, Joern Engel <joern@logfs.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/8] Another set of ioctl bkl pushdown, almost the end
Date: Wed, 19 May 2010 19:24:07 +0200
Message-Id: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are very close to the end of struct file_operations::ioctl

What remains:
	sound/oss: coming soon
	v4l: Waiting for inclusion or approval in v4l tree
	udf: Approved but not yet included in udf tree
	logfs: Waiting for inclusion or approval in logfs tree

If you prefer some of the following patches to go through your tree,
please tell me quickly so that I drop them before pushing
for .35

Thanks.

---
Frederic Weisbecker (8):
  ecryptfs: Pushdown the bkl from ioctl
  autofs: Pushdown the bkl from ioctl
  autofs4: Pushdown the bkl from ioctl
  sunrpc: Pushdown the bkl from ioctl
  sunrpc: Pushdown the bkl from sunrpc cache ioctl
  uml: Pushdown the bkl from harddog_kern ioctl
  cris: Pushdown the bkl from ioctl
  ia64: Use unlocked_ioctl from perfmon

 arch/cris/arch-v10/drivers/gpio.c         |   30 ++++++++++++++++++---------
 arch/cris/arch-v10/drivers/i2c.c          |   24 ++++++++++++++++-----
 arch/cris/arch-v10/drivers/sync_serial.c  |   32 +++++++++++++++++++---------
 arch/cris/arch-v32/drivers/cryptocop.c    |   24 ++++++++++++++++-----
 arch/cris/arch-v32/drivers/mach-a3/gpio.c |   28 +++++++++++++++++--------
 arch/cris/arch-v32/drivers/mach-fs/gpio.c |   29 +++++++++++++++++---------
 arch/cris/arch-v32/drivers/sync_serial.c  |   30 +++++++++++++++++++--------
 arch/ia64/kernel/perfmon.c                |   22 ++++++++++----------
 arch/um/drivers/harddog_kern.c            |   18 +++++++++++++--
 fs/autofs/root.c                          |   19 ++++++++++++++--
 fs/autofs4/root.c                         |   22 ++++++++++++++++---
 fs/ecryptfs/file.c                        |   23 ++++++++++++++++----
 net/sunrpc/cache.c                        |   13 +++++++++--
 net/sunrpc/rpc_pipe.c                     |   18 +++++++++++++--
 14 files changed, 240 insertions(+), 92 deletions(-)

