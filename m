Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab2KWRYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 12:24:35 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:54961 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753875Ab2KWRYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 12:24:34 -0500
Message-ID: <1353691473.28931.8.camel@joe-AO722>
Subject: [PATCH] checkpatch: Add --strict messages for blank lines around
 braces
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 23 Nov 2012 09:24:33 -0800
In-Reply-To: <20121122150204.GB30773@dm>
References: <1353580190-14721-1-git-send-email-glommer@parallels.com>
	 <1353580190-14721-3-git-send-email-glommer@parallels.com>
	 <50AE0031.1020404@parallels.com> <50AE2E5E.7010006@parallels.com>
	 <1353592956.10902.5.camel@joe-AO722> <20121122150204.GB30773@dm>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Blank lines around braces are not unnecessary.
Emit a message on the use of these blank lines only when
using --strict.

int foo(int bar)
{

	something or other....

}

is generally written in the kernel as:

int foo(int bar)
{
	something or other...
}

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 13ce29e..6d0247f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3184,6 +3184,16 @@ sub process {
 			}
 		}
 
+# check for unnecessary blank lines around braces
+		if (($line =~ /^..*}\s*$/ && $prevline =~ /^.\s*$/)) {
+			CHK("BRACES",
+			    "Blank lines aren't necessary before a close brace '}'\n" . $hereprev);
+		}
+		if (($line =~ /^.\s*$/ && $prevline =~ /^..*{\s*$/)) {
+			CHK("BRACES",
+			    "Blank lines aren't necessary after an open brace '{'\n" . $hereprev);
+		}
+
 # no volatiles please
 		my $asm_volatile = qr{\b(__asm__|asm)\s+(__volatile__|volatile)\b};
 		if ($line =~ /\bvolatile\b/ && $line !~ /$asm_volatile/) {


