Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308Ab2JWTjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:39:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab2JWTjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:39:05 -0400
Date: Tue, 23 Oct 2012 12:39:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>, Jiri Kosina <jkosina@suse.cz>,
        Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove untouched code in kfifo_in
Message-Id: <20121023123903.626f9a7d.akpm@linux-foundation.org>
In-Reply-To: <CAFLxGvyQxdfm9KUcaUSJV5g19zGa71w=a8ma0xxWVuGsrdkzMQ@mail.gmail.com>
References: <1350568765-5723-1-git-send-email-weiyang@linux.vnet.ibm.com>
	<CAFLxGvwfGc_4z1JM=pAb-U4tNVeMZR1zs-neQv7Vz2-6DQT+9Q@mail.gmail.com>
	<1350624189.14741.1.camel@wall-e>
	<alpine.LNX.2.00.1210190934010.7523@pobox.suse.cz>
	<20121022165602.41c4953e.akpm@linux-foundation.org>
	<508600ba.a7fe440a.4c19.fffff64bSMTPIN_ADDED@mx.google.com>
	<CAFLxGvyQxdfm9KUcaUSJV5g19zGa71w=a8ma0xxWVuGsrdkzMQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 21:25:46 +0200
richard -rw- weinberger <richard.weinberger@gmail.com> wrote:

> > Subject: [PATCH] Replace the type check code with typecheck() in kfifo_in
> >
> > In kfifo_in marco, one piece of code which is arounded by if(0) will check the
> > type of __tmp->ptr_const and __buf. If they are different type, there will
> > output a warning during compiling. This piece of code is not self explaining
> > and a little bit hard to understand.
> >
> > Based on Andrew Morton's suggestion, this patch replace this with typecheck()
> > which will be easy to understand.
> > ---
> >  include/linux/kfifo.h |    5 +----
> >  1 files changed, 1 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
> > index 10308c6..b48fe71 100644
> > --- a/include/linux/kfifo.h
> > +++ b/include/linux/kfifo.h
> > @@ -512,10 +512,7 @@ __kfifo_uint_must_check_helper( \
> >         unsigned long __n = (n); \
> >         const size_t __recsize = sizeof(*__tmp->rectype); \
> >         struct __kfifo *__kfifo = &__tmp->kfifo; \
> > -       if (0) { \
> > -               typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
> > -               __dummy = (typeof(__buf))NULL; \
> > -       } \
> > +       typecheck(typeof(__tmp->ptr_const), __buf);\
> >         (__recsize) ?\
> >         __kfifo_in_r(__kfifo, __buf, __n, __recsize) : \
> >         __kfifo_in(__kfifo, __buf, __n); \
> 
> What about all the other open coded type checks in that file?

Yes, there are a lot.  Searching for "if (0)" finds them.
