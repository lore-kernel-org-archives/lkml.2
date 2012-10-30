Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809Ab2J3QFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:05:48 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47001 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928Ab2J3QFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:05:45 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/4] Documentation: Fix memory-barriers.txt example
Date: Tue, 30 Oct 2012 09:04:33 -0700
Message-Id: <1351613076-22022-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20121030160350.GA21837@linux.vnet.ibm.com>
References: <20121030160350.GA21837@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-5406-0000-0000-0000018DF7EA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit fixes a broken example of overlapping stores in the
Documentation/memory-barriers.txt file.

Reported-by: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/memory-barriers.txt |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 2759f7c..3c4e1b3 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -251,12 +251,13 @@ And there are a number of things that _must_ or _must_not_ be assumed:
 
      And for:
 
-	*A = X; Y = *A;
+	*A = X; *(A + 4) = Y;
 
-     we may get either of:
+     we may get any of:
 
-	STORE *A = X; Y = LOAD *A;
-	STORE *A = Y = X;
+	STORE *A = X; STORE *(A + 4) = Y;
+	STORE *(A + 4) = Y; STORE *A = X;
+	STORE {*A, *(A + 4) } = {X, Y};
 
 
 =========================
-- 
1.7.8

