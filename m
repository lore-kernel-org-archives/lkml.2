Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2FZWDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 18:03:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54011 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2FZWDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 18:03:10 -0400
Date: Tue, 26 Jun 2012 15:03:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: Sherwin Soltani <sherwin@wybc.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, swetland@google.com
Subject: Re: [PATCH] drivers: staging: android: binder.c: fix printk macros
Message-ID: <20120626220306.GA14221@kroah.com>
References: <1340690430-13016-1-git-send-email-sherwin@wybc.com>
 <1340692980.4177.6.camel@fourier.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1340692980.4177.6.camel@fourier.local.igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 08:43:00AM +0200, Samuel Iglesias Gonsálvez wrote:
> On Tue, 2012-06-26 at 02:00 -0400, Sherwin Soltani wrote:
> > Change printk() messages to pr_* macros.
> > 
> > Signed-off-by: Sherwin Soltani <sherwin@wybc.com>
> > ---
> >  drivers/staging/android/binder.c |   54 +++++++++++++++++++-------------------
> >  1 file changed, 27 insertions(+), 27 deletions(-)
> > 
> > diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> > index c283212..574e992 100644
> > --- a/drivers/staging/android/binder.c
> > +++ b/drivers/staging/android/binder.c
> > @@ -124,13 +124,13 @@ module_param_call(stop_on_user_error, binder_set_stop_on_user_error,
> >  #define binder_debug(mask, x...) \
> >  	do { \
> >  		if (binder_debug_mask & mask) \
> > -			printk(KERN_INFO x); \
> > +			pr_info(x); \
> >  	} while (0)
> >  
> >  #define binder_user_error(x...) \
> >  	do { \
> >  		if (binder_debug_mask & BINDER_DEBUG_USER_ERROR) \
> > -			printk(KERN_INFO x); \
> > +			pr_info(x); \
> >  		if (binder_stop_on_user_error) \
> >  			binder_stop_on_user_error = 2; \
> >  	} while (0)
> > @@ -418,7 +418,7 @@ repeat:
> >  #if 1
> >  	/* Sanity check */
> >  	if (fdt->fd[fd] != NULL) {
> > -		printk(KERN_WARNING "get_unused_fd: slot %d not NULL!\n", fd);
> > +		pr_warn("get_unused_fd: slot %d not NULL!\n", fd);
> >  		fdt->fd[fd] = NULL;
> >  	}
> >  #endif
> > @@ -644,7 +644,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
> >  		goto free_range;
> >  
> >  	if (vma == NULL) {
> > -		printk(KERN_ERR "binder: %d: binder_alloc_buf failed to "
> > +		pr_err("binder: %d: binder_alloc_buf failed to "
> >  		       "map pages in userspace, no vma\n", proc->pid);
> 
> Instead of using the "binder: " prefix here and there and now that you
> have changed to pr_* functions, you can define the pr_fmt macro at the
> beginning of the file (just before the #include sentences).

That's a good idea, but not necessary for this patch.  A follow-on patch
perhaps :)

greg k-h
