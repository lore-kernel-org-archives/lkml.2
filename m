Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161266Ab2JXVtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:49:12 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52430 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161211Ab2JXVtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:49:10 -0400
X-Originating-IP: 217.70.178.150
X-Originating-IP: 173.246.103.110
Date: Wed, 24 Oct 2012 14:49:00 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Borislav Petkov <bp@alien8.de>, danielfsantos@att.net,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 03/10] compiler-gcc{3,4}.h: Use GCC_VERSION macro
Message-ID: <20121024214900.GA5925@jtriplet-mobl1>
References: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
 <1351096441-12388-3-git-send-email-daniel.santos@pobox.com>
 <20121024190546.GA17945@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024190546.GA17945@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 09:05:46PM +0200, Borislav Petkov wrote:
> On Wed, Oct 24, 2012 at 11:33:54AM -0500, danielfsantos@att.net wrote:
> > Using GCC_VERSION reduces complexity, is easier to read and is GCC's
> > recommended mechanism for doing version checks. (Just don't ask me why
> > they didn't define it in the first place.)  This also makes it easy to
> > merge compiler-gcc{,3,4}.h should somebody want to.
> > 
> > Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
> > Acked-by: David Rientjes <rientjes@google.com>
> > ---
> >  include/linux/compiler-gcc3.h |    8 ++++----
> >  include/linux/compiler-gcc4.h |   14 +++++++-------
> >  2 files changed, 11 insertions(+), 11 deletions(-)
> > 
> > diff --git a/include/linux/compiler-gcc3.h b/include/linux/compiler-gcc3.h
> > index 37d4124..7d89feb 100644
> > --- a/include/linux/compiler-gcc3.h
> > +++ b/include/linux/compiler-gcc3.h
> > @@ -2,22 +2,22 @@
> >  #error "Please don't include <linux/compiler-gcc3.h> directly, include <linux/compiler.h> instead."
> >  #endif
> >  
> > -#if __GNUC_MINOR__ < 2
> > +#if GCC_VERSION < 30200
> >  # error Sorry, your compiler is too old - please upgrade it.
> >  #endif
> >  
> > -#if __GNUC_MINOR__ >= 3
> > +#if GCC_VERSION >= 30300
> >  # define __used			__attribute__((__used__))
> >  #else
> >  # define __used			__attribute__((__unused__))
> >  #endif
> >  
> > -#if __GNUC_MINOR__ >= 4
> > +#if GCC_VERSION >= 30400
> >  #define __must_check		__attribute__((warn_unused_result))
> >  #endif
> >  
> >  #ifdef CONFIG_GCOV_KERNEL
> > -# if __GNUC_MINOR__ < 4
> > +# if GCC_VERSION < 30400
> >  #   error "GCOV profiling support for gcc versions below 3.4 not included"
> >  # endif /* __GNUC_MINOR__ */
> >  #endif /* CONFIG_GCOV_KERNEL */
> > diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
> > index 8914293..9755029 100644
> > --- a/include/linux/compiler-gcc4.h
> > +++ b/include/linux/compiler-gcc4.h
> > @@ -4,7 +4,7 @@
> >  
> >  /* GCC 4.1.[01] miscompiles __weak */
> >  #ifdef __KERNEL__
> > -# if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
> > +# if GCC_VERSION >= 40100 &&  GCC_VERSION <= 40101
> >  #  error Your version of gcc miscompiles the __weak directive
> >  # endif
> >  #endif
> > @@ -13,11 +13,11 @@
> >  #define __must_check 		__attribute__((warn_unused_result))
> >  #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
> >  
> > -#if __GNUC_MINOR__ > 0
> > +#if GCC_VERSION >= 40100
> 
> I can't seem to recall so did we explain already why ">= 40100" instead
> of "> 40000"?
> 
> I mean, it is the same, but still...

__GNUC_MINOR__ > 0 means __GNUC_MINOR__ >= 1, so that would allow 4.1 or
newer.  However, GCC_VERSION > 40000 would also allow 4.0.n for n > 0.

- Josh Triplett
