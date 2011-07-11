Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab1GKWcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 18:32:08 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10316 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136Ab1GKWcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 18:32:06 -0400
Date: Tue, 12 Jul 2011 00:32:04 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Richard Henderson <rth@tamu.edu>, Bjorn Ekwall <bj0rn@blox.se>,
        trivial@kernel.org
Subject: [PATCH] genksyms: Use same type in loop comparison
Message-ID: <alpine.LNX.2.00.1107120030040.10944@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARRAY_SIZE macro in scripts/genksyms/genksyms.c returns a value of
type size_t. That value is being compared to a variable of type int in
a loop in read_node(). Change the int variable to size_t type as well,
so we don't do signed vs unsigned type comparisons with all the
potential promotion/sign extension trouble that can cause (also
silences compiler warnings at high levels of warnings).

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 scripts/genksyms/genksyms.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/genksyms/genksyms.c b/scripts/genksyms/genksyms.c
index f9e7553..6d3fda0 100644
--- a/scripts/genksyms/genksyms.c
+++ b/scripts/genksyms/genksyms.c
@@ -448,7 +448,7 @@ static struct string_list *read_node(FILE *f)
 	node.string = buffer;
 
 	if (node.string[1] == '#') {
-		int n;
+		size_t n;
 
 		for (n = 0; n < ARRAY_SIZE(symbol_types); n++) {
 			if (node.string[0] == symbol_types[n].n) {
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

