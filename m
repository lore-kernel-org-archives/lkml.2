Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab1DZHjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:39:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49436 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758444Ab1DZHjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 03:39:15 -0400
Subject: Re: [BUG] perf and kmemcheck : fatal combination
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Vegard Nossum <vegardno@ifi.uio.no>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1303747731.2747.182.camel@edumazet-laptop>
References: <1303747731.2747.182.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Apr 2011 09:38:45 +0200
Message-ID: <1303803525.20212.20.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 18:08 +0200, Eric Dumazet wrote:
> Hi guys
> 
> Just got a panic on a kmemcheck kernel, latest linux-2.6 tree.
> 
> I forgot I had kmemcheck enabled, and started "perf top" just because my
> machine was damn slow... Oh well...
> 
> Crash in do_nmi -> nmi_enter() -> BUG_ON(in_nmi());

Hmm,. I bet because kmemcheck triggers faults from nmi context because
it messes about with the page protection bits a lot to track things.

Can't really think of anything except not making perf available on
kmemcheck kernels.

---
 init/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 32745bf..94735b4 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1125,6 +1125,7 @@ config PERF_EVENTS
 	bool "Kernel performance events and counters"
 	default y if (PROFILING || PERF_COUNTERS)
 	depends on HAVE_PERF_EVENTS
+	depends on !KMEMCHECK
 	select ANON_INODES
 	select IRQ_WORK
 	help

