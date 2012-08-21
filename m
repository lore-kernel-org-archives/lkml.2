Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab2HUQOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:14:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60810 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab2HUQN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:13:57 -0400
Date: Tue, 21 Aug 2012 09:11:40 -0700
From: tip-bot for Andi Kleen <ak@linux.intel.com>
Message-ID: <tip-0fe7d7e9761ec7e23350b5543ddac470bb3cde1e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, penberg@cs.helsinki.fi, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, penberg@cs.helsinki.fi, ak@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <1344526260-18721-1-git-send-email-andi@firstfloor.org>
References: <1344526260-18721-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Add description of JIT interface
Git-Commit-ID: 0fe7d7e9761ec7e23350b5543ddac470bb3cde1e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:11:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0fe7d7e9761ec7e23350b5543ddac470bb3cde1e
Gitweb:     http://git.kernel.org/tip/0fe7d7e9761ec7e23350b5543ddac470bb3cde1e
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 9 Aug 2012 08:31:00 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Aug 2012 14:55:02 -0300

perf symbols: Add description of JIT interface

Add a description of the JIT interface in the perf symbol resolution
code. I reverse engineered the format from the source.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Link: http://lkml.kernel.org/r/1344526260-18721-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/jit-interface.txt |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/jit-interface.txt b/tools/perf/Documentation/jit-interface.txt
new file mode 100644
index 0000000..a8656f5
--- /dev/null
+++ b/tools/perf/Documentation/jit-interface.txt
@@ -0,0 +1,15 @@
+perf supports a simple JIT interface to resolve symbols for dynamic code generated
+by a JIT.
+
+The JIT has to write a /tmp/perf-%d.map  (%d = pid of process) file
+
+This is a text file.
+
+Each line has the following format, fields separated with spaces:
+
+START SIZE symbolname
+
+START and SIZE are hex numbers without 0x.
+symbolname is the rest of the line, so it could contain special characters.
+
+The ownership of the file has to match the process.
