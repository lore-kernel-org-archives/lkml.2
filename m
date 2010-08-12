Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069Ab0HLWaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 18:30:00 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41732 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760967Ab0HLW36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 18:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sLsziNMhVswdURAGhMMXDbNWR/lB0jobW1Fzi6G5Buolu132qbNKEjY8X233MueFBf
         brmlLB0YGoih7yDdAcC9YNCkyhmv7ooTla4CX8Pp8OMcLv1zKmRxCVMmA32lkN5NmBiA
         YegNjge6KhNpFsRbnLbP0EmUfxOrK+Ls94hAQ=
From: bchociej@gmail.com
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        cmm@us.ibm.com, bcchocie@us.ibm.com, mrlupfer@us.ibm.com,
        crscott@us.ibm.com, bchociej@gmail.com, mlupfer@gmail.com,
        conscott@vt.edu
Subject: [PATCH 0/2] Btrfs-progs: Add support for hot data migration
Date: Thu, 12 Aug 2010 17:29:35 -0500
Message-Id: <1281652177-23562-1-git-send-email-bchociej@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces functionality into btrfsctl and mkfs.btrfs to
support the kernel patches for hot data tracking and migration to SSD
with Btrfs. New functionality includes a -h option to mkfs.btrfs to
preallocate approrpiate block group types for SSD data migration, and
also includes additional options for btrfsctl to interact with the new
ioctls introduced by the kernel patches.


DIFFSTAT:

 btrfsctl.c    |  111 +++++++++++++++++++++++++++++++++++++++-
 ctree.h       |    2 +
 extent-tree.c |    2 +-
 ioctl-test.c  |    3 +
 ioctl.h       |   24 +++++++++
 mkfs.c        |  131 ++++++++++++++++++++++++++++++++++++++++-------
 utils.c       |    1 +
 volumes.c     |   73 +++++++++++++++++++++++++-
 volumes.h     |    3 +-
 9 files changed, 326 insertions(+), 24 deletions(-)


Signed-off-by: Ben Chociej <bchociej@gmail.com>
Signed-off-by: Matt Lupfer <mlupfer@gmail.com>
Tested-by: Conor Scott <conscott@vt.edu>
