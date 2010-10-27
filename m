Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab0J0VHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 17:07:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230Ab0J0VHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 17:07:47 -0400
Date: Wed, 27 Oct 2010 17:07:08 -0400
From: Jason Baron <jbaron@redhat.com>
To: rostedt@goodmis.org, mingo@elte.hu
Cc: mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, ddaney@caviumnetworks.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
Message-Id: <cover.1288212485.git.jbaron@redhat.com>
Subject: [PATCH 0/2] jump label updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So we finally tracked down the jump label crashes and it turned out that there
was a a bug in the compiler in the implementation of 'asm goto'. As the fix has
not yet been committed yet to gcc, and I don't have a simple test case to
check if the bug has been fixed, we are going to disable jump labels pending
a better test to detect that gcc has been fixed.

The second patch fixes a hang on Geode LX, b/c the no-op probing was done too
early - before the exception tables had even been setup.

thanks,

-Jason

Jason Baron (2):
  move arch_init_ideal_nop5 later
  jump label: disable due to compiler bug

 arch/x86/include/asm/alternative.h |    1 -
 arch/x86/kernel/alternative.c      |  132 ++++++++++++++++++------------------
 arch/x86/kernel/setup.c            |    6 --
 include/linux/jump_label.h         |    9 +++
 4 files changed, 76 insertions(+), 72 deletions(-)

