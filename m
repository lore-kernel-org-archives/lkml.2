Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab0JSR2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:28:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44466 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab0JSR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:28:19 -0400
Date: Tue, 19 Oct 2010 18:28:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
Message-ID: <20101019172805.GU19804@ZenIV.linux.org.uk>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
 <AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com>
 <1287506215.2530.187.camel@localhost.localdomain>
 <20101019165530.GT19804@ZenIV.linux.org.uk>
 <AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 10:03:48AM -0700, Linus Torvalds wrote:
> On Tue, Oct 19, 2010 at 9:55 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > a) i_writecount is about VM_DENYWRITE, basically. ?Reusing it for ima could
> > get unpleasant; when it's positive, we are fine, but it can get negative as
> > well. ?IMA will have interesting time dealing with that.
> >
> > b) i_count is simply a refcount for struct inode. ?Not exactly the number
> > of dentries, but that's the main contributor. ?Basically, that's "how many
> > pointers outside of inode hash chains point that that struct inode at the
> > moment".
> 
> My question was deeper. More along the lines of "why would IMA care?"
> 
> How/why could IMA ever care about the pointless and trivial
> differences between its current private open/read/write counts and the
> counts that we already maintain?
> 
> Yes, yes, I realize that they have technical differences in what they
> count. That's not the question. The question is "Why would IMA care?"

I'd rather not say what I think about IMA sanity (and usefulness); as for what
it tries to do...  They want to whine if you open a file that is already opened
for write and they want to whine if you open a file for write when it's already
opened for read.  Unless they decide to leave the file alone, that is.
