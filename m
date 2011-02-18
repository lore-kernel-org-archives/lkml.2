Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1BRE2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 23:28:18 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:44408
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752218Ab1BRE2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 23:28:16 -0500
Date: Fri, 18 Feb 2011 04:28:15 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: userns: targeted capabilities v5
Message-ID: <20110218042815.GA9584@mail.hallyn.com>
References: <20110217150224.GA26334@mail.hallyn.com>
 <20110217162146.1b8e45e0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217162146.1b8e45e0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Thu, 17 Feb 2011 15:02:24 +0000
> "Serge E. Hallyn" <serge@hallyn.com> wrote:
> 
> > Here is a repost of my previous user namespace patch, ported onto
> > last night's git head.
> > 
> > It fixes several things I was doing wrong in the last (v4)
> > posting, in particular:
> > 
> > 	1. don't set uts_ns->user_ns to current's when !CLONE_NEWUTS
> > 	2. add a ipc_ns->user_ns which owns ipc_ns, and use that to
> > 	   decide CAP_IPC_OWNER
> > 	3. fix logic flaw caused by bad parantheses
> > 	4. allow do_prlimit to current
> > 	5. don't always give root full privs to init_user_ns
> > 
> > The expected course of development for user namespaces is laid out
> > at https://wiki.ubuntu.com/UserNamespace.
> 
> Seems like a nice feature to be developing.
> 
> I worry about the maturity of it all at this stage.  How far along is
> it *really*?
> 
> Is anyone else working with you on developing and reviewing this work?

Thanks, Andrew.  I'm not sure what definition of 'maturity' you were
looking for here.  If you meant completeness of the feature, it's
definately not there.  Of the goals for user namespaces sandboxing
will be the quickest to mature.  Completing that will largely be an
exercise of running the breadth of the kernel looking for simple
uid/gid comparisons and making them namespace aware.

The design has been meshed around (publicly) on and off for many
years by eric and I.  This particular patchset has gotten some great
reviews by Eric Biederman and Bastian Blank (to who, unfortunately,
to this day I cannot send a direct email - they're always bounced).

As Eric said, this feature will have to go in incrementally.
Furthermore, each piece touches scary code so it's likely to go
pretty slowly.  My hope is less than a year for sandboxing, and
two years for containers.  It might go way faster, but experience
tells me that's unlikely  :)

thanks,
-serge
