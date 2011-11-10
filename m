Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679Ab1KJO1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:27:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45157 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab1KJO1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:27:36 -0500
Date: Thu, 10 Nov 2011 08:27:24 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, richard@nod.at,
        containers@lists.linux-foundation.org, oleg@redhat.com,
        eparis@redhat.com, linux-kernel@vger.kernel.org, dhowells@redhat.com,
        ebiederm@xmission.com
Subject: Re: [PATCH 1/6] user namespace: make signal.c respect user
 namespaces (v4)
Message-ID: <20111110142723.GA7727@sergelap>
References: <1320445482-8459-1-git-send-email-serge@hallyn.com>
 <1320445482-8459-2-git-send-email-serge@hallyn.com>
 <20111108162216.1ffb3e9a.akpm@linux-foundation.org>
 <20111109141853.GB4010@sergelap>
 <20111110014114.GB26567@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110014114.GB26567@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Matt Helsley (matthltc@us.ibm.com):
> On Wed, Nov 09, 2011 at 08:18:53AM -0600, Serge E. Hallyn wrote:
> > Quoting Andrew Morton (akpm@linux-foundation.org):
> > > On Fri,  4 Nov 2011 22:24:37 +0000
> > > Serge Hallyn <serge@hallyn.com> wrote:
> > > 
> > > > +static inline void fixup_uid(struct siginfo *info, struct task_struct *t)
> 
> nit: Seems like the function name itself needs a fixup. I can imagine a
> user-ns-unaware kernel developer thinking this when they see code calling
> this function:
> 
> <naive>
> Gosh, why is the uid broken? I have no idea what this does or when it
> would be needed. Why hasn't it been splatted all over the kernel? Who broke
> it?
> </naive>
> 
> You can't even tell from the name that it's for user namespaces.

Heh, my first reaction was that you're over-reacting, but you're probably
right.  I don't want to conflict with the 'user_ns_map_uids' function,
so how about userns_fixup_signal_uids()?  Pls let me know if you have a
better name, otherwise I'll switch to this one.

thanks,
-serge
