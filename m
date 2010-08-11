Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab0HKFWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 01:22:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751304Ab0HKFWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 01:22:18 -0400
Date: Tue, 10 Aug 2010 22:23:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Fomenko <ext-alexey.fomenko@nokia.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Michal Marek <mmarek@suse.cz>,
        Trevor Keith <tsrk@tsrk.net>
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20100810222310.e04f7031.akpm@linux-foundation.org>
In-Reply-To: <20100811133812.2b594551.sfr@canb.auug.org.au>
References: <20100811133812.2b594551.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010 13:38:12 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> The only patch new to linux-next since yesterday that affects scripts/mod
> is commit 37ed19d5cce35a40d3913cf9aa208ce9f60db3d7
> ("scripts/mod/modpost.c: fix memory leak") from Linus' tree.
> 
> I have reverted that commit in linux-next for today as that makes the
> error go away.

doh.  This?


From: Andrew Morton <akpm@linux-foundation.org>

- don't kfree("")

- fix one missed conversion

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
Cc: Trevor Keith <tsrk@tsrk.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN scripts/mod/modpost.c~d scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~d
+++ a/scripts/mod/modpost.c
@@ -14,6 +14,7 @@
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <ctype.h>
+#include <string.h>
 #include "modpost.h"
 #include "../../include/generated/autoconf.h"
 #include "../../include/linux/license.h"
@@ -1167,7 +1168,7 @@ static char *sec2annotation(const char *
 			strcat(p, " ");
 		return r; /* we leak her but we do not care */
 	} else {
-		return "";
+		return strdup("");
 	}
 }
 
@@ -1302,7 +1303,7 @@ static void report_sec_mismatch(const ch
 		"%s%s so it may be used outside an exit section.\n",
 		from, prl_from, fromsym, from_p,
 		to, prl_to, tosym, to_p,
-		sec2annotation(tosec), tosym, to_p);
+		prl_to, tosym, to_p);
 		free(prl_from);
 		free(prl_to);
 		break;
_

