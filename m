Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0JTPQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:16:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46741 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab0JTPQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:16:31 -0400
Date: Wed, 20 Oct 2010 17:15:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Paris <eparis@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
Message-ID: <20101020151555.GC22271@elte.hu>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
 <AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com>
 <1287506215.2530.187.camel@localhost.localdomain>
 <20101019165530.GT19804@ZenIV.linux.org.uk>
 <AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com>
 <1287528546.2530.277.camel@localhost.localdomain>
 <20101020143845.GB22271@elte.hu>
 <1287585996.2530.294.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287585996.2530.294.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Paris <eparis@redhat.com> wrote:

> On Wed, 2010-10-20 at 16:38 +0200, Ingo Molnar wrote:
> > * Eric Paris <eparis@redhat.com> wrote:
> > 
> > > Executive summary of the day's work:
> > > Yesterday morning: 944 bytes per inode in core
> > > Yesterday night: 24 bytes per inode in core
> > > Tonight: 4 bytes per inode in core.
> > > 
> > > That's a x236 time reduction in memory usage.  No I didn't even start looking 
> > > at a freezer.  Which could bring that 4 down to 0, but would add a scalability 
> > > penalty on all inodes when IMA was enabled.
> > 
> > Why not use inode->i_security intelligently? That already exists so that way 
> > it's 0 bytes.
> > 
> > Thanks,
> 
> It still wouldn't be 0 bytes since there would be a 1-1 mapping from inode to 
> i_security structs. [...]

Only for IMA-affected files, right?

My point is to keep it 0 overhead for the _non IMA common case_.

> The real reason I don't pursue this route is because of the litany of different 
> ways this pointer is used in different LSMs (or not used at all.)  And we all know 
> that LSM authors aren't known for seeing the world the same way as each other.  As 
> a maintainer of one of those LSMs even I'm scared to try pushing that forward....

Ugh. That's a perfect reason to do it exactly like i suggested.

Thanks,

	Ingo
