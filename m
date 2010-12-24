Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0LXXzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 18:55:48 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:44299
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752848Ab0LXXzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 18:55:47 -0500
Date: Fri, 24 Dec 2010 23:56:25 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix freeing user_struct in user cache
Message-ID: <20101224235625.GA18170@mail.hallyn.com>
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

Quoting Hillf Danton (dhillf@gmail.com):
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

Good catch, thanks.

Acked-by: Serge Hallyn <serge@hallyn.com>

> I do not know if you touched that last, but I received the following message,

thanks,
-serge
