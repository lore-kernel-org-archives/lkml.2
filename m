Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab2KFUcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 15:32:16 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36781 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab2KFUcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 15:32:13 -0500
Date: Tue, 6 Nov 2012 15:33:25 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Vince Weaver <vincent.weaver@maine.edu>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: [PATCH] perf_event: missing field in PERF_RECORD_SAMPLE
 documentation
Message-ID: <alpine.DEB.2.02.1211061529590.23901@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While trying to write a perf_event/mmap test for my perf_event 
test-suite I came across a missing field description in the 
PERF_RECORD_SAMPLE documentation.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 4f63c05..9fa9c62 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -579,7 +579,8 @@ enum perf_event_type {
 	 *	{ u32			size;
 	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
 	 *
-	 *	{ u64 from, to, flags } lbr[nr];} && PERF_SAMPLE_BRANCH_STACK
+	 *	{ u64                   nr;
+	 *        { u64 from, to, flags } lbr[nr];} && PERF_SAMPLE_BRANCH_STACK
 	 *
 	 * 	{ u64			abi; # enum perf_sample_regs_abi
 	 * 	  u64			regs[weight(mask)]; } && PERF_SAMPLE_REGS_USER


