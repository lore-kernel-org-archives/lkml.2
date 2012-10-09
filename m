Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2JICIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 22:08:47 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33843 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab2JICIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 22:08:41 -0400
X-AuditID: b753bd60-97c52ba000002f78-43-507387270c89
X-AuditID: b753bd60-97c52ba000002f78-43-507387270c89
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH 0/2] ftrace: [BUGFIX] type of ring_buffer_oldest_event_ts()
 and showing of stats per cpu directory
To: Steven Rostedt <rostedt@goodmis.org>, David Sharp <dhsharp@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Date: Tue, 09 Oct 2012 11:08:38 +0900
Message-ID: <20121009020838.12110.90016.stgit@localhost.localdomain>
In-Reply-To: <1349148680-9509-1-git-send-email-dhsharp@google.com>
References: <1349148680-9509-1-git-send-email-dhsharp@google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch set fixes two bugs for ftrace.

[1/2] 
This patch fixes type mismatch of ring_buffer_oldest_event_ts().

[2/2]
This fixes showing of stats per cpu directory for ftrace using counter or tsc
as a time stamp. This patch depends on David's patch series
(https://lkml.org/lkml/2012/10/1/652), but this bug already exists in the
counter mode. 

Thank you,

---

Yoshihiro YUNOMAE (2):
      ftrace: Show raw time stamp on stats per cpu using counter or tsc mode for trace_clock
      ftrace: Change unsigned long type of ring_buffer_oldest_event_ts() to u64


 include/linux/ring_buffer.h |    2 +-
 kernel/trace/ring_buffer.c  |    4 ++--
 kernel/trace/trace.c        |   23 +++++++++++++++++------
 3 files changed, 20 insertions(+), 9 deletions(-)

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
