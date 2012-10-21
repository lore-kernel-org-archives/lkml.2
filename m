Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2JUCFb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 22:05:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43159 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2JUCFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 22:05:30 -0400
Message-ID: <1350785121.12361.2.camel@CruzBishop-ASPIRE>
Subject: Re: [PATCH 1/2] staging: android: checkpatch.pl fixes
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: "Ken O'Brien" <kernel@kenobrien.org>, gregkh@linuxfoundation.org,
        swetland@google.com, arve@android.com, viro@zeniv.linux.org.uk,
        dhowells@redhat.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 21 Oct 2012 12:05:21 +1000
In-Reply-To: <1350781512.16706.3.camel@joe-AO722>
References: <1350772400-12347-1-git-send-email-kernel@kenobrien.org>
	 <1350781512.16706.3.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-20 at 18:05 -0700, Joe Perches wrote:
> On Sat, 2012-10-20 at 23:33 +0100, Ken O'Brien wrote:
> > Fixed all instances of strings spanning multiple lines from checkpatch.pl.
> []
> > diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> []
> > @@ -556,7 +556,7 @@ static int binder_update_page_range(struct binder_proc *proc, int allocate,
> >  		goto free_range;
> >  
> >  	if (vma == NULL) {
> > -		pr_err("binder: %d: binder_alloc_buf failed to "
> > +		pr_err("binder: %d: binder_alloc_buf failed to " \
> >  		       "map pages in userspace, no vma\n", proc->pid);
> 
> Hi Ken.
> 
> Nice try, but the "right" way to do this is to coalesce formats like:
> 
> 		pr_err("binder: %d: binder_alloc_buf failed to map pages in userspace, no vma\n",
> 		       proc->pid);
> 
> and ignore 80 column line lengths for these coalesced formats.

Going off that, is there currently any way to insert, say,
a comment that filters out the next line for checkpatch
errors?

For example,

/* checkpatch_ignore_(rulename) */
(Long line that can't be broken here)


> 
> An even better way is to add
> 
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> before any #include and change the format to:
> 
> 		pr_err("%d: binder_alloc_buf failed to map pages in userspace, no vma\n",
> 		       proc->pid);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


