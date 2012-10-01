Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2JAUcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 16:32:36 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43153 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2JAUce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 16:32:34 -0400
X-Originating-IP: 217.70.178.142
X-Originating-IP: 173.246.103.110
Date: Mon, 1 Oct 2012 13:32:25 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Santos <daniel.santos@pobox.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        Akinobu Mita <akinobu.mita@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Don Zickus <dzickus@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6 4/25] compiler-gcc{3,4}.h: Use GCC_VERSION macro
Message-ID: <20121001203224.GB8478@jtriplet-mobl1>
References: <1348797281-25021-1-git-send-email-daniel.santos@pobox.com>
 <1348797281-25021-5-git-send-email-daniel.santos@pobox.com>
 <20121001123944.e06379db.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001123944.e06379db.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 12:39:44PM -0700, Andrew Morton wrote:
> On Thu, 27 Sep 2012 20:54:20 -0500
> Daniel Santos <daniel.santos@pobox.com> wrote:
> 
> > Using GCC_VERSION reduces complexity, is easier to read and is GCC's
> > recommended mechanism for doing version checks. (Just don't ask me why
> > they didn't define it in the first place.)  This also makes it easy to
> > merge compiler-gcc{3,4}.h should somebody want to.
> > 
> > Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
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
> > index 4506d65..b44307d 100644
> > --- a/include/linux/compiler-gcc4.h
> > +++ b/include/linux/compiler-gcc4.h
> > @@ -4,7 +4,7 @@
> >  
> >  /* GCC 4.1.[01] miscompiles __weak */
> >  #ifdef __KERNEL__
> > -# if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
> > +# if GCC_VERSION >= 40100 &&  GCC_VERSION <= 40101
> >  //#  error Your version of gcc miscompiles the __weak directive
> >  # endif
> >  #endif
> > @@ -13,11 +13,11 @@
> >  #define __must_check 		__attribute__((warn_unused_result))
> >  #define __compiler_offsetof(a,b) __builtin_offsetof(a,b)
> >  
> > -#if __GNUC_MINOR__ > 0
> > +#if GCC_VERSION >= 40102
> 
> Is this correct (and clear)?  I'd expect
> 
> 	#if GCC_VERSION > 40000

GCC_VERSION >= 40100, actually; __GNUC_MINOR__ > 0 implies
__GNUC_MINOR__ >= 1, whereas the version you wrote would accept 4.0.1.

- Josh Triplett
