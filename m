Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab0J3GV4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 02:21:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55246 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab0J3GVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 02:21:54 -0400
Date: Sat, 30 Oct 2010 07:21:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: audit_tree: sleep inside atomic
Message-ID: <20101030062147.GA16697@ZenIV.linux.org.uk>
References: <4C1F8217.5020909@gmail.com>
 <4C80FD9E.5040408@gmail.com>
 <20100913170522.f0b8b1e8.akpm@linux-foundation.org>
 <1284581305.2703.127.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284581305.2703.127.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 04:08:25PM -0400, Eric Paris wrote:
> On Mon, 2010-09-13 at 17:05 -0700, Andrew Morton wrote:
> > On Fri, 03 Sep 2010 15:52:30 +0200
> > Jiri Slaby <jirislaby@gmail.com> wrote:
> > 
> > > Ideas, comments?
> > 
> > Apparently not.
> 
> Sorry, I've been slacking off on vacation the last couple weeks.
> 
> > The question is: why is nobody reporting this bug?  Obviously nobody's
> > running that code path.  Why not?
> 
> The only people who run this code path, that I know of, are govt orgs
> who run in certified environments.  I don't know of any upstream kernel
> users who really would hit it.
> 
> In any case I don't think it would be particularly painful to just
> always allocate a chunk between the two locks.  this is not a hot path
> by any stretch of the imagination.  I'll see if I can't code something
> up today/tomorrow.

It's not even a matter of path being hot; we should do allocation before
grabbing entry->lock if size is non-zero.  End of the story.

Fixed in audit branch I'll push today.
