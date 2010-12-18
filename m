Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab0LRPMb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:12:31 -0500
Received: from usmamail.tilera.com ([206.83.70.70]:43389 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab0LRPMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:12:30 -0500
Message-ID: <4D0CCF5B.1030609@tilera.com>
Date: Sat, 18 Dec 2010 10:12:27 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] changes for tile architecture for 2.6.37
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull for 2.6.37 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

One change fixes a sigreturn bug in our compat layer.  The other moves
CLONE_SETTLS to the kernel, which I realized is where it should be
while I was doing our glibc port.  If the change can be in 2.6.37 that will
allow our glibc to be compatible with 2.6.37.  Thanks!

Chris Metcalf (2):
      arch/tile: handle CLONE_SETTLS in copy_thread(), not user space
      arch/tile: handle rt_sigreturn() more cleanly

 arch/tile/include/asm/signal.h   |    2 +-
 arch/tile/kernel/compat_signal.c |    6 +++---
 arch/tile/kernel/intvec_32.S     |   24 +++++++++++++++++++++---
 arch/tile/kernel/process.c       |    8 ++++++++
 arch/tile/kernel/signal.c        |   10 ++++------
 5 files changed, 37 insertions(+), 13 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

