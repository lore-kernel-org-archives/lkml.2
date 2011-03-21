Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab1CUXiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:38:04 -0400
Received: from kroah.org ([198.145.64.141]:49628 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab1CUXQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:16:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:16 2011
Message-Id: <20110321230716.735307210@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:07:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tapan Dhimant <tdhimant@akamai.com>, Josh Hunt <johunt@akamai.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [73/87] perf tools: Version incorrect with some versions of grep
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josh Hunt <johunt@akamai.com>

commit 58d406ed6a5f1ca4bc1dba5390b718c67847fa5f upstream.

Some versions of grep don't treat '\s' properly. When building perf on such
systems and using a kernel tarball the perf version is unable to be determined
from the main kernel Makefile and the user is left with a version of '..'.
Replacing the use of '\s' with '[[:space:]]', which should work in all grep
versions, gives a usable version number.

Reported-by: Tapan Dhimant <tdhimant@akamai.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tapan Dhimant <tdhimant@akamai.com>
Cc: linux-kernel@vger.kernel.org
LKML-Reference: <1300241800-30281-1-git-send-email-johunt@akamai.com>
Signed-off-by: Josh Hunt <johunt@akamai.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 tools/perf/util/PERF-VERSION-GEN |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -23,10 +23,10 @@ if test -d ../../.git -o -f ../../.git &
 then
 	VN=$(echo "$VN" | sed -e 's/-/./g');
 else
-	eval `grep '^VERSION\s*=' ../../Makefile|tr -d ' '`
-	eval `grep '^PATCHLEVEL\s*=' ../../Makefile|tr -d ' '`
-	eval `grep '^SUBLEVEL\s*=' ../../Makefile|tr -d ' '`
-	eval `grep '^EXTRAVERSION\s*=' ../../Makefile|tr -d ' '`
+	eval $(grep '^VERSION[[:space:]]*=' ../../Makefile|tr -d ' ')
+	eval $(grep '^PATCHLEVEL[[:space:]]*=' ../../Makefile|tr -d ' ')
+	eval $(grep '^SUBLEVEL[[:space:]]*=' ../../Makefile|tr -d ' ')
+	eval $(grep '^EXTRAVERSION[[:space:]]*=' ../../Makefile|tr -d ' ')
 
 	VN="${VERSION}.${PATCHLEVEL}.${SUBLEVEL}${EXTRAVERSION}"
 fi


