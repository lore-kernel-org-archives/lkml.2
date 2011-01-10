Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab1AJW45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:56:57 -0500
Received: from adelie.canonical.com ([91.189.90.139]:48748 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab1AJW4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:56:54 -0500
Date: Mon, 10 Jan 2011 16:56:42 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Bastian Blank <bastian@waldi.eu.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <kees.cook@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 6/7] user namespaces: convert all capable checks in
 kernel/sys.c
Message-ID: <20110110225642.GB18944@localhost>
References: <20110110211135.GA22446@mail.hallyn.com>
 <20110110211406.GF22564@mail.hallyn.com>
 <20110110215937.GB21351@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110215937.GB21351@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bastian Blank (bastian@waldi.eu.org):
> On Mon, Jan 10, 2011 at 09:14:07PM +0000, Serge E. Hallyn wrote:
> > -	if (pcred->uid  != cred->euid &&
> > -	    pcred->euid != cred->euid && !capable(CAP_SYS_NICE)) {
> > +	if (pcred->user->user_ns != cred->user->user_ns &&
> > +	    pcred->uid  != cred->euid &&
> > +	    pcred->euid != cred->euid &&
> > +	    !ns_capable(pcred->user->user_ns, CAP_SYS_NICE)) {
> 
> I don't think this is correct. This would not error out if the both
> userns are the same. Because the same patern (check uid if same userns,
> otherwise only capability) shows up in several parts of the code, maybe
> this should be factored out.

Yes, I'm really not sure what I was thinking here.  Thanks!

> > @@ -496,7 +498,7 @@ SYSCALL_DEFINE2(setregid, gid_t, rgid, gid_t, egid)
> >  	if (rgid != (gid_t) -1) {
> >  		if (old->gid == rgid ||
> >  		    old->egid == rgid ||
> > -		    capable(CAP_SETGID))
> > +		    ns_capable(current_user_ns(), CAP_SETGID))
> 
> Would it not possible to add another function (nsown_capable?) that
> checks against the own userns?

Good idea, I'll add that one.

thanks,
-serge
