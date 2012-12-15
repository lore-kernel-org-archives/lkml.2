Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab2LOAJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 19:09:39 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:60930 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905Ab2LOAJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 19:09:38 -0500
Date: Sat, 15 Dec 2012 00:14:47 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC][PATCH] Fix cap_capable to only allow owners in the
 parent user namespace to have caps.
Message-ID: <20121215001447.GD13659@mail.hallyn.com>
References: <87mwxhtxve.fsf@xmission.com>
 <87zk1hshk7.fsf_-_@xmission.com>
 <20121214032820.GA5115@mail.hallyn.com>
 <87bodxi9zw.fsf@xmission.com>
 <20121214152607.GA9266@mail.hallyn.com>
 <87bodwd4aw.fsf@xmission.com>
 <20121214161514.GA9962@mail.hallyn.com>
 <87r4ms5wpm.fsf@xmission.com>
 <20121214202921.GA11450@mail.hallyn.com>
 <87bodww9hv.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bodww9hv.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> > Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> >> A child user namespace having capabilities against processes in it's
> >> parent seems totally bizarre and pretty dangerous from a capabilities
> >> standpoint.
> >
> > How would it have them against its parent?
> 
> init_user_ns
>    userns a --- created by kuid 1

Now a mapping needs to be set up (by a task with CAP_SYS_ADMIN in
init_user_ns) which allows kuids 1 and 2 to be used by userns a.
Otherwise (if no mapping is set up) userns a only has the overlowuid.

Realistically only kuids over 100000 (let's say) would used.  i.e.
kuids 100,000-199,999 would map to container uids 0-99,999.

>      userns b -- created by kuid 2

Now a mapping needs to be set up (by a task with CAP_SYS_ADMIN in
userns a) which allows kuids 1 and 2 to be used by userns b.

If userns had been mapped with kuids 100,000-199,999 mapping to
uids 0-99999, then only kuids in that range could be mapped into
userns b.

>         process c in userns b with kuid 1
>
> Serge read the first permisison check in common_cap. 
> Think what happens in the above example.
> 
> For the rest I understand your concern.

Ok.  Then we can discuss my concern later (after the new year).

> Serge please read and look at the patches I have posted to fix
> the issues Andy found with the user namespace tree.  Especially
> the fix to commit_creds.

The setns fixes were IMO the most important - and interesting - ones :)

Thanks, Andy!

> After you have looked at the patches to fix the issues I will
> be happy to discuss things further with you.

Thanks,
-serge
