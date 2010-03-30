Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab0C3OVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 10:21:08 -0400
Received: from rs22.lvs.iif.hu ([193.225.14.172]:44928 "EHLO rs22.lvs.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539Ab0C3OU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:20:59 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Phillip Lougher <phillip@lougher.demon.co.uk>,
       Phillip Lougher <phillip.lougher@gmail.com>,
       linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Cc: Ferenc Wagner <wferi@niif.hu>
Subject: [PATCH 0/3] RFC: direct MTD support for SquashFS
Date: Tue, 30 Mar 2010 15:32:46 +0200
Message-Id: <1269955969-26123-1-git-send-email-wferi@niif.hu>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <87mxxxltk6.fsf@tac.ki.iif.hu>
References: <87mxxxltk6.fsf@tac.ki.iif.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is another, very different take on the subject.  It isn't a real
plugin system, but touches as little existing code as possible, and
still quite easy to extend if needed.  The MTD with LZMA case is somewhat
challenged, as the current interface mismatch requires extra copying.
It seems fairly easy to change the kernel decompressor interface to
scatter/gather operation in the future, to do away with this.

This patch does not consider SQUASHFS_METADATA_SIZE during buffer_head
allocation in block.c, on the principle of hands-off.

Extra question: does squashfs_put_super require BKL protection?

Comments welcome.

Regards,
Feri.

Ferenc Wagner (3):
  squashfs: parametrize decompressors on buffer_head operations
  squashfs: gather everything block device specific into block.c
  squashfs: add MTD backend

 fs/squashfs/Kconfig        |    2 +-
 fs/squashfs/Makefile       |    6 +-
 fs/squashfs/backend.c      |   63 +++++++++++++++
 fs/squashfs/backend.h      |   12 +++
 fs/squashfs/block.c        |   42 +++++++---
 fs/squashfs/decompressor.h |    8 +-
 fs/squashfs/lzma_wrapper.c |   11 ++-
 fs/squashfs/mtd.c          |  179 ++++++++++++++++++++++++++++++++++++++++++++
 fs/squashfs/squashfs.h     |   22 +++++-
 fs/squashfs/super.c        |   45 +++---------
 fs/squashfs/zlib_wrapper.c |   13 ++--
 11 files changed, 337 insertions(+), 66 deletions(-)
 create mode 100644 fs/squashfs/backend.c
 create mode 100644 fs/squashfs/backend.h
 create mode 100644 fs/squashfs/mtd.c

