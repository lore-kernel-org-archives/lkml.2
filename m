Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab0F2UOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 16:14:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958Ab0F2UOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 16:14:16 -0400
Date: Wed, 30 Jun 2010 06:14:09 +1000
From: Nick Piggin <npiggin@suse.de>
To: Chris Clayton <chris2553@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch 02/52] fs: fix superblock iteration race
Message-ID: <20100629201409.GO28364@laptop>
References: <20100624030212.676457061@suse.de>
 <AANLkTinr_Ljn48o3YecbuYt15xbP02sbg9D6qqobt1wE@mail.gmail.com>
 <AANLkTilWhDhzdANZeskV__btrvZuAr-Fhmj7j5iKec-U@mail.gmail.com>
 <201006292104.33778.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006292104.33778.chris2553@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 09:04:33PM +0100, Chris Clayton wrote:
> On Tuesday 29 June 2010, Linus Torvalds wrote:
> > On Tue, Jun 29, 2010 at 10:52 AM, Linus Torvalds
> >
> > <torvalds@linux-foundation.org> wrote:
> > > Look for "2.6.35-rc3 oops trying to suspend" on lkml, for example. No
> > > guarantee that it's the same thing, but it's "iterate_supers()"
> > > getting an oops [..]
> >
> > Also, "Oops during closedown with 2.6.35-rc3-git3" is an
> > iterate_supers oops (in the jpg) and Chris says it's repeatable for
> > him.
> >
> > Chris - you could try testing current -git now that I've merged Nick's
> > patch. It's commit 57439f878af ("fs: fix superblock iteration race"),
> > and I just pushed it out (so it might take a few minutes to mirror out
> > to the public git trees, but it should be there shortly).
> >
> 
> Well, it was repeatable this morning, but despite 30+ shutdowns this evening, I 
> haven't had a single oops. Perhaps I'm just not doing enough computing stuff 
> between startup and shutdown to create the conditions under which I got the 
> oopses this morning. Moreover, I've been using this kernel every day with, 
> maybe two or three shutdowns a day, for two weeks or so now (since just after 
> Linus went on vacation) with no oopses. (The kernel is -rc3 + John 
> Fastabend's "net: fix deliver_no_wcard regression on loopback device" patch).
> 
> I'll spend a couple of hours doing stuff and see if I can generate an oops. 
> Trouble is, of course, that when I pull and build the latest and greatest, I 
> won't know why I'm not getting oopses, assuming I don't.

Don't worry too much if you can't reproduce. I'd say it is likely to be
this bug, and if so, it is going to depend significantly on timing and
ordering of mounts/umounts.

