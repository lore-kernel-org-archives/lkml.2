Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab1GDW5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 18:57:22 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:36275 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab1GDW5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 18:57:20 -0400
Date: Mon, 04 Jul 2011 18:55:23 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Michal Marek <mmarek@suse.cz>
Cc: Peter Foley <pefoley2@verizon.net>, Arnaud Lacombe <lacombar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH V3] kbuild: silence generated makefile message
In-reply-to: <20110701134733.GB25895@sepie.suse.cz>
Message-id: <alpine.LNX.2.00.1107041852390.20463@linux>
References: <alpine.LNX.2.00.1106271619350.24034@linux>
 <BANLkTimrUYk-8GSsf35mUmLVBAaO84R6dA@mail.gmail.com>
 <alpine.LNX.2.00.1106271915160.38876@linux>
 <alpine.LNX.2.00.1106271932480.13060@linux>
 <20110701134733.GB25895@sepie.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch silences the "make -C /usr/src/git O=/usr/src/git/build/." 
message shown when using the generated makefile in KBUILD_OUTDIR.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
V2: Show message when V=1
V3: Check if V=1 comes from the commandline

 scripts/mkmakefile |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/scripts/mkmakefile b/scripts/mkmakefile
index 5325423..0cc0442 100644
--- a/scripts/mkmakefile
+++ b/scripts/mkmakefile
@@ -30,6 +30,13 @@ PATCHLEVEL = $4
 lastword = \$(word \$(words \$(1)),\$(1))
 makedir := \$(dir \$(call lastword,\$(MAKEFILE_LIST)))
 
+ifeq ("\$(origin V)", "command line")
+VERBOSE := \$(V)
+endif
+ifneq (\$(VERBOSE),1)
+Q := @
+endif
+
 MAKEARGS := -C $1
 MAKEARGS += O=\$(if \$(patsubst /%,,\$(makedir)),\$(CURDIR)/)\$(patsubst %/,%,\$(makedir))
 
@@ -40,7 +47,7 @@ MAKEFLAGS += --no-print-directory
 all	:= \$(filter-out all Makefile,\$(MAKECMDGOALS))
 
 all:
-	\$(MAKE) \$(MAKEARGS) \$(all)
+	\$(Q)\$(MAKE) \$(MAKEARGS) \$(all)
 
 Makefile:;
 
-- 
1.7.6


