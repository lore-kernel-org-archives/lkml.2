Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab2GKN6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:58:30 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37424 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab2GKN62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:58:28 -0400
Date: Wed, 11 Jul 2012 06:58:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Subject: [GIT PATCH] driver core (printk really) fixes for 3.5-rc6
Message-ID: <20120711135824.GA19620@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.5-rc6

for you to fetch changes up to 5becfb1df5ac8e491338e64b1029685ccad4b39c:

  kmsg: merge continuation records while printing (2012-07-09 12:15:42 -0700)

----------------------------------------------------------------
printk fixes for 3.5-rc6

Here are some more printk fixes for 3.5-rc6.  They resolve all known
outstanding issues with the printk changes that have been happening.  They have
been tested by the people reporting the problems.

This hopefully should be it for the printk stuff for 3.5-final.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Kay Sievers (6):
      kmsg: escape the backslash character while exporting data
      kmsg: add the facility number to the syslog prefix
      kmsg: properly handle concurrent non-blocking read() from /proc/kmsg
      kmsg: make sure all messages reach a newly registered boot console
      kmsg: /proc/kmsg - support reading of partial log records
      kmsg: merge continuation records while printing

liu chuansheng (1):
      printk: replacing the raw_spin_lock/unlock with raw_spin_lock/unlock_irq

 kernel/printk.c | 202 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 126 insertions(+), 76 deletions(-)
