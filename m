Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab2DXPKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 11:10:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46377 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2DXPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 11:10:53 -0400
Date: Tue, 24 Apr 2012 10:10:40 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 30/43] userns: Fail exec for suid and sgid binaries with
 ids outside our user namespace.
Message-ID: <20120424151040.GA2979@ubuntu>
References: <m11unyn70b.fsf@fess.ebiederm.org>
 <1333862139-31737-30-git-send-email-ebiederm@xmission.com>
 <20120418190927.GK5186@mail.hallyn.com>
 <m1ehrdrhgr.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ehrdrhgr.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> > Quoting Eric W. Beiderman (ebiederm@xmission.com):
> >> From: Eric W. Biederman <ebiederm@xmission.com>
> >> 
> >
> > Oh, perhaps this is the right place in the thread to discuss the issue of
> > what to do with file capabilities?  I'm ok waiting until the next iteration
> > to even discuss it, so long as we start by refusing setting of fcaps by
> > any task not in init_user_ns.
> 
> For now we do refuse all callers in the init_user_ns because that path
> is protected by a capable and not an ns_capable call.
> 
> And as a general policy I have pushed all of the changes from capable to
> ns_capable out till after we get these other user namespace bits so we
> can get the patches reviewed so hopefully don't enable something that is
> not safe.
> 
> Let's just note here that when we ever get a filesystem mounted in
> something other than the init_user_ns or otherwise allow file
> capabilities that do not belong to the init_user_ns we need to an
> additional exec check to avoid a security issue for processes in the
> init_user_ns using those credentials.
> 
> The other direction the init_user_ns setting file caps on a file and use
> using them in a child namespace seems safe, and practical because of the
> way we handle capabilities.  Aka if you have a capability in an outer
> user namespace you also have it in a child user namespace.  Which means
> a file cap exec today will give you just the capabilities in the child
> user namespace.
> 
> Something else to think about when we reach filesystems mounted in
> different user namespaces (aka unprivileged mounts) are security
> labels on files in different user namespaces.  Not any kind of immediate
> concern but something we may have to handle eventually.

An interesting concern to discuss at the security mini-summit (or just
at the UDS session).

-serge
