Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab2BOVxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 16:53:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2BOVxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 16:53:15 -0500
Date: Wed, 15 Feb 2012 13:53:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "hpanvin@gmail.com" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [patch 2/4] syscalls, x86: Add __NR_kcmp syscall v8
Message-Id: <20120215135313.0e22d1bf.akpm@linux-foundation.org>
In-Reply-To: <20120215072454.GA4533@moon>
References: <20120213164822.227219834@openvz.org>
	<20120213165137.903318774@openvz.org>
	<20120214151312.92afd44a.akpm@linux-foundation.org>
	<20120215065245.GB1894@moon>
	<bb6e15c8-1b6b-4809-a796-cdfac39bc8b4@email.android.com>
	<20120215070427.GE1894@moon>
	<20120215072454.GA4533@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012 11:24:54 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> On Wed, Feb 15, 2012 at 11:04:27AM +0400, Cyrill Gorcunov wrote:
> > On Tue, Feb 14, 2012 at 10:55:55PM -0800, hpanvin@gmail.com wrote:
> > >
> > > What?  <linux/unistd.h> should be used, and it should handle
> > > the inclusions.
> > >
> > 
> > Peter, I maybe missing something which directories I should
> > add to -I option, letme recheck (but without headers_intall
> > target the syscall number is unresolved for me).
> > 
> 
> Ah, I missed to add
> 
> +CFLAGS += -I../../../../arch/x86/include/
> 
> into Makefile. Andrew, should I send update as a separate
> patch?
> 

That worked.

What's with all those warnings, btw?


From: Andrew Morton <akpm@linux-foundation.org>
Subject: syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix-fix

kcmp_test.c: In function 'main':
kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 4 has type 'long int'
kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 5 has type 'long int'
kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 6 has type 'long int'
kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 7 has type 'long int'
kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 8 has type 'long int'
kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 9 has type 'long int'
kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 10 has type 'long int'
kcmp_test.c:69: warning: format '%2d' expects type 'int', but argument 11 has type 'long int'

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kcmp/kcmp_test.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/kcmp/kcmp_test.c~syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix-fix
+++ a/tools/testing/selftests/kcmp/kcmp_test.c
@@ -54,8 +54,9 @@ int main(int argc, char **argv)
 		}
 
 		/* An example of output and arguments */
-		printf("pid1: %6d pid2: %6d FD: %2d FILES: %2d VM: %2d FS: %2d "
-		       "SIGHAND: %2d IO: %2d SYSVSEM: %2d INV: %2d\n",
+		printf("pid1: %6d pid2: %6d FD: %2ld FILES: %2ld VM: %2ld "
+		       "FS: %2ld SIGHAND: %2ld IO: %2ld SYSVSEM: %2ld "
+		       "INV: %2ld\n",
 		       pid1, pid2,
 		       sys_kcmp(pid1, pid2, KCMP_FILE,		fd1, fd2),
 		       sys_kcmp(pid1, pid2, KCMP_FILES,		0, 0),
_

