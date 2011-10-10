Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1JJIIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:08:17 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37824 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752455Ab1JJIIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:08:16 -0400
From: Joe Perches <joe@perches.com>
To: Jan Kara <jack@suse.cz>
Cc: NamJae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] udf: Change some KERN_<level>s and logging neatening
Date: Mon, 10 Oct 2011 01:08:01 -0700
Message-Id: <cover.1318233879.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I reviewed your patch and think it's too large
for others to review because it combines multiple
things into a single patch.

I think that adding struct super_block * to udb_debug
isn't necessary or particularly useful.

Here are the changes to your original patch that I made:

Separate a single large patch into reviewable chunks.
Don't convert every message type to udf_<foo>.

Joe Perches (6):
  udf: Promote some debugging messages to udf_error
  udf: Rename udf_error to udf_err
  udf: Rename udf_warn to udf_warn
  udf: Convert printks to pr_<level>
  udf: Neaten logging output, use vsprintf extension %pV
  udf: Neaten udf_debug uses

 fs/udf/balloc.c    |   14 ++--
 fs/udf/directory.c |    8 +-
 fs/udf/inode.c     |   36 ++++-----
 fs/udf/lowlevel.c  |    2 +-
 fs/udf/misc.c      |   24 ++++---
 fs/udf/namei.c     |    5 +-
 fs/udf/partition.c |   11 +--
 fs/udf/super.c     |  214 +++++++++++++++++++++++-----------------------------
 fs/udf/truncate.c  |   21 ++---
 fs/udf/udfdecl.h   |   35 ++++++---
 fs/udf/udftime.c   |    3 +-
 fs/udf/unicode.c   |    6 +-
 12 files changed, 178 insertions(+), 201 deletions(-)

-- 
1.7.6.405.gc1be0

