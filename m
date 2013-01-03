Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab3ACAdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 19:33:23 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60560 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753015Ab3ACAdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 19:33:22 -0500
Message-ID: <1357173201.25181.22.camel@joe-AO722>
Subject: [PATCH] checkpatch: Warn on unnecessary __dev<foo> section markings
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 02 Jan 2013 16:33:21 -0800
In-Reply-To: <20130102160935.ec405bc4.akpm@linux-foundation.org>
References: <20130102232730.5706.82243.stgit@grignak.americas.hpqcorp.net>
	 <20130102232743.5706.63153.stgit@grignak.americas.hpqcorp.net>
	 <1357171594.25181.19.camel@joe-AO722>
	 <20130102160935.ec405bc4.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get people to stop adding __devinit and __devexit section markings.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4d2c7df..325caa7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1931,6 +1931,12 @@ sub process {
 			      "use the SSYNC() macro in asm/blackfin.h\n" . $herevet);
 		}
 
+# check for old HOTPLUG __dev<foo> section markings
+		if ($line =~ /\b(__dev(init|exit)(data|const|))\b/) {
+			WARN("HOTPLUG_SECTION",
+			     "Using $1 is unnecessary\n" . $herecurr);
+		}
+
 # Check for potential 'bare' types
 		my ($stat, $cond, $line_nr_next, $remain_next, $off_next,
 		    $realline_next);


