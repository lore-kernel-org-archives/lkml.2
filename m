Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1GaCR7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 22:17:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57888 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1GaCRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 22:17:53 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: [PATCH 1/2] kconfig: Factor out conf_validate_choice_val() function from conf_read_simple()
Date: Sat, 30 Jul 2011 22:17:42 -0400
Message-Id: <1312078662-20278-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <1312067626.22074.60.camel@i7.infradead.org>
References: <1312067626.22074.60.camel@i7.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Sat, Jul 30, 2011 at 7:13 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> We're going to want to do this from elsewhere, shortly...
>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>
I would go a little further and apply the attached patch too, The two jump
site to `setsym' do not meet the conditionnal and can be avoided.

 - Arnaud

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 0341254..74dcfb1 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -284,7 +284,7 @@ load:
 				sym = sym_find(line + 2 + strlen(CONFIG_));
 				if (!sym) {
 					sym_add_change_count(1);
-					goto setsym;
+					continue;
 				}
 			} else {
 				sym = sym_lookup(line + 2 + strlen(CONFIG_), 0);
@@ -318,7 +318,7 @@ load:
 				sym = sym_find(line + strlen(CONFIG_));
 				if (!sym) {
 					sym_add_change_count(1);
-					goto setsym;
+					continue;
 				}
 			} else {
 				sym = sym_lookup(line + strlen(CONFIG_), 0);
@@ -335,7 +335,7 @@ load:
 				conf_warning("unexpected data");
 			continue;
 		}
-setsym:
 		if (sym && sym_is_choice_value(sym))
 			conf_validate_choice_val(sym, def, def_flags);
 	}
