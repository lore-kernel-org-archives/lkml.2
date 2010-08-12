Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930Ab0HLPzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:55:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760365Ab0HLPzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:55:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/6] MN10300: Permit .GCC-command-line sections
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 12 Aug 2010 16:54:47 +0100
Message-ID: <20100812155446.17015.85600.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100812155436.17015.78424.stgit@warthog.procyon.org.uk>
References: <20100812155436.17015.78424.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Permit .GCC-command-line sections in modules.  Otherwise modpost says things
like:

WARNING: drivers/mtd/chips/map_ram.o (.GCC-command-line): unexpected non-allocatable section.
Did you forget to use "ax"/"aw" in a .S file?
Note that for example <linux/init.h> contains
section definitions for use in .S files.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 scripts/mod/modpost.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 7acbdd8..253c107 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -790,6 +790,7 @@ static const char *section_white_list[] =
 {
 	".comment*",
 	".debug*",
+	".GCC-command-line",	/* mn10300 */
 	".mdebug*",        /* alpha, score, mips etc. */
 	".pdr",            /* alpha, score, mips etc. */
 	".stab*",

