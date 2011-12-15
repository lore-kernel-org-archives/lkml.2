Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695Ab1LOWzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:55:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36332 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759654Ab1LOWzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:55:21 -0500
Date: Thu, 15 Dec 2011 22:55:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] audit: fix mark refcounting
Message-ID: <20111215225517.GT2203@ZenIV.linux.org.uk>
References: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu>
 <87ipljcjc2.fsf@tucsk.pomaz.szeredi.hu>
 <CA+55aFxuGPj5rhFYt3O1yci_CqHe+Xs8U7WrWOih2W9U73N69w@mail.gmail.com>
 <20111215084050.GQ2203@ZenIV.linux.org.uk>
 <87fwgmjjr9.fsf@tucsk.pomaz.szeredi.hu>
 <87aa6ujjf6.fsf@tucsk.pomaz.szeredi.hu>
 <20111215200631.GA2379@Neptun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215200631.GA2379@Neptun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 09:06:31PM +0100, Lino Sanfilippo wrote:
> On Thu, Dec 15, 2011 at 10:03:41AM +0100, Miklos Szeredi wrote:
> >  
> > +	audit_get_parent(parent);
> >  	fsnotify_destroy_mark(&parent->mark);
> > +	audit_put_parent(parent);
> 
> Hi,
> 
> What about taking an extra ref on an inode mark in send_to_group()
> before we call handle_event()?
> So we dont have to handle the cases in which a mark is destroyed
> explicitly...

The thing is, on most of the method calls we won't need that at all.
And it costs quite a bit, so I'm afraid that this variant is the
way to go.  Yes, it would be nicer to do that in caller, but...

Dunno...  Neither instance actually touches the mark after that
destroy_mark and we have very few of those guys (fortunately).  So
removing this BUG_ON() instead might be the right thing to do.
