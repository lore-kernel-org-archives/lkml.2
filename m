Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab1IOPQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:16:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403Ab1IOPQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:16:10 -0400
Date: Thu, 15 Sep 2011 11:15:56 -0400
From: Jason Baron <jbaron@redhat.com>
To: Andrew Morton <akpm@google.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Nelson Elhage <nelhage@nelhage.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
        stable@kernel.org
Subject: Re: [PATCH] epoll: Fix spurious lockdep warnings
Message-ID: <20110915151555.GB3085@redhat.com>
References: <1312913515-432-1-git-send-email-nelhage@nelhage.com>
 <20110908000429.GK10700@zod.bos.redhat.com>
 <20110913202248.GA6580@redhat.com>
 <20110913141603.25614d00.akpm@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110913141603.25614d00.akpm@google.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 02:16:03PM -0700, Andrew Morton wrote:
> On Tue, 13 Sep 2011 16:22:48 -0400
> Jason Baron <jbaron@redhat.com> wrote:
> 
> > On Wed, Sep 07, 2011 at 08:04:29PM -0400, Josh Boyer wrote:
> > > On Tue, Aug 09, 2011 at 02:11:55PM -0400, Nelson Elhage wrote:
> > > > epoll can acquire recursively acquire ep->mtx on multiple "struct
> > > > eventpoll"s at once in the case where one epoll fd is monitoring
> > > > another epoll fd. This is perfectly OK, since we're careful about the
> > > > lock ordering, but it causes spurious lockdep warnings. Annotate the
> > > > recursion using mutex_lock_nested, and add a comment explaining the
> > > > nesting rules for good measure.
> > > > 
> > > > Recent versions of systemd are triggering this, and it can also be
> > > > demonstrated with the following trivial test program:
> > > > 
> > > > --------------------8<--------------------
> > > > 
> > > > int main(void) {
> > > >    int e1, e2;
> > > >    struct epoll_event evt = {
> > > >        .events = EPOLLIN
> > > >    };
> > > > 
> > > >    e1 = epoll_create1(0);
> > > >    e2 = epoll_create1(0);
> > > >    epoll_ctl(e1, EPOLL_CTL_ADD, e2, &evt);
> > > >    return 0;
> > > > }
> > > > --------------------8<--------------------
> > > > 
> > > > Cc: stable@kernel.org
> > > > Reported-by: Paul Bolle <pebolle@tiscali.nl>
> > > > Tested-by: Paul Bolle <pebolle@tiscali.nl>
> > > > Signed-off-by: Nelson Elhage <nelhage@nelhage.com>
> > > 
> > > Any progress on this heading upstream?
> > > 
> > 
> > Patch looks good to me, feel free to add:
> > 
> > Acked-by: Jason Baron <jbaron@redhat.com>
> > 
> > However, I am going to have to re-base the epoll path I recently posted:
> > https://lkml.org/lkml/2011/9/2/295, if this goes in first. Perhaps,
> > Andrew (added to the 'cc), can help us sort out the ordering...
> 
> I have already fixed up epoll-limit-paths.patch.  You're planning on
> sending a new version of that patch.  Please do base that on
> epoll-fix-spurious-lockdep-warnings.patch.

Ok, where can I get at these patches? With:
http://userweb.kernel.org/~akpm/mmotm/, still down.

Thanks,

-Jason
