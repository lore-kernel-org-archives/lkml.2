Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab0DSWFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 18:05:10 -0400
Received: from baikonur.stro.at ([213.239.196.228]:55013 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab0DSWFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 18:05:08 -0400
Date: Mon, 19 Apr 2010 23:57:11 +0200
From: maximilian attems <max@stro.at>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Ulrich Drepper <drepper@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH] fcntl.h: define AT_EACCESS
Message-ID: <20100419215711.GR10984@baikonur.stro.at>
References: <1271387280-19565-1-git-send-email-max@stro.at> <20100419144729.2b8180e8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419144729.2b8180e8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 02:47:29PM -0700, Andrew Morton wrote:
> On Fri, 16 Apr 2010 05:08:00 +0200
> maximilian attems <max@stro.at> wrote:
> 
> > noticed on a klibc build of dash that someone had left out that def:
> > usr/dash/bltin/test.c:490: error: ___AT_EACCESS___ undeclared (first use in thiction)
> > 
> > Cc: stable@kernel.org
> > Cc: Ulrich Drepper <drepper@redhat.com>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Signed-off-by: maximilian attems <max@stro.at>
> > ---
> >  include/linux/fcntl.h |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
> > index 8603740..8bb001d 100644
> > --- a/include/linux/fcntl.h
> > +++ b/include/linux/fcntl.h
> > @@ -39,6 +39,8 @@
> >  #define AT_REMOVEDIR		0x200   /* Remove directory instead of
> >                                             unlinking file.  */
> >  #define AT_SYMLINK_FOLLOW	0x400   /* Follow symbolic links.  */
> > +#define AT_EACCESS		0x200	/* Test access permitted for
> > +					   effective IDs, not real IDs.  */
> >  
> 
> I'm all confused.
> 
> The affects sys_faccesat(), yes?  But sys_faccesat() never gets passed
> a `flags' argument so how does the behaviour which the FACCESSAT(2)
> manpage describes get implemented?
> 
> This patch doesn't actually change kernel behaviour, so how can setting
> AT_EACCESS change any syscall's actions?
> 
> It's a bit of a worry that the proposed value for AT_EACCESS duplicates
> AT_REMOVEDIR.  I guess that, despite apeparances, they're different
> namespaces.  Any thoughts on the implications of this?

glibc fcntl.h defines AT_EACCESS in the same way as aboves patch,
concerning the implementation, others should know better.

the dash code calling faccessat has the 4 params,
klibc faccessat had only 3 args, guess nobody had used it before.

the relevant dash code reads:
#ifdef HAVE_FACCESSAT
static int test_file_access(const char *path, int mode)
{
	return !faccessat(AT_FDCWD, path, mode, AT_EACCESS);
}
#else  /* HAVE_FACCESSAT */
 
