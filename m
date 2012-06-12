Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2FLPgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:36:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57361 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2FLPgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:36:16 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/2] Add FALLOC_FL_ZERO_RANGE to fallocate
Date: Tue, 12 Jun 2012 17:36:02 +0200
Message-Id: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the FALLOC_FL_ZERO_RANGE operation mode to fallocate,
resembling the similar XFS ioctl.  The new mode can be used with
or without FALLOC_FL_KEEP_SIZE, but of course not together with
FALLOC_FL_PUNCH_HOLE.

Other filesystems can then provide the same functionality with a
standard system call.

Paolo
---
 fs/open.c              |    8 +++++++-
 fs/xfs/xfs_file.c      |   34 +++++++++++++++++++++++-----------
 include/linux/falloc.h |    1 +
 3 files changed, 32 insertions(+), 13 deletions(-)

