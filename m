Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab0LQUHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:07:48 -0500
Received: from kroah.org ([198.145.64.141]:38968 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096Ab0LQUHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:07:46 -0500
Date: Fri, 17 Dec 2010 11:57:15 -0800
From: Greg KH <greg@kroah.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
Subject: Re: [RFC 1/5] user namespaces: Add a user_namespace as
 creator/owner of uts_namespace
Message-ID: <20101217195715.GA1410@kroah.com>
References: <20101217152246.GA8221@mail.hallyn.com>
 <20101217152458.GA11162@mail.hallyn.com>
 <20101217173125.GA29982@kroah.com>
 <20101217194645.GA3131@peq>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101217194645.GA3131@peq>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 01:46:45PM -0600, Serge Hallyn wrote:
> Quoting Greg KH (greg@kroah.com):
> > > +extern struct user_namespace init_user_ns;
> > >  struct uts_namespace init_uts_ns = {
> > >  	.kref = {
> > >  		.refcount	= ATOMIC_INIT(2),
> > 
> > Wait, WTF?
> > 
> > You have a static kref and you try to automatically instanciate it here?
> 
> You're complaining about the pre-existing init_uts_ns right?

Yup.

> > As it's static, why are you even having a kref at all, what good does it
> > do you, you can't delete the thing,
> 
> Can't delete this one, but can delete all the uts namespaces, obviously.
> As with init_tgcred in kernel/cred.c.
> 
> It's initialized with a refcount which will keep it from ever getting
> freed.

That's my point.  You are getting "lucky" by creating a static kref.
Which is a totally pointless thing to do, right?

> > it's always around, so just remove
> > it entirely please.
> > 
> > Or, dynamically create it properly.  In other words, this is majorly
> > broken.
> 
> If we create it dynamically, then I don't think we can use it the way we
> do in kernel/utsname_sysctl.c for instance.

Why not?  It's just a pointer to the structure instead of the structure
itself, right?

thanks,

greg k-h
