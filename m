Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab1EJKJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:09:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:54498 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab1EJKJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:09:58 -0400
Date: Tue, 10 May 2011 11:09:54 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] mm: tracing: Add missing GFP flags to tracing
Message-ID: <20110510100954.GC4146@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/gfp.h and include/trace/events/gfpflags.h is out of
sync. When tracing is enabled, certain flags are not recognised and
the text output is less useful as a result.  Add the missing flags.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/trace/events/gfpflags.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/gfpflags.h b/include/trace/events/gfpflags.h
index e3615c0..9fe3a366 100644
--- a/include/trace/events/gfpflags.h
+++ b/include/trace/events/gfpflags.h
@@ -10,6 +10,7 @@
  */
 #define show_gfp_flags(flags)						\
 	(flags) ? __print_flags(flags, "|",				\
+	{(unsigned long)GFP_TRANSHUGE,		"GFP_TRANSHUGE"},	\
 	{(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"}, \
 	{(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER"},	\
 	{(unsigned long)GFP_USER,		"GFP_USER"},		\
@@ -32,6 +33,9 @@
 	{(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL"},	\
 	{(unsigned long)__GFP_THISNODE,		"GFP_THISNODE"},	\
 	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
-	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"}		\
+	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"},		\
+	{(unsigned long)__GFP_NOTRACK,		"GFP_NOTRACK"},		\
+	{(unsigned long)__GFP_NO_KSWAPD,	"GFP_NO_KSWAPD"},	\
+	{(unsigned long)__GFP_OTHER_NODE,	"GFP_OTHER_NODE"}	\
 	) : "GFP_NOWAIT"
 
