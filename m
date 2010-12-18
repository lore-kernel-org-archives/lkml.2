Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab0LRPwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:52:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:36426 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263Ab0LRPwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:52:20 -0500
Date: Sat, 18 Dec 2010 15:52:19 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] Linux 2.4.37.11
Message-ID: <20101218155219.GA32284@hera.kernel.org>
Reply-To: w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 18 Dec 2010 15:52:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've just released Linux 2.4.37.11.

It fixes a number of minor security issues, mainly information leaks
from the kernel stack on some 64-bit architectures, or possible NULL
derefs and crashes in some less commonly used protocols (eg: econet,
x25, irda).

A build issue introduced in 2.4.37.10 when atm/clip was configured to
build as a module was fixed.

An ext3 quota bug causing occasional random panics was fixed, thanks
to a report from Sascha Umlang who also made lots of efforts to get
a debuggable capture of the issue and test the backport for two months.

Last, various MIPS-related fixes provided by Ralf Baechle were merged.

The new 2.4 EOL is now pushed to end of 2011.

Willy

--
The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/patch-2.4.37.11.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.37.11

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.37.y.git

Summary of changes from v2.4.37.10 to v2.4.37.11
============================================

Dan Rosenberg (3):
      drivers/net/eql.c: prevent reading uninitialized stack memory
      sys_semctl: fix kernel stack leakage
      x25: Prevent crashing when parsing bad X.25 facilities

David S. Miller (1):
      rose: Fix signedness issues wrt. digi count.

Ladislav Michl (1):
      NET: SGIseeq: Add support for Challenge S Mezz board

Nelson Elhage (1):
      do_exit(): make sure that we run with get_fs() == USER_DS

Pete Popov (1):
      MTD: Add AMD Alchemy Mirage mapping driver.

Phil Blundell (3):
      econet: fix CVE-2010-3848
      econet: disallow NULL remote addr for sendmsg(), fixes CVE-2010-3849
      econet: fix CVE-2010-3850

Ralf Baechle (2):
      NET: hdlcdrv: Make driver stop method stop queue.
      CHAR: New key map for IBM WorkPad z50.

Samuel Ortiz (1):
      irda: Fix parameter extraction stack overflow

Vasiliy Kulikov (2):
      drivers/char/ppdev.c: fix information leak to userland
      ipc: shm: fix information leak to userland

Willy Tarreau (6):
      net: atm/clip does not work anymore as a module
      ext3: ext3_symlink should use GFP_NOFS allocations inside
      net: packet: fix information leak to userland
      usb: core: fix information leak to userland
      block: ioctl: fix information leak to userland
      Change VERSION to 2.4.37.11

