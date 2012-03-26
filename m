Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab2CZSdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:33:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53561 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830Ab2CZSde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:33:34 -0400
Date: Mon, 26 Mar 2012 22:33:30 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [rfc] fcntl: Add F_GETOWNER_UIDS option
Message-ID: <20120326183330.GM19395@moon>
References: <20120326150924.GG19395@moon>
 <20120326164347.GA24394@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120326164347.GA24394@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 06:43:47PM +0200, Oleg Nesterov wrote:
> On 03/26, Cyrill Gorcunov wrote:
> >
> > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > +static int f_getowner_uids(struct file *filp, unsigned long arg)
> > +{
> > +	struct user_namespace *user_ns = current_user_ns();
> > +	const struct cred *cred = current_cred();
> > +	uid_t * __user dst = (void * __user)arg;
> > +	uid_t src[2];
> > +	int err;
> > +
> > +	read_lock(&filp->f_owner.lock);
> > +	src[0] = filp->f_owner.uid;
> > +	src[1] = filp->f_owner.euid;
> > +	read_unlock(&filp->f_owner.lock);
> > +
> > +	src[0] = user_ns_map_uid(user_ns, cred, src[0]);
> > +	src[1] = user_ns_map_uid(user_ns, cred, src[1]);
> 
> Why?
> 
> In this case user_ns_map_uid() is "nop", it should always return
> the last arg, no?

Yes, but I wanted to be on safe side, and if one day user_ns_map_uid
get changed this function won't be security hole. Or I miss something
in general?

	Cyrill
