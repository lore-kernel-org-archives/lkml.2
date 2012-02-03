Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2BCXUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 18:20:49 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47723 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753312Ab2BCXUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 18:20:48 -0500
Message-ID: <1328311239.21255.24.camel@joe2Laptop>
Subject: [PATCH] checkpatch: Warn on code with 6+ tab indentation
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Date: Fri, 03 Feb 2012 15:20:39 -0800
In-Reply-To: <CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
References: <20120130140905.441199885@openvz.org>
	 <20120130141852.309402052@openvz.org> <20120203074656.GC30543@elte.hu>
	 <20120203083530.GD1968@moon> <20120203090929.GA23996@elte.hu>
	 <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
	 <20120203095227.GA13162@elte.hu> <20120203100743.GA3334@elte.hu>
	 <CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overly indented code should be refactored.

Suggest refactoring excessive indentation of
of if/else/for/do/while/switch statements.

For example:

$ cat t.c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{

	if (1)
		if (2)
			if (3)
				if (4)
					if (5)
						if (6)
							if (7)
								if (8)
									;
	return 0;
}

$ ./scripts/checkpatch.pl -f t.c
WARNING: Too many leading tabs - consider code refactoring
#12: FILE: t.c:12:
+						if (6)

WARNING: Too many leading tabs - consider code refactoring
#13: FILE: t.c:13:
+							if (7)

WARNING: Too many leading tabs - consider code refactoring
#14: FILE: t.c:14:
+								if (8)

total: 0 errors, 3 warnings, 17 lines checked

t.c has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Signed-off-by: Joe Perches <joe@perches.com>
---
On Fri, 2012-02-03 at 13:27 -0800, Linus Torvalds wrote:
> So no, 100-char columns are not ok.

Perhaps this is a reasonable alternative.

Another might be to limit variable name length to something
shorter than say 10 characters.

 scripts/checkpatch.pl |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2b52aeb..89d24b3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1924,6 +1924,12 @@ sub process {
 			my $pre_ctx = "$1$2";
 
 			my ($level, @ctx) = ctx_statement_level($linenr, $realcnt, 0);
+
+			if ($line =~ /^\+\t{6,}/) {
+				WARN("DEEP_INDENTATION",
+				     "Too many leading tabs - consider code refactoring\n" . $herecurr);
+			}
+
 			my $ctx_cnt = $realcnt - $#ctx - 1;
 			my $ctx = join("\n", @ctx);
 


