Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab0KWV2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 16:28:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab0KWV2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 16:28:21 -0500
Date: Tue, 23 Nov 2010 16:27:20 -0500
From: Jason Baron <jbaron@redhat.com>
To: rostedt@goodmis.org, mingo@elte.hu
Cc: peterz@infradead.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Message-Id: <cover.1290546539.git.jbaron@redhat.com>
Subject: [PATCH 0/3] jump label: updates for 2.6.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A few jump label patches that I want considered for 2.6.37. Patches are against
the latest -tip tree.

The first one, which adds 'state' to the jump label mechanism is the most
important. Essentially, it ensures that if jump labels are enabled/disabled in
the core kernel but the actual call sites are in modules, we properly honor the
state of the jump label. This also works for jump labels which may be defined in
one module but made use of in another module.

There has been some discussion about using the 'key' variable to store the
enabled/disabled state for each jump label. However, I think a better design
will be to use the 'key' variable to store a pointer to the appropriate jump
label tables. In this way, we can enable/disable jump labels, without the
hashing that I'm currently doing. However, I didn't want to propose these more
invasive changes until 2.6.38. 

thanks,

-Jason

Jason Baron (3):
  jump label: add enabled/disabled state to jump label key entries
  jump label: move jump table to r/w section
  jump label: add docs

 Documentation/jump-label.txt      |  126 +++++++++++++++++++++++++++++++++++++
 include/asm-generic/vmlinux.lds.h |   14 +---
 kernel/jump_label.c               |  101 +++++++++++++++++++++++-------
 3 files changed, 209 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/jump-label.txt

