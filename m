Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab1FFQje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:39:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39242 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab1FFQjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:39:32 -0400
Date: Mon, 6 Jun 2011 12:38:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: jeremy.fitzhardinge@citrix.com, stefano.stabellini@eu.citrix.com,
        error27@gmail.com, Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: [GIT PULL] (xen) bug-fixes for 3.0-rc2: stable/bug.fixes (and
 potentially stable/vga.support)
Message-ID: <20110606163841.GA19556@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DED02A2.0018:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the two (or one) following branches:

 git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug.fixes stable/vga.support

The #stable/bug.fixes is based on (v3.0-rc1) tag and has two bug-fixes:
 1). Dan found an past the array comparison. That bug has been in the code
     since 2.6.27 - so lurking for quite a while.
 2). Based on testing we found a bug in the IRQ code where we would "forget" to
     ACK edge interrupts (such as PS/2 keyboard) and the user would be left without
     the usage of a keyboard. This only happened during guest creation on specific
     hardware - but the bug is generic that it could happened on any hardware.

The #stable/vga.support is based off 2.6.39 and here I am going to defer to your
judgment whether you would be OK pulling it in or if I should defer to v3.1 with it.

The patch adds VGA text support for the Linux kernel to boot under the Xen hypervisor.
In the past we have been using the frame-buffer (so KMS) or serial console so it never
occurred to me to actually look at the VGA text output (and hence the reason why I did
not include it in the initial git pull for 3.0-rc1) - but it is still important for
users with servers where they don't want to use KMS or Xorg - and without this
patch they won't be able to see anything. Furthermore folks have been popping up on the
mailing list testing 3.0-rc1 and this is the first thing they notice not working right :-(

The patch is contained within the Xen code base so the potential regression impact on
other platforms is nill.

#stable/bug.fixes:
 arch/x86/xen/multicalls.c |   12 ++++++------
 drivers/xen/events.c      |   18 +++++++++---------
 2 files changed, 15 insertions(+), 15 deletions(-)

Dan Carpenter (1):
      xen: off by one errors in multicalls.c

Stefano Stabellini (1):
      xen: use the trigger info we already have to choose the irq handler


#stable/vga.support:

 arch/x86/xen/Makefile       |    2 +-
 arch/x86/xen/enlighten.c    |    8 +++++
 arch/x86/xen/vga.c          |   67 +++++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/xen-ops.h      |   11 +++++++
 include/xen/interface/xen.h |   39 +++++++++++++++++++++++++
 5 files changed, 126 insertions(+), 1 deletions(-)

Jeremy Fitzhardinge (1):
      xen: allow enable use of VGA console on dom0

