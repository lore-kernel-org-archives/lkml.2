Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab1FFTAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:00:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34179 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab1FFS6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:58:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VyYbYHpt2dEioxJ7QbD37jNKTYMdHxYQe3PmgCVEYAScb4woX1hbYPvK0PIhBgcFJr
         nLJy3g5N0wBDQj2TRqY23TUEaV6XVdfC2z4iN9d7vu7w8WU0QwESYLCGI3aLq6OFiPEJ
         yEbtxUoOQruj0UdU2B7naBeXUy+fD6iPtYqRk=
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/9] kconfig: fix return code for invalid boolean symbol in conf_set_sym_val()
Date: Mon,  6 Jun 2011 14:58:24 -0400
Message-Id: <1307386711-8866-3-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
References: <1307386711-8866-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/confdata.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 3693ac7..a9f0ebd 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -141,7 +141,7 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 			break;
 		}
 		conf_warning("symbol value '%s' invalid for %s", p, sym->name);
-		break;
+		return 1;
 	case S_OTHER:
 		if (*p != '"') {
 			for (p2 = p; *p2 && !isspace(*p2); p2++)
-- 
1.7.3.4.574.g608b.dirty

