Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab2KYDCs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 22:02:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab2KYDCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 22:02:47 -0500
Date: Sun, 25 Nov 2012 11:02:31 +0800
From: Dave Young <dyoung@redhat.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [patch 6/8] kcmp selftests: build fix
Message-ID: <20121125030231.GA2101@darkstar.nay.redhat.com>
References: <20121124082918.671430919@redhat.com>
 <20121124083139.691424172@redhat.com>
 <CAOJsxLGQ+UQnFnbcn9oMTUBd0HB+CSfRy_R0Ze2UOJJfR1+K=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLGQ+UQnFnbcn9oMTUBd0HB+CSfRy_R0Ze2UOJJfR1+K=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 11:41:23AM +0200, Pekka Enberg wrote:
> On Sat, Nov 24, 2012 at 10:29 AM,  <dyoung@redhat.com> wrote:
> > For old glibc there's no the syscall number this tests will cause
> > make run_tests fail.
> > Add a macro to define the number. This should be ok because it will be
> > built in latest kernel source.
> >
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  tools/testing/selftests/kcmp/kcmp_test.c |    3 +++
> >  1 file changed, 3 insertions(+)
> >
> > --- linux-2.6.orig/tools/testing/selftests/kcmp/kcmp_test.c     2012-11-23 22:37:04.789058192 +0800
> > +++ linux-2.6/tools/testing/selftests/kcmp/kcmp_test.c  2012-11-23 22:38:43.195191747 +0800
> > @@ -17,6 +17,9 @@
> >  #include <sys/stat.h>
> >  #include <sys/wait.h>
> >
> > +#ifndef __NR_kcmp
> > +#define __NR_kcmp 272
> > +#endif
> 
> Is the syscall number really going to be the same across all architectures?

Oh, they are different. self NACK. Please ignore this patch.

> 
> >  static long sys_kcmp(int pid1, int pid2, int type, int fd1, int fd2)
> >  {
> >         return syscall(__NR_kcmp, pid1, pid2, type, fd1, fd2);
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
