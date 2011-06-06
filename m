Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab1FFTAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:00:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34179 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab1FFS6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:58:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xTtf2y4IBKSyyxNz+aF810iQn0iSbsLvo4neZuz4fMdAj6eeSls2hmnB4Ov0KFgF8h
         mTRUfyllZglDv4qlIi/R6kmeBX81s38t/+wn9Qux1/yw6AN76+Lpmf5V11battdpNKmK
         KLx/QJqwbz3HlznDFDMWD5ykI2sy1mayDpork=
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 1/9] kconfig: annotate non-trivial fall-trough
Date: Mon,  6 Jun 2011 14:58:23 -0400
Message-Id: <1307386711-8866-2-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
References: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/conf.c     |    4 ++++
 scripts/kconfig/confdata.c |    5 +++++
 scripts/kconfig/gconf.c    |    1 +
 scripts/kconfig/mconf.c    |    1 +
 4 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 006ad81..8be7374 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -106,6 +106,7 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 			return 0;
 		}
 		check_stdin();
+		/* FALLTHOUGH */
 	case oldaskconfig:
 		fflush(stdout);
 		xfgets(line, 128, stdin);
@@ -150,6 +151,7 @@ static int conf_string(struct menu *menu)
 				def = NULL;
 				break;
 			}
+			/* FALLTHOUGH */
 		default:
 			line[strlen(line)-1] = 0;
 			def = line;
@@ -304,6 +306,7 @@ static int conf_choice(struct menu *menu)
 				break;
 			}
 			check_stdin();
+			/* FALLTHOUGH */
 		case oldaskconfig:
 			fflush(stdout);
 			xfgets(line, 128, stdin);
@@ -369,6 +372,7 @@ static void conf(struct menu *menu)
 				check_conf(menu);
 				return;
 			}
+			/* FALLTHOUGH */
 		case P_COMMENT:
 			prompt = menu_get_prompt(menu);
 			if (prompt)
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 2bafd9a..3693ac7 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -128,6 +128,7 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 			sym->flags |= def_flags;
 			break;
 		}
+		/* FALLTHOUGH */
 	case S_BOOLEAN:
 		if (p[0] == 'y') {
 			sym->def[def].tri = yes;
@@ -148,6 +149,7 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 			sym->type = S_STRING;
 			goto done;
 		}
+		/* FALLTHOUGH */
 	case S_STRING:
 		if (*p++ != '"')
 			break;
@@ -162,6 +164,7 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 			conf_warning("invalid string found");
 			return 1;
 		}
+		/* FALLTHOUGH */
 	case S_INT:
 	case S_HEX:
 	done:
@@ -237,6 +240,7 @@ load:
 		case S_STRING:
 			if (sym->def[def].val)
 				free(sym->def[def].val);
+			/* FALLTHOUGH */
 		default:
 			sym->def[def].val = NULL;
 			sym->def[def].tri = no;
@@ -363,6 +367,7 @@ int conf_read(const char *name)
 					break;
 				if (!sym_is_choice(sym))
 					goto sym_ok;
+				/* FALLTHOUGH */
 			default:
 				if (!strcmp(sym->curr.val, sym->def[S_DEF_USER].val))
 					goto sym_ok;
diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index a11d5f7..79e9806 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -1172,6 +1172,7 @@ static gchar **fill_row(struct menu *menu)
 			row[COL_BTNVIS] = GINT_TO_POINTER(TRUE);
 		if (sym_is_choice(sym))
 			break;
+		/* FALLTHOUGH */
 	case S_TRISTATE:
 		val = sym_get_tristate_value(sym);
 		switch (val) {
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index d433c7a..fa0ae0e 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -845,6 +845,7 @@ int main(int ac, char **av)
 				"\n\n"));
 			return 1;
 		}
+		/* FALLTHOUGH */
 	case -1:
 		printf(_("\n\n"
 			"*** End of the configuration.\n"
-- 
1.7.3.4.574.g608b.dirty

