Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab0LXRTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 12:19:24 -0500
Received: from cantor.suse.de ([195.135.220.2]:35958 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab0LXRTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 12:19:23 -0500
Date: Fri, 24 Dec 2010 09:14:59 -0800
From: Greg KH <gregkh@suse.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix freeing user_struct in user cache
Message-ID: <20101224171459.GA31815@suse.de>
References: <AANLkTi=vfO-rs_iStXkPC7STSqfgUEW_JKt2w1=Wmf6Z@mail.gmail.com>
 <20101224035523.GC25057@suse.de>
 <AANLkTi=PwGXTKKyXDA1sckosbGmeo+D0bGuXt3Jb-ttc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=PwGXTKKyXDA1sckosbGmeo+D0bGuXt3Jb-ttc@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 10:24:02PM +0800, Hillf Danton wrote:
> On Fri, Dec 24, 2010 at 11:55 AM, Greg KH <gregkh@suse.de> wrote:
> > On Thu, Dec 23, 2010 at 08:52:34PM +0800, Hillf Danton wrote:
> >> When racing on adding into user cache, the new allocated from mm slab
> >> is freed without putting user namespace.
> >>
> >> Since the user namespace is already operated by getting, putting has
> >> to be issued.
> >>
> >> btw, it could be freed out of lock?
> >>
> >> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> >> ---
> >>
> >> --- a/kernel/user.c   2010-11-01 19:54:12.000000000 +0800
> >> +++ b/kernel/user.c   2010-12-23 20:42:00.000000000 +0800
> >> @@ -158,6 +158,7 @@ struct user_struct *alloc_uid(struct use
> >>               spin_lock_irq(&uidhash_lock);
> >>               up = uid_hash_find(uid, hashent);
> >>               if (up) {
> >> +                     put_user_ns(ns);
> >>                       key_put(new->uid_keyring);
> >>                       key_put(new->session_keyring);
> >>                       kmem_cache_free(uid_cachep, new);
> >
> > Hm, are you sure about this?  Also, why send this to me, did I last
> > touch this?
> >
> 
> sure with no doubt.
> 
> I do not know if you touched that last, but I received the following message,
> 
> On Tue, Dec 21, 2010 at 3:42 AM,  <gregkh@suse.de> wrote:
> >
> > This is a note to let you know that I've just added the patch titled
> >
> >    bonding: Fix slave selection bug.
> >
> > to the 2.6.36-stable tree which can be found at:
> >    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> so you were Cced since you charge patch delivered.

That was a stable patch, I send all of those out :)

Use scripts/get_maintainer.pl to determine the best person to send this
patch to (hint, it's not me.)

thanks,

greg k-h
