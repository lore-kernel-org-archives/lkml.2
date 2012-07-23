Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab2GWRrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:47:13 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:45572 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754229Ab2GWRrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:47:11 -0400
Message-ID: <500D8DE3.20104@xenotime.net>
Date: Mon, 23 Jul 2012 10:46:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] watchdog: fix watchdog-test.c build warning
References: <20120723164036.52bc93caafcd165fc16f0284@canb.auug.org.au>
In-Reply-To: <20120723164036.52bc93caafcd165fc16f0284@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix compiler warning by making the function static:

Documentation/watchdog/src/watchdog-test.c:34:6: warning: no previous prototype for 'term'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Wim Van Sebroeck <wim@iguana.be>
Cc:	linux-watchdog@vger.kernel.org
---
 Documentation/watchdog/src/watchdog-test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120723.orig/Documentation/watchdog/src/watchdog-test.c
+++ linux-next-20120723/Documentation/watchdog/src/watchdog-test.c
@@ -31,7 +31,7 @@ static void keep_alive(void)
  * or "-e" to enable the card.
  */
 
-void term(int sig)
+static void term(int sig)
 {
     close(fd);
     fprintf(stderr, "Stopping watchdog ticks...\n");
