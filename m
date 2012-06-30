Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab2F3Ewt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 00:52:49 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:51435 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab2F3Ews (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 00:52:48 -0400
Date: Sat, 30 Jun 2012 00:52:44 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Subject: [GIT PATCH] driver core fixes for 3.5-rc5
Message-ID: <20120630045244.GA2333@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6b16351acbd415e66ba16bf7d473ece1574cf0bc:

  Linux 3.5-rc4 (2012-06-24 12:53:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.5-rc5

for you to fetch changes up to d36208227d03c44c0a74cd702cc94528162e1703:

  printk: Optimize if statement logic where newline exists (2012-06-29 16:55:35 -0400)

----------------------------------------------------------------
Driver Core fixes for 3.5-rc5

Here is a number of printk() fixes, specifically a few reported by the
crazy blog program that ships in SUSE releases (that's "boot log" and
not "web log", it predates the general "blog" terminology by many
years), and the restoration of the continuation line functionality
reported by Stephen and others.  Yes, the changes seem a bit big this
late in the cycle, but I've been beating on them for a while now, and
Stephen has even optimized it a bit, so all looks good to me.

The other change in here is a Documentation update for the stable kernel
rules describing how some distro patches should be backported, to
hopefully drive a bit more response from the distros to the stable
kernel releases.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (1):
      printk: fix regression in SYSLOG_ACTION_CLEAR

Greg Kroah-Hartman (1):
      Revert "printk: return -EINVAL if the message len is bigger than the buf size"

Jan Beulich (1):
      syslog: fill buffer with more than a single message for SYSLOG_ACTION_READ

Kay Sievers (1):
      printk: flush continuation lines immediately to console

Mel Gorman (1):
      stable: Allow merging of backports for serious user-visible performance issues

Steven Rostedt (1):
      printk: Optimize if statement logic where newline exists

 Documentation/stable_kernel_rules.txt |   6 +
 kernel/printk.c                       | 297 ++++++++++++++++++++++++----------
 2 files changed, 219 insertions(+), 84 deletions(-)
