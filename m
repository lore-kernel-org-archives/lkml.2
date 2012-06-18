Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2FROvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:51:23 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:32999
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999Ab2FROvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:51:19 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1202hzz8275bh8275dhz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5TILB-01-5J5-02
X-M-MSG: 
Date: Mon, 18 Jun 2012 16:51:08 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jim Cromie <jim.cromie@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, <stable@vger.kernel.org>
Subject: [PATCH] perf stat: Fix default logfd to use stderr
Message-ID: <20120618145108.GG5046@erda.amd.com>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
 <1317336490-19437-8-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1317336490-19437-8-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.09.11 18:48:01, Arnaldo Carvalho de Melo wrote:
> From: Jim Cromie <jim.cromie@gmail.com>
> 
> This perf stat option emulates valgrind's --log-fd option, allowing the
> user to send perf results elsewhere, and leaving stderr for use by the
> program under test.  This complements --output file option, and is
> mutually exclusive with it.
> 
>    3>results  perf stat --log-fd 3          -- $cmd
>    3>>results perf stat --log-fd 3 --append -- $cmd
> 
> The perl distro's make test.valgrind target uses valgrind's --log-fd
> option, I've adapted it to invoke perf also, and tested this patch
> there.
> 
> Link: http://lkml.kernel.org/r/1315437244-3788-2-git-send-email-jim.cromie@gmail.com
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

With certain shell redirections this (56f3bae) fails with a log fd
setup failure. Fix below.

-Robert



>From fd83259163c8022f9264a119d5ef7df594702f3a Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Thu, 7 Jun 2012 17:41:52 +0200
Subject: [PATCH] perf stat: Fix default logfd to use stderr

When running perf-stat in certain shell environments with stdout
redirection there is a logging file descriptor setup failure:

 Failed opening logfd: Invalid argument

Fixing this by setting the default fd to the correct value of 2.

Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: <stable@vger.kernel.org> # 3.2+
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/builtin-stat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2625899..c47e7d3 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -195,7 +195,7 @@ static bool			csv_output			= false;
 static bool			group				= false;
 static const char		*output_name			= NULL;
 static FILE			*output				= NULL;
-static int			output_fd;
+static int			output_fd			=  2;
 
 static volatile int done = 0;
 
-- 
1.7.8.4



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

