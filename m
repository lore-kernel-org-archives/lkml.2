Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2IHLYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:24:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab2IHLYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:24:44 -0400
Date: Sat, 8 Sep 2012 07:24:26 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, linux-audit@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/10] vfs: getname/putname overhaul
Message-ID: <20120908072426.2880971f@corrin.poochiereds.net>
In-Reply-To: <20120908030850.GH16230@one.firstfloor.org>
References: <1347025085-20285-1-git-send-email-jlayton@redhat.com>
	<m2r4qd4j8f.fsf@firstfloor.org>
	<20120907205418.244bd797@corrin.poochiereds.net>
	<20120908030850.GH16230@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Sep 2012 05:08:50 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> On Fri, Sep 07, 2012 at 08:54:18PM -0400, Jeff Layton wrote:
> > On Fri, 07 Sep 2012 14:26:56 -0700
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > Jeff Layton <jlayton@redhat.com> writes:
> > > 
> > > > This patchset is a first pass at overhauling the getname/putname
> > > > interface to use a struct. The idea here is to add a new getname_info
> > > > struct that allow us to pass around some auxillary info along with
> > > > the string that getname() returns.
> > > 
> > > Couldn't you just use some of the free pointers in struct page?
> > > (lru etc.)
> > > 
> > > -Andi
> > > 
> > 
> > We could do that if these were page allocations. They're not, however.
> > __getname() does a PATH_MAX size allocation out of a slabcache. I get
> 
> Ok I suppose slab is faster. In this case it's better to track
> separately I agree.
> 

Ummm...stupid question...

I could see that allocating out of the slab would mean less waste when
you have >4k pages, but why would it be faster than just allocating a
page directly?

Also, by "track separately" do you mean that you think I should drop
patch 9 in this series and just do two allocations for a getname in all
cases?

-- 
Jeff Layton <jlayton@redhat.com>
