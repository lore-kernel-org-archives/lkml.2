Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab2BVUzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 15:55:10 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56735 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab2BVUzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 15:55:07 -0500
Date: Wed, 22 Feb 2012 12:54:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
cc: Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] i387: stable kernel backport
Message-ID: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a reasonably minimal backport of the i387 state save/restore bug.

A few of the commits are just minimal "make it easier to backport" commits 
that don't necessarily fix anything on their own.  And a few of the others 
are combinations of what is two commits in the development tree, because 
it turned out to be easier and cleaner that way.

The last one is the one that fixes the x86-32 bug, but the preemption 
fixes are real fixes too, although they are probably not something that 
anybody has necessarily ever hit in reality because the race window is so 
small.  Even so, if the fix itself isn't that important, the "make it 
easier to backport the main one" would still be a big argument for it.

I *really* hope that the people who could reproduce this bug will test the 
back-port series too, since I never actually saw the bug personally to 
begin with. And again, big thanks to Raphael who helped pinpoint and debug 
this.

                   Linus

---
Linus Torvalds (5):
  i387: math_state_restore() isn't called from asm
  i387: make irq_fpu_usable() tests more robust
  i387: fix x86-64 preemption-unsafe user stack save/restore
  i387: move TS_USEDFPU clearing out of __save_init_fpu and into callers
  i387: move TS_USEDFPU flag from thread_info to task_struct

 arch/x86/include/asm/i387.h        |  158 +++++++++++++++++++++++++++++++-----
 arch/x86/include/asm/processor.h   |    1 +
 arch/x86/include/asm/thread_info.h |    2 -
 arch/x86/kernel/traps.c            |   14 ++--
 arch/x86/kernel/xsave.c            |   12 +--
 arch/x86/kvm/vmx.c                 |    2 +-
 6 files changed, 150 insertions(+), 39 deletions(-)

-- 
1.7.9.188.g12766.dirty

