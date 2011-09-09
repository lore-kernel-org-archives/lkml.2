Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1IIDdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 23:33:37 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:44939 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754016Ab1IIDdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 23:33:35 -0400
X-Sasl-enc: b8Qq82N/vS8J4ybZ3jWbjFWpjet4zwbAZnNEItSvLxCE 1315539213
Subject: Re: [PATCH] vfs: automount should ignore LOOKUP_FOLLOW
From: Ian Kent <raven@themaw.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leonardo Chiquitto <leonardo.lists@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, autofs@linux.kernel.org
In-Reply-To: <CA+55aFy3VN2Y-oadFUMdCaBVQtPT9Ae3fDQCw5vHfA6UvH8GiA@mail.gmail.com>
References: <87liu37z3x.fsf@tucsk.pomaz.szeredi.hu>
	 <17416.1315240659@redhat.com> <87hb4q9b3r.fsf@tucsk.pomaz.szeredi.hu>
	 <1315281208.3210.26.camel@perseus.themaw.net>
	 <87mxeixfaq.fsf@tucsk.pomaz.szeredi.hu>
	 <1315319903.3210.51.camel@perseus.themaw.net>
	 <87ipp5y912.fsf@tucsk.pomaz.szeredi.hu>
	 <1315485406.3476.9.camel@perseus.themaw.net>
	 <87bouv17dc.fsf@tucsk.pomaz.szeredi.hu>
	 <CA+55aFy3VN2Y-oadFUMdCaBVQtPT9Ae3fDQCw5vHfA6UvH8GiA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Sep 2011 11:33:27 +0800
Message-ID: <1315539207.3952.41.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-08 at 10:42 -0700, Linus Torvalds wrote:
> On Thu, Sep 8, 2011 at 6:38 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > Yes, 2.6.38 and later kernels do trigger on stat(2) but not on lstat(2).
> >
> > My question is this:  does this behavior improve anything compared to
> > kernels before 2.6.38?  Because I don't see that it does, in fact it's
> > just causing regressions.
> >
> > You say it's a step in the right direction but I don't see why.  Either
> > we want stat *and* lstat to both be correct and trigger the automount or
> > we are satisfied with the incorrect but well established practice of not
> > triggering on (l)stat.
> >
> > The middle ground makes no sense IMO, there's nothing gained by the
> > differentiated behavior based on LOOKUP_FOLLOW.
> >
> > Can you explain why it's better if stat() tiggers automounts and gives a
> > correct result but lstat() doesn't?
> 
> I have to say that this is a very cogent question.
> 
> The one thing I've not seen in the thread yet is a description of the
> failure. What does the regression look like? Just "very slow 'ls' with
> some versions of 'ls'" or what?

The problem that is seen is everything in a directory being mounted upon
listing the directory. This isn't really a problem for small automount
maps but maps with more than a few dozen entries start becoming
problematic and a few hundred entries or more (quite common in many
environments) is an obvious nightmare.

Clearly this is a problem that I have introduced by the idea of the
"browse" option of autofs, whereby the potential automount points of an
indirect automount are visible within the automount managed directory
but it also applies to NFS crossing mount points (since those mount
point directories must also pre-exist).

Note that this isn't as problem if the "browse" option isn't used since
we just se an empty directory and specific access to a path causes only
those mounts to occur. But Solaris has been able to do this for years
now so it is expected by the user community.

> 
> I'm inclined to apply the patch as a regression fix, but I'll let this
> thread try to convince me for another day..

I have to agree, although it would be good to get some input from other
subsystem maintainers.

Ian


