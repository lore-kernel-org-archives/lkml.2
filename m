Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab2JAQwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 12:52:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21806 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab2JAQwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 12:52:07 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=WaOQOxnRRJ8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=hG2BnABgsmYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=w-CkV6B07v3U-OWwjUUA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349110326.22822.120.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL] ktest: Fix ELSE IF statements
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 01 Oct 2012 12:52:06 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

ktest has one fix needed for this merge window.

-- Steve

Please pull the latest ktest-v3.7 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-v3.7

Head SHA1: 5c5dcb8b1dd19ece1c82049e4afe95f0f24b77bf


Steven Rostedt (1):
      ktest: Fix ELSE IF statements

----
 tools/testing/ktest/ktest.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
---------------------------
commit 95f57838418358e93212e9dddd60d3502c7f8e2e
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Sep 26 14:48:17 2012 -0400

    ktest: Fix ELSE IF statements
    
    The ELSE IF statements do not work as expected if another ELSE statement
    follows. This is because the $if_set is not set. If the ELSE IF
    condition is true, the following ELSE should be ignored. But because the
    $if_set is not set, the following ELSE will also be executed.
    
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 52b7959..c05bcd2 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -840,7 +840,9 @@ sub __read_config {
 
 		if ($rest =~ /\sIF\s+(.*)/) {
 		    # May be a ELSE IF section.
-		    if (!process_if($name, $1)) {
+		    if (process_if($name, $1)) {
+			$if_set = 1;
+		    } else {
 			$skip = 1;
 		    }
 		    $rest = "";


