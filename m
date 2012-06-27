Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab2F0JDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:03:32 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44077 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab2F0JDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:03:30 -0400
X-AuditID: 9c930197-b7b49ae0000027b8-99-4feacc5f7d0c
From: Namhyung Kim <namhyung@kernel.org>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, mingo@redhat.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: fix wrong hw_breakpoint documentation
References: <CACV3sbKFcHgai6AzKGrf=LEb67VjZXjMUqMQuXAOUmby7CeiJg@mail.gmail.com>
Date: Wed, 27 Jun 2012 17:59:34 +0900
In-Reply-To: <CACV3sbKFcHgai6AzKGrf=LEb67VjZXjMUqMQuXAOUmby7CeiJg@mail.gmail.com>
	(Jovi Zhang's message of "Wed, 27 Jun 2012 16:39:19 +0800")
Message-ID: <87fw9hyvt5.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jovi

On Wed, 27 Jun 2012 16:39:19 +0800, Jovi Zhang wrote:
> From f5f9c3a064482cf3d0fb7ed788c66630bddbfc79 Mon Sep 17 00:00:00 2001
> From: Jovi Zhang <bookjovi@gmail.com>
> Date: Wed, 27 Jun 2012 16:09:21 +0800
> Subject: [PATCH] perf: fix wrong hw_breakpoint documentation
>
> read-write access hw_breakpoint event is passed as 'mem:addr',
> 'mem:0x1000:rw' is parsed as invalid argument currently.
>

It should be a bug in event parser. I guess the patch below will fix it:


diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 488362e14133..aafca33a8a09 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -76,7 +76,7 @@ num_hex               0x[a-fA-F0-9]+
 num_raw_hex    [a-fA-F0-9]+
 name           [a-zA-Z_*?][a-zA-Z0-9_*?]*
 modifier_event [ukhpGH]{1,8}
-modifier_bp    [rwx]
+modifier_bp    [rwx]+
 
 %%
 
