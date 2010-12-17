Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0LQQMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 11:12:13 -0500
Received: from adelie.canonical.com ([91.189.90.139]:44872 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab0LQQMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 11:12:10 -0500
Date: Fri, 17 Dec 2010 10:12:00 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
Subject: Re: [RFC 1/5] user namespaces: Add a user_namespace as
 creator/owner of uts_namespace
Message-ID: <20101217161200.GA5548@peq>
References: <20101217152246.GA8221@mail.hallyn.com>
 <20101217152458.GA11162@mail.hallyn.com>
 <AANLkTinPBAPjeEdhn21JN6zVpAKDHR9=3gszj84CyyNx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinPBAPjeEdhn21JN6zVpAKDHR9=3gszj84CyyNx@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> On Fri, Dec 17, 2010 at 5:24 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > +/*
> > + * userns count is 1 for root user, 1 for init_uts_ns,
> > + * and 1 for... ?
> > + */
> >  struct user_namespace init_user_ns = {
> >        .kref = {
> > -               .refcount       = ATOMIC_INIT(2),
> > +               .refcount       = ATOMIC_INIT(3),
> 
> +1 is for init_nsproxy ;-)

Hmm, actually user_namespace isn't in struct nsproxy any more,
since 18b6e0414e42d95183f07d8177e3ff0241abd825.

I think my original thought was that init_user_ns is pinned twice by
root_user - once as creator and once as the root user in it.  In
which case it isn't right - the user_ns pins the task which created
it, the creator does not pin the user_ns it creates.

-serge
