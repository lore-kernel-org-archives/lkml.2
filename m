Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab1LOJBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 04:01:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47781 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab1LOJBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 04:01:53 -0500
Date: Thu, 15 Dec 2011 09:01:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] audit: fix mark refcounting
Message-ID: <20111215090151.GR2203@ZenIV.linux.org.uk>
References: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu>
 <87ipljcjc2.fsf@tucsk.pomaz.szeredi.hu>
 <CA+55aFxuGPj5rhFYt3O1yci_CqHe+Xs8U7WrWOih2W9U73N69w@mail.gmail.com>
 <20111215084050.GQ2203@ZenIV.linux.org.uk>
 <87fwgmjjr9.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fwgmjjr9.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 09:56:26AM +0100, Miklos Szeredi wrote:

> > Guys, does anybody have a real demonstration of the breakage cured by
> > pinning the mark down in audit_watch.c ->handle_event()?  Or is that
> > a pure theory?
> 
> Yes it does fix the BUG.  Test case in patch.
> 
> > Is ->handle_event() argument held by caller?
> 
> Well, obviously not, otherwise we wouldn't hit the bug.
> 
> >   Eric?  If that's the case,
> > we don't need to do anything with audit_watch.c instance; otherwise,
> > both that one and inotify_handle_event() are in trouble...
> 
> Yep.

I wonder if the right fix is to do it here and not in caller, though...
OTOH, usually we don't hit destroy at all, so it's probably better to
handle it in the individual instances...

OK, consider the audit_watch.c part ACKed; inotify counterpart needs a similar
patch, AFAICS.
