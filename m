Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab1IHXzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:55:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42693 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab1IHXzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:55:00 -0400
Date: Thu, 8 Sep 2011 20:50:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Leonardo Chiquitto <leonardo.lists@gmail.com>, autofs@linux.kernel.org
Subject: Re: [PATCH] vfs: automount should ignore LOOKUP_FOLLOW
Message-ID: <20110908195043.GV2203@ZenIV.linux.org.uk>
References: <87liu37z3x.fsf@tucsk.pomaz.szeredi.hu>
 <17416.1315240659@redhat.com>
 <87hb4q9b3r.fsf@tucsk.pomaz.szeredi.hu>
 <1315281208.3210.26.camel@perseus.themaw.net>
 <87mxeixfaq.fsf@tucsk.pomaz.szeredi.hu>
 <1315319903.3210.51.camel@perseus.themaw.net>
 <87ipp5y912.fsf@tucsk.pomaz.szeredi.hu>
 <1315485406.3476.9.camel@perseus.themaw.net>
 <87bouv17dc.fsf@tucsk.pomaz.szeredi.hu>
 <CA+55aFy3VN2Y-oadFUMdCaBVQtPT9Ae3fDQCw5vHfA6UvH8GiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy3VN2Y-oadFUMdCaBVQtPT9Ae3fDQCw5vHfA6UvH8GiA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 10:42:28AM -0700, Linus Torvalds wrote:

> > You say it's a step in the right direction but I don't see why. ?Either
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
> 
> I'm inclined to apply the patch as a regression fix, but I'll let this
> thread try to convince me for another day..

IIRC, that matches traditional SunOS behaviour and it actually does make
sense; you want wildcard expansion and ls -l to be doable even when there's
a stuck NFS server.  IOW, non-triggering lstat(2) is a matter of usability...
