Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab0ERNr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 09:47:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32783 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575Ab0ERNqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 09:46:50 -0400
Message-Id: <20100518133258.000434886@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 18 May 2010 15:32:58 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/5] Optimize perf ring-buffer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set optimizes the perf ring-buffer by removing IRQ disable and 
all LOCK ops from the fast paths.

There's also an RFC patch that adds perf_output_addr() which will allow
you to write directly to the buffer, however I'm not sure how to go
about using it for the trace events since we need to multiplex event --
there is no single copy of the actual event.

