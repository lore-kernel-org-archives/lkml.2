Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab0EMLta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 07:49:30 -0400
Received: from toro.web-alm.net ([62.245.132.31]:49382 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499Ab0EMLt2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 07:49:28 -0400
X-Greylist: delayed 1723 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 May 2010 07:49:27 EDT
From: "Carsten Emde" <C.Emde@osadl.org>
Reply-to: "Carsten Emde" <C.Emde@osadl.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       And rew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/4] tracing/sched:
 Fix task states in sched switch event
Date: Thu, 13 May 2010 12:10:17 +0100
Message-ID: <RYmXFZH5FML2.rJxWwvD3@ce.dyn.web-alm.net>
X-Mailer: EPOC Email Version 2.10
MIME-Version: 1.0
Content-Language: i-default
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

> Hm, this is totally unreadable. What does 'TASK_STATE_X' mean??
Would this be better?
+#define MAKE_TASK_STATE_STRING(num) TASK_STATE_##num " (" DESCR_TASK_STATE_##num ")"
 static const char *task_state_array[] = {
-	"R (running)",		/*   0 */
-	"S (sleeping)",		/*   1 */
-	"D (disk sleep)",	/*   2 */
-	"T (stopped)",		/*   4 */
-	"t (tracing stop)",	/*   8 */
-	"Z (zombie)",		/*  16 */
-	"X (dead)",		/*  32 */
-	"x (dead)",		/*  64 */
-	"K (wakekill)",		/* 128 */
-	"W (waking)",		/* 256 */
+	MAKE_TASK_STATE_STRING(0),
+	MAKE_TASK_STATE_STRING(1),
+	MAKE_TASK_STATE_STRING(2),
+	MAKE_TASK_STATE_STRING(4),
+	MAKE_TASK_STATE_STRING(8),
+	MAKE_TASK_STATE_STRING(16),
+	MAKE_TASK_STATE_STRING(32),
+	MAKE_TASK_STATE_STRING(64),
+	MAKE_TASK_STATE_STRING(128),
+	MAKE_TASK_STATE_STRING(256)

	Carsten.

