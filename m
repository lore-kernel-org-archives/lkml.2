Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1IFQLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:11:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:63937 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab1IFQL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:11:27 -0400
Date: Tue, 6 Sep 2011 12:10:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: david.vrabel@citrix.com, imammedo@redhat.com, Ian.Campbell@eu.citrix.com
Subject: [GIT PULL] (xen) stable/bug.fixes for 3.1-rc5.
Message-ID: <20110906161046.GA5548@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4E664623.0023,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following branch from my backup git server:

git pull git://oss.oracle.com/git/kwilk/xen.git stable/bug.fixes

It is based off git commit 60c5f08e154fd235056645e050f2cd5671b19125
Jeremy Fitzhardinge (1):
    xen/tracing: Fix tracing config option properly

Which you pulled in earlier (3.1-rc3?).

We got some ecstatic bug-fixes - one in particular has been in the tree since 2.6.27!
They are (in order of "oh-my-what-a-bug"):
 1). Don't enable the interrupts when a page fault has occurred - this ended up triggering
     when we were executing a IRQ handler and re-enabling the IRQ line!
 2). Respect the dom0_mem=max:X argument that the hypervisor can use to limit the amount
     of memory the initial Linux kernel would use. Without it, on largish (32GB>) the
     initial domain had tons of unused 'struct page' that were never going to be used.
 3). Lastly, print out a warning when the user uses specific Linux kernel parameters
     that we cannot handle ("nosmp" or "noapic").

The credit list is:

David Vrabel (1):
      xen: use maximum reservation to limit amount of usable RAM

Igor Mammedov (1):
      xen: x86_32: do not enable iterrupts when returning from exception in interrupt context

Konrad Rzeszutek Wilk (1):
      xen/smp: Warn user why they keel over - nosmp or noapic and what to use instead.

Diff stat:

 arch/x86/xen/setup.c      |   19 +++++++++++++++++++
 arch/x86/xen/smp.c        |   10 ++++++++++
 arch/x86/xen/xen-asm_32.S |    8 +++++---
 3 files changed, 34 insertions(+), 3 deletions(-)

