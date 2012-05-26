Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab2EZX7H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 19:59:07 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:60480 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2EZX7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 19:59:05 -0400
From: Serge Hallyn <serge@hallyn.com>
Reply-To: Serge Hallyn <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Colin Walters <walters@verbum.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [GIT PULL] user namespace enhancements for Linux 3.5-rc1
X-Mailer: Modest 3.2
References: <87hav8vypc.fsf@xmission.com> <1337894526.9093.7.camel@lenny>
	  <87k3zzt0ww.fsf@xmission.com>
In-Reply-To: <87k3zzt0ww.fsf@xmission.com>
Content-Type: text/plain; charset=utf-8
Content-ID: <1338076727.1716.1.camel@Nokia-N900-51-1>
Date: Sat, 26 May 2012 18:58:48 -0500
Message-Id: <1338076728.1716.2.camel@Nokia-N900-51-1>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original message -----
> Colin Walters <walters@verbum.org> writes:
> 
> > On Tue, 2012-05-22 at 12:48 -0600, Eric W. Biederman wrote:
> > 
> > > My git tree covers all of the modifications needed to convert the
> > > core kernel and enough changes to make a system bootable to runlevel
> > > 1.
> > 
> > What system?   I'm curious about the state of your userspace
> > modifications.
> 
> Debian.
> 
> Userspace won't need any modifications to work, but I am slowly working
> through the patches needed to get everything in the kernel converted.
> And my patches for the networking stack weren't quite ready for the
> merge window.
> 
> Ultimately to be included in distro kernels and really be useful I need
> to make everything in the kernel that plays with uids and gids user
> namespace aware so that is my goal for the next merge window.   We will
> see how that goes.
> 
> As for patches to userspace, all I think I will need is a small change
> to useradd, and perhaps a helper function to validate the mapping into
> the initial user namespace's uids. Aka is user A allowed to use uids
> 100,000-110,000?

To elaborate, remember uids in a user ns each map to a uid on the host (to be precise, in the initial userns).  Mapping to a uid on the host takes privilege.  So a setuid tool (i have a poc coded) checks a /etc file to see whether the host uids requested by an unprivileged user are allowed to him.  The useradd patch would be to fascilitate filling in ranges in that /etc file when the user is created.  So serge may get 100000-109999, joe 110000-119999, etc.

Nothing is needed in userspace just to boot a system with a user-ns-enabled kernel, or to have root use user namespaces (other than something to call clone with CLONE_NEWUSER).

> I have a branch in my user-namespace.git with all of the rest of my
> kernel changes if you want to play.   Beyond that I expect most of the
> user space changes (useradd etc) to land in ubuntu fairly shortly
> after they are viable as I am working closely with a couple folks
> at ubunut.
> 
> Eric
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at   http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at   http://www.tux.org/lkml/

