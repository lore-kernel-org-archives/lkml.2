Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab0FCNud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:50:33 -0400
Received: from smtp-out.google.com ([74.125.121.35]:11115 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab0FCNub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:50:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=eWVKXgRtWCr4ysHgUpk0Kx+WagiFDIaf6KKwFmYibUfJjIveLuyNGzxp/KuOqmgXj
	P9K/SpkRzhJ6YioK1Ghyg==
Message-ID: <4c07b323.2126e30a.6245.0e1e@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Thu, 3 Jun 2010 15:50:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, acme@infradead.org, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com, tzanussi@gmail.com
Subject: [PATCH] perf: make annotate demangle symbols
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perf report is demangling symbols but not annotate.
The former uses internal demangling via libbdf or
libiberty. The latter executes objdump which by default
does not demangle symbols.

This patch adds the -C option to the objdump cmdline
to enable symbol demangling.

Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 07f89b6..9e6baad 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1037,7 +1037,7 @@ fallback:
 		 dso, dso->long_name, sym, sym->name);
 
 	snprintf(command, sizeof(command),
-		 "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s|grep -v %s|expand",
+		 "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS -C %s|grep -v %s|expand",
 		 map__rip_2objdump(map, sym->start),
 		 map__rip_2objdump(map, sym->end),
 		 filename, filename);
