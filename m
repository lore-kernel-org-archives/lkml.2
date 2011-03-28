Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1C1OgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:36:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37825 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab1C1Of7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:35:59 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=Wnk5zM0xl1sA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=M-ZjiwQ0R3kL_q9JbK8A:9 a=WZt9-qDREm8Pp2VXjwMQ-TUBCKgA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH v2][GIT PULL] WARN_ON_SMP(): Add comment to explain ({0;})
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 28 Mar 2011 10:35:56 -0400
Message-ID: <1301322956.14261.228.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

As there were conflicts with the first version, I rebased on top of
Linus's latest tree. It's just a comment change so I doubt this would
cause any harm wrt rebasing.

-- Steve

Please pull the latest tip/futex/devel-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-rt.git
tip/futex/devel-2


Steven Rostedt (1):
      WARN_ON_SMP(): Add comment to explain ({0;})

----
 include/asm-generic/bug.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)
---------------------------
commit ccd0d44fad38dc1bb4b26dcc7a30e9f2c3b36870
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Mar 25 16:21:06 2011 -0400

    WARN_ON_SMP(): Add comment to explain ({0;})
    
    The define to use ({0;}) for the !CONFIG_SMP case of WARN_ON_SMP()
    can be confusing. As the WARN_ON_SMP() needs to be a nop when
    CONFIG_SMP is not set, including all its parameters must not be
    evaluated, and that it must work as both a stand alone statement
    and inside an if condition, we define it to a funky ({0;}).
    
    A simple "0" will not work as it causes gcc to give the warning that
    the statement has no effect.
    
    As this strange definition has raised a few eyebrows from some
    major kernel developers, it is wise to document why we create such
    a work of art.
    
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index f2d2faf..e5a3f58 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -194,6 +194,13 @@ extern void warn_slowpath_null(const char *file, const int line);
 #ifdef CONFIG_SMP
 # define WARN_ON_SMP(x)			WARN_ON(x)
 #else
+/*
+ * Use of ({0;}) because WARN_ON_SMP(x) may be used either as
+ * a stand alone line statement or as a condition in an if ()
+ * statement.
+ * A simple "0" would cause gcc to give a "statement has no effect"
+ * warning.
+ */
 # define WARN_ON_SMP(x)			({0;})
 #endif
 


