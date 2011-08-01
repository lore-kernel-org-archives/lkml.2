Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab1HANxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 09:53:55 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:53063 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1HANxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 09:53:49 -0400
Date: Mon, 01 Aug 2011 09:51:24 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Michal Marek <mmarek@suse.cz>
Cc: Peter Foley <pefoley2@verizon.net>, Arnaud Lacombe <lacombar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        rdunlap@xenotime.net
Subject: [PATCH v2] kconfig.h fix extraneous dependencies
In-reply-to: <4E3670BF.6000709@suse.cz>
Message-id: <alpine.LNX.2.00.1108010945280.3043@linux>
References: <alpine.LNX.2.00.1107311812460.62769@linux>
 <CACqU3MWfOg+ZhUGAovWsds48Y37i7GRk7qSxWvt7-JmLMBcmgg@mail.gmail.com>
 <alpine.LNX.2.00.1107312055360.20006@linux> <4E3670BF.6000709@suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The introduction of include/linux/kconfig.h created 3 extraneous 
dependencies:
include/config/.h 
include/config/h.h 
include/config/foo.h 

Fix this by excluding kconfig.h from fixdep calculations.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
diff --git a/scripts/basic/fixdep.c b/scripts/basic/fixdep.c
index 291228e..4789a6b 100644
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -345,6 +345,7 @@ static void parse_dep_file(void *map, size_t len)
 		memcpy(s, m, p-m); s[p-m] = 0;
 		if (strrcmp(s, "include/generated/autoconf.h") &&
 		    strrcmp(s, "arch/um/include/uml-config.h") &&
+                    strrcmp(s, "include/linux/kconfig.h") &&
 		    strrcmp(s, ".ver")) {
 			/*
 			 * Do not list the source file as dependency, so that
