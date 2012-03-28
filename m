Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab2C1Gso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 02:48:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54065 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2C1Gsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:48:43 -0400
Date: Wed, 28 Mar 2012 10:48:38 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [rfc] fcntl: Add F_GETOWNER_UIDS option
Message-ID: <20120328064838.GA2286@moon>
References: <20120326150924.GG19395@moon>
 <20120326164347.GA24394@redhat.com>
 <20120326183330.GM19395@moon>
 <20120327152534.GA18478@redhat.com>
 <20120327165853.GH11875@moon>
 <20120327222923.GA31692@mail.hallyn.com>
 <20120327223420.GB9669@moon>
 <20120327224640.GA5328@mail.hallyn.com>
 <m162dpo45j.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m162dpo45j.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 07:22:48PM -0700, Eric W. Biederman wrote:
> >> Hi Serge, thanks for info. But if it will be unconverted uid, can't
> >> be there some security problem with that which I missed?
> 
> I would suggest the easy route and create a KCONFIG dependency
> on !CONFIG_USER_NS until the code for that is a little farther along.
> 
> Hopefully later this week or begginning of next week I should be posting
> my patches and seeing how well the rest of the world takes them.
> 

CC me on them, please.

> > Noone is really using the user namespaces right now, but rather than
> > adding the cred (and refcounting concerns), my suggestion for now
> > would be to hardcode a check in modown() that current_user_ns() ==
> > &init_user_ns.

OK, thanks

> >
> > I *did* have a patch in the past which added the cred to fown, but
> > no idea where it is right now...
> 
> So I guess there are two questions.
> - Does it make sense besides translation to add a cred here in general?
> 

I personally fail to find a reason except uids translation.

> - How will it work with the user_namespace?
> 
>   I am just about ready to post a patchset that at the edges of
>   userspace maps all uid and gids into uid and gids in the initial user
>   namespace.

So, we could map tme into initial user namesapce right? And we could
require for a while that F_GETOWNER_UIDS should be called from initial
user namespace only. Then we could extend it for being called from any
user-namespace if such need appear. Or I miss something?

	Cyrill
