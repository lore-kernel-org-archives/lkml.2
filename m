Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab0LQTrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:47:00 -0500
Received: from adelie.canonical.com ([91.189.90.139]:37848 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab0LQTq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:46:58 -0500
Date: Fri, 17 Dec 2010 13:46:45 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Greg KH <greg@kroah.com>
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
Message-ID: <20101217194645.GA3131@peq>
References: <20101217152246.GA8221@mail.hallyn.com>
 <20101217152458.GA11162@mail.hallyn.com>
 <20101217173125.GA29982@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101217173125.GA29982@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg KH (greg@kroah.com):
> > +extern struct user_namespace init_user_ns;
> >  struct uts_namespace init_uts_ns = {
> >  	.kref = {
> >  		.refcount	= ATOMIC_INIT(2),
> 
> Wait, WTF?
> 
> You have a static kref and you try to automatically instanciate it here?

You're complaining about the pre-existing init_uts_ns right?

> As it's static, why are you even having a kref at all, what good does it
> do you, you can't delete the thing,

Can't delete this one, but can delete all the uts namespaces, obviously.
As with init_tgcred in kernel/cred.c.

It's initialized with a refcount which will keep it from ever getting
freed.

> it's always around, so just remove
> it entirely please.
> 
> Or, dynamically create it properly.  In other words, this is majorly
> broken.

If we create it dynamically, then I don't think we can use it the way we
do in kernel/utsname_sysctl.c for instance.

thanks,
-serge
