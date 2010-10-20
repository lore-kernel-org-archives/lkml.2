Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab0JTP0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:26:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab0JTP0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:26:02 -0400
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
From: Eric Paris <eparis@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org
In-Reply-To: <20101020151555.GC22271@elte.hu>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
	 <AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com>
	 <1287506215.2530.187.camel@localhost.localdomain>
	 <20101019165530.GT19804@ZenIV.linux.org.uk>
	 <AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com>
	 <1287528546.2530.277.camel@localhost.localdomain>
	 <20101020143845.GB22271@elte.hu>
	 <1287585996.2530.294.camel@localhost.localdomain>
	 <20101020151555.GC22271@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 11:25:35 -0400
Message-ID: <1287588335.2530.296.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 17:15 +0200, Ingo Molnar wrote:
> * Eric Paris <eparis@redhat.com> wrote:
> 
> > On Wed, 2010-10-20 at 16:38 +0200, Ingo Molnar wrote:
> > > * Eric Paris <eparis@redhat.com> wrote:
> > > 
> > > > Executive summary of the day's work:
> > > > Yesterday morning: 944 bytes per inode in core
> > > > Yesterday night: 24 bytes per inode in core
> > > > Tonight: 4 bytes per inode in core.
> > > > 
> > > > That's a x236 time reduction in memory usage.  No I didn't even start looking 
> > > > at a freezer.  Which could bring that 4 down to 0, but would add a scalability 
> > > > penalty on all inodes when IMA was enabled.
> > > 
> > > Why not use inode->i_security intelligently? That already exists so that way 
> > > it's 0 bytes.
> > > 
> > > Thanks,
> > 
> > It still wouldn't be 0 bytes since there would be a 1-1 mapping from inode to 
> > i_security structs. [...]
> 
> Only for IMA-affected files, right?

No, we need to keep the open read counter even for non-IMA-affected
files in case we later determine that it is IMA-affected.  That's the 4
bytes I have today, which I said could be eliminated with a freezer that
calculated it when IMA was enabled, but isn't something I'm looking at
right now....

-Eric

-Eric

