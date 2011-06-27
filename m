Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab1F0XhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:37:00 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:63900 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab1F0Xfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:35:34 -0400
Date: Mon, 27 Jun 2011 19:33:54 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Peter Foley <pefoley2@verizon.net>
Cc: Arnaud Lacombe <lacombar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz
Subject: [PATCH V2] kbuild: silence generated makefile message
In-reply-to: <alpine.LNX.2.00.1106271915160.38876@linux>
Message-id: <alpine.LNX.2.00.1106271932480.13060@linux>
References: <alpine.LNX.2.00.1106271619350.24034@linux>
 <BANLkTimrUYk-8GSsf35mUmLVBAaO84R6dA@mail.gmail.com>
 <alpine.LNX.2.00.1106271915160.38876@linux>
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

 scripts/mkmakefile |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/scripts/mkmakefile b/scripts/mkmakefile
index 5325423..ea26f37 100644
--- a/scripts/mkmakefile
+++ b/scripts/mkmakefile
@@ -30,6 +30,10 @@ PATCHLEVEL = $4
 lastword = \$(word \$(words \$(1)),\$(1))
 makedir := \$(dir \$(call lastword,\$(MAKEFILE_LIST)))
 
+ifneq (\$(V),1)
+Q := @
+endif
+
 MAKEARGS := -C $1
 MAKEARGS += O=\$(if \$(patsubst /%,,\$(makedir)),\$(CURDIR)/)\$(patsubst %/,%,\$(makedir))
 
@@ -40,7 +44,7 @@ MAKEFLAGS += --no-print-directory
 all	:= \$(filter-out all Makefile,\$(MAKECMDGOALS))
 
 all:
-	\$(MAKE) \$(MAKEARGS) \$(all)
+	\$(Q)\$(MAKE) \$(MAKEARGS) \$(all)
 
 Makefile:;
 
-- 
1.7.5.3


