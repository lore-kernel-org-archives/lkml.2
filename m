Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab0GJIjc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 04:39:32 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:48443 "EHLO
	mail.pripojeni.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751309Ab0GJIja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 04:39:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: christ.li@gmail.com
Cc: jirislaby@gmail.com, Larry Finger <Larry.Finger@lwfinger.net>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
       Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/2] parser: fix and simplify support of asm goto
Date: Sat, 10 Jul 2010 10:39:21 +0200
Message-Id: <1278751162-10053-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <AANLkTikFmeXz9og4t98jm6QcAdRa6rIeCAv3oeFnTgd8@mail.gmail.com>
References: <AANLkTikFmeXz9og4t98jm6QcAdRa6rIeCAv3oeFnTgd8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christopher Li wrote:
> Yes, you caught me slacking off. It is time to cut a new release
> and flush all the bits into the official tree.

But include the patch below first, please. And maybe the second
one...

---

1) We now handle only "asm (volatile|goto)?", whereas
   "asm volatile? goto?" is correct.
2) We need to match only goto_ident, so do it explicitly against
   token->ident without match_idents.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 parse.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/parse.c b/parse.c
index caf10b9..dd7b1a4 100644
--- a/parse.c
+++ b/parse.c
@@ -1915,7 +1915,8 @@ static struct token *parse_asm_statement(struct token *token, struct statement *
 	stmt->type = STMT_ASM;
 	if (match_idents(token, &__volatile___ident, &__volatile_ident, &volatile_ident, NULL)) {
 		token = token->next;
-	} else if (match_idents(token, &goto_ident, NULL)) {
+	}
+	if (token->ident == &goto_ident) {
 		is_goto = 1;
 		token = token->next;
 	}
-- 
1.7.1


