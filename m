Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966291Ab2DLXri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 19:47:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:60694 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966245Ab2DLXrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 19:47:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, davem@davemloft.net,
        tony@bakeyournoodle.com, mmarek@suse.cz, lacombar@gmail.com,
        sfr@canb.auug.org.au, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 3/3] kconfig: delete last traces of __enabled_ from autoconf.h
Date: Thu, 12 Apr 2012 19:46:34 -0400
Message-Id: <1334274394-13466-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334274394-13466-1-git-send-email-paul.gortmaker@windriver.com>
References: <CA+55aFx15+eHNA4LobwiFhe4k94XPTVTLdiBmuR4hDKR5HpWPg@mail.gmail.com>
 <1334274394-13466-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've now fixed IS_ENABLED() and friends to not require any
special "__enabled_" prefixed versions of the normal Kconfig
options, so delete the last traces of them being generated.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 scripts/kconfig/confdata.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 9d06744..52577f0 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -489,17 +489,6 @@ header_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
 			fprintf(fp, "#define %s%s%s 1\n",
 			    CONFIG_, sym->name, suffix);
 		}
-		/*
-		 * Generate the __enabled_CONFIG_* and
-		 * __enabled_CONFIG_*_MODULE macros for use by the
-		 * IS_{ENABLED,BUILTIN,MODULE} macros. The _MODULE variant is
-		 * generated even for booleans so that the IS_ENABLED() macro
-		 * works.
-		 */
-		fprintf(fp, "#define __enabled_" CONFIG_ "%s %d\n",
-				sym->name, (*value == 'y'));
-		fprintf(fp, "#define __enabled_" CONFIG_ "%s_MODULE %d\n",
-				sym->name, (*value == 'm'));
 		break;
 	}
 	case S_HEX: {
-- 
1.7.9.1

