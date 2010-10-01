Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab0JAVYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 17:24:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab0JAVYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 17:24:17 -0400
Date: Fri, 1 Oct 2010 17:23:37 -0400
From: Jason Baron <jbaron@redhat.com>
To: rostedt@goodmis.org, mingo@elte.hu
Cc: mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, ddaney@caviumnetworks.com,
        linux-kernel@vger.kernel.org
Message-Id: <cover.1285965957.git.jbaron@redhat.com>
Subject: [PATCH 0/5] jump label: core updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are some updates to the jump label code (against -tip tree) found during
testing and review.

After this series, I'm not aware of any outstanding issues.

thanks,

-Jason

Jason Baron (5):
  jump label: fix module __init section race
  jump label: Fix deadlock b/w jump_label_mutex vs. text_mutex
  jump label: add register_jump_label_key/unregister_jump_label_key
  jump label: move jump table to r/w section
  jump label: add docs

 Documentation/jump-label.txt      |  142 +++++++++++++++++++++++
 include/asm-generic/vmlinux.lds.h |   14 +--
 include/linux/jump_label.h        |    9 ++
 kernel/jump_label.c               |  222 +++++++++++++++++++++++++++++++-----
 kernel/kprobes.c                  |    6 +
 kernel/tracepoint.c               |   34 ++++++
 lib/dynamic_debug.c               |   20 ++++
 7 files changed, 406 insertions(+), 41 deletions(-)
 create mode 100644 Documentation/jump-label.txt

