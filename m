Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478Ab0FRO3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 10:29:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41553 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933443Ab0FRO3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 10:29:30 -0400
X-Authority-Analysis: v=1.1 cv=GMC9ctHN+mfn2UjahXKMz1Fs9q6RIMVHs8P/za7PD7k= c=1 sm=0 a=_xeo1-vZUxgA:10 a=hO-oPbc3tlwA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=PtDNVHqPAAAA:8 a=QEZcXR8dAAAA:8 a=07d9gI8wAAAA:8 a=VwQbUJbxAAAA:8 a=Kp59qSWk7wTLoRNwmH0A:9 a=8gl9viaUj1UGe8oFna8A:7 a=McHZEHsJFb39eJcAi8YZSzUtbKMA:4 a=CjuIK1q_8ugA:10 a=wYE_KDyynt4A:10 a=h4rWJa_47w3ngFjH:21 a=yAde6fAbfTK2IFOW:21 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Fri, 18 Jun 2010 09:29:46 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Theodore Tso <tytso@MIT.EDU>, Casey Schaufler <casey@schaufler-ca.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kees Cook <kees.cook@canonical.com>,
       Randy Dunlap <rdunlap@xenotime.net>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-doc@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       Daniel J Walsh <dwalsh@redhat.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
Message-ID: <20100618142946.GA6343@hallyn.com>
References: <alpine.LRH.2.00.1006172336390.17282@tundra.namei.org>
 <20100617170453.GV24749@outflux.net>
 <20100617215349.2fac02f5@lxorguk.ukuu.org.uk>
 <20100617140630.c6ced27a.rdunlap@xenotime.net>
 <20100617221815.68ce30c5@lxorguk.ukuu.org.uk>
 <20100617215105.GB24749@outflux.net>
 <20100617233054.330256cf@lxorguk.ukuu.org.uk>
 <4C1AE3A8.2020104@schaufler-ca.com>
 <E1FEE555-566E-4698-8FD8-240076A4F850@mit.edu>
 <m1wrtwwiua.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wrtwwiua.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Theodore Tso <tytso@MIT.EDU> writes:
> 
> > i think we really need to have stacked LSM's, because there is a large set
> > of people who will never use SELinux.  Every few years, I take another 
> > look at SELinux, my head explodes with the (IMHO unneeded complexity),
> > and I go away again...
> >
> > Yet I would really like a number of features such as this ptrace scope idea ---
> > which I think is a useful feature, and it may be that stacking is the only
> > way we can resolve this debate.   The SELinux people will never believe that
> > their system is too complicated, and I don't like using things that are impossible
> > for me to understand or configure, and that doesn't seem likely to change anytime
> > in the near future.
> >
> > I mean, even IPSEC RFC's are easier for me to understand, and that's saying
> > a lot...
> 
> 
> If anyone is going to work on this let me make a concrete suggestion.
> Let's aim at not stacked lsm's but chained lsm's, and put the chaining
> logic in the lsm core.
> 
> The core difficulty appears to be how do you multiplex the security pointers
> on various objects out there.

Here ya go, chaining for lsm security pointers:

http://lists.jammed.com/linux-security-module/2004/11/
http://lwn.net/Articles/114588/

:)

> My wishlist has this working so that I can logically have a local security
> policy in a container, restricted by the global policy but with additional
> restrictions.

At the upcoming linux security summit[1], colocated with linuxcon, Kees is going
to be doing a talk 'widely used but out of tree', where presumably the topic
of stacking LSMs will come back up.

If we were going to seriously consider stacking LSMs again, I'd want to
dig through archives to produce a precise list of previous issues, so we
can build on that to try and design something which might work.  So
I guess I'm suggesting a beer BOF for the evening or next day for
discussing design in more detail.

The general answer tends to be "generic stacking doesn't work, LSMs
need to know about each other."  But even for that (as evidenced by
the selinux+commoncap experience with stacking) is hairy, and more
to the point it probably does not scale when we have 5-10 small
LSMs.  I.e. LSM 1 wants to prevent some action while LSM 2 requires
that action to succeed so that it can properly prevent another
action.  Concrete examples are buried in the stacker discussions
on the lsm list from 2004-2005.

Mind you, I'm not interested in doing a stacking patchset myself again,
would prefer to spend my time on user namespaces.  I'm not even sure
which side of the stacking-vs-nostacking fence I'll be on, except that I
always prefer to discuss based on experience with real code than
pie-in-the-skie arguments, so would encourage patches.  I do suspect
once we better understand user namespaces we may have want for fewer
little LSMs.  So someone else can have all the fun to themselves  :)

-serge

[1] https://security.wiki.kernel.org/index.php/LinuxSecuritySummit2010
