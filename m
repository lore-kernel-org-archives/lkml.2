Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab2J1Eqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 00:46:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40519 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751040Ab2J1Eqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 00:46:51 -0400
Message-ID: <1351399596.13495.3.camel@joe-AO722>
Subject: [PATCH v2] checkpatch: Warn on unnecessary line continuations
From: Joe Perches <joe@perches.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        David Howells <dhowells@redhat.com>,
        "Ken O'Brien" <kernel@kenobrien.org>, gregkh@linuxfoundation.org,
        swetland@google.com, arve@android.com, viro@zeniv.linux.org.uk,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1350924315.7502.6.camel@joe-AO722>
References: <1350781512.16706.3.camel@joe-AO722>
	 <1350772400-12347-1-git-send-email-kernel@kenobrien.org>
	 <18159.1350898659@warthog.procyon.org.uk>
	 <1350908109.5931.28.camel@joe-AO722> <1350910971.28457.3.camel@thor>
	 <1350911803.7502.4.camel@joe-AO722> <1350924315.7502.6.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sat, 27 Oct 2012 21:46:36 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.6.0-0ubuntu3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the previous line is not a line continuation and the
current line has a line continuation but is not a #define,
emit a warning.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f18750e..d4f61a6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3013,6 +3013,15 @@ sub process {
 					      "Macros with complex values should be enclosed in parenthesis\n" . "$herectx");
 				}
 			}
+
+# check for line continuations outside of #defines
+
+		} else {
+			if ($prevline !~ /^..*\\$/ &&
+			    $line =~ /^\+.*\\$/) {
+				WARN("LINE_CONTINUATIONS",
+				     "Avoid unnecessary line continuations\n" . $herecurr);
+			}
 		}
 
 # do {} while (0) macro tests:


