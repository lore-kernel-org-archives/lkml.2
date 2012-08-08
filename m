Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025Ab2HHRkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:40:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759012Ab2HHRkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:40:20 -0400
Date: Wed, 8 Aug 2012 19:36:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] uprobes: kill uprobes_state->count, add MMF_HAS_UPROBES
Message-ID: <20120808173659.GA13220@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Srikar, please review.

This is the first part. The next series will teach uprobes to
clear MMF_HAS_UPROBES, but perhaps we should simply remove
uprobe_munmap() instead. A wrong MMF_HAS_UPROBES doesn't hurt
unless the task hits the non-uprobe "int3", not sure it really
makes sense to try to speedup this case. We will see.

7/7 is offtopic.

Oleg.

 include/linux/sched.h   |    2 +
 include/linux/uprobes.h |   13 ++--
 kernel/events/uprobes.c |  141 ++++++++++++----------------------------------
 kernel/fork.c           |    6 +--
 4 files changed, 47 insertions(+), 115 deletions(-)

