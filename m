Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab0GMHvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 03:51:24 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:38687 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752227Ab0GMHvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 03:51:21 -0400
From: Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: [PATCH 0/2] Graceful failures for XFS on an unconfigured loop device
Date: Tue, 13 Jul 2010 17:50:48 +1000
Message-Id: <1279007450-10457-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Run:

# mount -t xfs /dev/loop0 /mnt

on a freshly booted system and it won't like you anymore. This series fixes
the broken XFS error handling for dispatch errors on synchronous reads that
causes a hang, and then patches the panic it uncovers. With these two patches,
the mount fails gracefully.

The modification to blkdev_issue_flush is probably not the right place to check
for a valid q->make_request_fn. This just patches around the problem in the
simplest way possible. There's probably a better way to fix it - personally I'd
prefer that we don't even get to mounting a filesystem on an unconfigured loop
device...

