Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab1BGOch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 09:32:37 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54483 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab1BGOcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 09:32:35 -0500
Date: Mon, 7 Feb 2011 15:32:18 +0100
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        eranian@google.com, paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
        tzanussi@gmail.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Subject: [PATCH] perf annotate: Fix build error
Message-ID: <20110207143218.GA31197@kryptos.osrc.amd.com>
References: <new-submission>
 <tip-78f7defedbb4da73b9a07635c357c1afcaa55c8f@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-78f7defedbb4da73b9a07635c357c1afcaa55c8f@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 07:54:58AM +0000, tip-bot for Arnaldo Carvalho de Melo wrote:
> Commit-ID:  78f7defedbb4da73b9a07635c357c1afcaa55c8f
> Gitweb:     http://git.kernel.org/tip/78f7defedbb4da73b9a07635c357c1afcaa55c8f
> Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
> AuthorDate: Fri, 4 Feb 2011 09:45:46 -0200
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Sat, 5 Feb 2011 12:28:21 -0200
> 
> perf annotate: Move annotate functions to util/

A small fix for when NO_NEWT_SUPPORT is defined.

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Mon, 7 Feb 2011 15:26:52 +0100
Subject: [PATCH] perf annotate: Fix build error

Add a missing "struct" to the function prototype.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/perf/util/annotate.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index b1253aa..bc08b36 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -82,7 +82,7 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 			 int max_lines);
 
 #ifdef NO_NEWT_SUPPORT
-static inline int symbol__tui_annotate(symbol *sym __used,
+static inline int symbol__tui_annotate(struct symbol *sym __used,
 				       struct map *map __used, int evidx __used)
 {
 	return 0;
-- 
1.7.4.rc1.7.g2cf08

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
