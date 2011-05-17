Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1EQJlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:41:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab1EQJlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:41:15 -0400
Date: Tue, 17 May 2011 10:41:11 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@kernel.org
Subject: [PATCH] mm: tracing: Add missing GFP flags to tracing
Message-ID: <20110517094111.GJ5279@suse.de>
References: <20110510100954.GC4146@suse.de>
 <20110510145446.1f8e77e3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110510145446.1f8e77e3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(For 2.6.38-stable)

include/linux/gfp.h and include/trace/events/gfpflags.h is out of
sync. When tracing is enabled, certain flags are not recognised and
the text output is less useful as a result.  Add the missing flags.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/trace/events/gfpflags.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/gfpflags.h b/include/trace/events/gfpflags.h
index e3615c0..5cb8c1b 100644
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
@@ -32,6 +33,8 @@
 	{(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL"},	\
 	{(unsigned long)__GFP_THISNODE,		"GFP_THISNODE"},	\
 	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
-	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"}		\
+	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"},		\
+	{(unsigned long)__GFP_NOTRACK,		"GFP_NOTRACK"},		\
+	{(unsigned long)__GFP_NO_KSWAPD,	"GFP_NO_KSWAPD"}	\
 	) : "GFP_NOWAIT"
 
