Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab2JVUCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:02:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63419 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2JVUCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:02:15 -0400
Date: Mon, 22 Oct 2012 13:02:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Anmol Sarma <unmole.in@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, arve@android.com
Subject: Re: [PATCH] Staging: android: binder: Fixed multi-line strings
Message-ID: <20121022200212.GA18168@kroah.com>
References: <n>
 <1349722863-18835-1-git-send-email-unmole.in@gmail.com>
 <1349738114.15802.27.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349738114.15802.27.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 04:15:14PM -0700, Joe Perches wrote:
> On Tue, 2012-10-09 at 00:31 +0530, Anmol Sarma wrote:
> > Changed all user visible multi-line stings to single line.
> 
> Another patch might be to add
> 
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> before any #include and
> 
> > diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> []
> > @@ -556,8 +556,8 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
> >  		goto free_range;
> >  
> >  	if (vma == NULL) {
> > -		pr_err("binder: %d: binder_alloc_buf failed to "
> > -		       "map pages in userspace, no vma\n", proc->pid);
> > +		pr_err("binder: %d: binder_alloc_buf failed to map pages in userspace, no vma\n",
> > +			proc->pid);
> 
> remove all the "binder: " prefixes like:
> 
> 		pr_err("%d: binder_alloc_buf failed to map pages in userspace, no vma\n",
> 		       proc->pid);

Yes, that would be the better fix.

Anmol, care to redo this patch that way?

thanks,

greg k-h
