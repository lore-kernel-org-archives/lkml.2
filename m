Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab2AXCra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:47:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655Ab2AXCrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:47:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:32 2012
Message-Id: <20120124023932.566998891@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        James Morris <jmorris@namei.org>
Subject: [097/129] TOMOYO: Accept \000 as a valid character.
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1152
Lines: 37

From: Tetsuo Handa <from-tomoyo-users-en@I-love.SAKURA.ne.jp>

commit 25add8cf99c9ec8b8dc0acd8b9241e963fc0d29c upstream.

TOMOYO 2.5 in Linux 3.2 and later handles Unix domain socket's address.
Thus, tomoyo_correct_word2() needs to accept \000 as a valid character, or
TOMOYO 2.5 cannot handle Unix domain's abstract socket address.

Reported-by: Steven Allen <steven@stebalien.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/tomoyo/util.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/security/tomoyo/util.c
+++ b/security/tomoyo/util.c
@@ -492,13 +492,13 @@ static bool tomoyo_correct_word2(const c
 				if (d < '0' || d > '7' || e < '0' || e > '7')
 					break;
 				c = tomoyo_make_byte(c, d, e);
-				if (tomoyo_invalid(c))
-					continue; /* pattern is not \000 */
+				if (c <= ' ' || c >= 127)
+					continue;
 			}
 			goto out;
 		} else if (in_repetition && c == '/') {
 			goto out;
-		} else if (tomoyo_invalid(c)) {
+		} else if (c <= ' ' || c >= 127) {
 			goto out;
 		}
 	}


