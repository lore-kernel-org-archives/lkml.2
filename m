Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab0LRRz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 12:55:57 -0500
Received: from kroah.org ([198.145.64.141]:33391 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069Ab0LRRzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 12:55:55 -0500
Date: Sat, 18 Dec 2010 09:56:51 -0800
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
Subject: Re: [RFC 1/5] user namespaces: Add a user_namespace as
 creator/owner of uts_namespace
Message-ID: <20101218175651.GA7453@kroah.com>
References: <20101217152246.GA8221@mail.hallyn.com>
 <20101217152458.GA11162@mail.hallyn.com>
 <20101217173125.GA29982@kroah.com>
 <m18vzoryit.fsf@fess.ebiederm.org>
 <20101217195829.GB1410@kroah.com>
 <m1ipysm8us.fsf@fess.ebiederm.org>
 <20101217231527.GA21227@kroah.com>
 <m1vd2rlhez.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vd2rlhez.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 10:32:52PM -0800, Eric W. Biederman wrote:
> Greg KH <greg@kroah.com> writes:
> 
> > On Fri, Dec 17, 2010 at 12:40:11PM -0800, Eric W. Biederman wrote:
> >> Greg KH <greg@kroah.com> writes:
> >> 
> >> >> There are also major benefits to have the version of something that is
> >> >> never freed never going away, because it means you can just reference it
> >> >> in code.  So while I would be happy to say this is special don't use a
> >> >> kref and roll the reference counting logic by hand, we aren't
> >> >> dynamically allocating init_uts_ns any time soon.
> >> >
> >> > Why have a reference count at all if it's not needed or used here?
> >> 
> >> We have to reference count every other uts namespace.
> >
> > Ok, that makes sense, then also please dynamically create this one, do
> > not create a static kref.
> 
> Nope.  It's a bad idea.  It messes up the kernel bootstrap if you do
> that, and it makes this one structure different from every other
> structure init_task uses.

{sigh}

Ok, but I really don't like this use.

Also, don't go messing with that ATOMIC_INIT() to be a higher value, as
this patch series did, as that really implies that it is being used
incorrectly, right?

thanks,

greg k-h
