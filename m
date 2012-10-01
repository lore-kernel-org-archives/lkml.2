Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab2JATZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:25:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab2JATZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:25:17 -0400
Date: Mon, 1 Oct 2012 15:25:14 -0400
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 3.7
Message-ID: <20121001192514.GB3562@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull dlm updates from tag:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git dlm-3.7

There are two main patches in this set, both related to the userland
dlm_controld daemon.  The first fixes a deadlock between dlm_controld and
the dlm_send workqueue when both access configfs data simultaneously.  The
second reworks some code to get around a long standing, but intentional,
unlock balance warning.  The userland daemon no longer takes a lock that
is later released from the kernel.  The other commits are minor fixes and
changes.

Thanks,
Dave

David Teigland (3):
      dlm: fix deadlock between dlm_send and dlm_controld
      dlm: fix uninitialized spinlock
      dlm: fix unlock balance warnings

Sasha Levin (1):
      dlm: check the maximum size of a request from user

Xue Ying (1):
      dlm: remove redundant variable assignments

Ying Xue (2):
      dlm: convert add_sock routine return value type to void
      dlm: cleanup send_to_sock routine

 fs/dlm/ast.c          |    4 +-
 fs/dlm/config.c       |   79 ++++--------------
 fs/dlm/config.h       |    2 -
 fs/dlm/dlm_internal.h |   46 ++++++++---
 fs/dlm/lockspace.c    |   15 +++-
 fs/dlm/lowcomms.c     |  215 +++++++++++++++++++++++++++++++++++++++++--------
 fs/dlm/lowcomms.h     |    2 +
 fs/dlm/main.c         |    2 +
 fs/dlm/member.c       |   17 ++--
 fs/dlm/rcom.c         |    2 +-
 fs/dlm/recoverd.c     |   27 ++++---
 fs/dlm/recoverd.h     |    1 -
 fs/dlm/user.c         |    7 ++
 13 files changed, 289 insertions(+), 130 deletions(-)

