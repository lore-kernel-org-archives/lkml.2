Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab2LKXMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 18:12:32 -0500
Received: from www.linutronix.de ([62.245.132.108]:44881 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab2LKXMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 18:12:31 -0500
From: Benedikt Spranger <b.spranger@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: hjk@hansjkoch.de, gregkh@linuxfoundation.org,
        Alexander.Frank@eberspaecher.com,
        Benedikt Spranger <b.spranger@linutronix.de>
Subject: [PATCH 0/2] uio: open(), mmap(), close()
Date: Wed, 12 Dec 2012 00:12:00 +0100
Message-Id: <1355267523-19724-1-git-send-email-b.spranger@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After open(), mmap(), close() POSIX 1003.1 mmap() declares the mmaped pointer
valid. Add a warning to the documentation to inform UIO users keep this
behaviour into account.
While the inode parameter of in tree UIO kernel drivers is unused by
open/release hooks, remove teh inode parateter. This would help to process
the release hook in an unmap context.

Benedikt Spranger (2):
  uio: add warning to documentation
  uio: do not expose inode to uio open/release hooks

 Documentation/DocBook/uio-howto.tmpl |   11 ++++++++---
 drivers/uio/uio.c                    |    4 ++--
 include/linux/uio_driver.h           |    4 ++--
 3 files changed, 12 insertions(+), 7 deletions(-)

-- 
1.7.10.4

