Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2IHDI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 23:08:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48790 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2IHDI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 23:08:56 -0400
Date: Sat, 8 Sep 2012 05:08:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        eparis@redhat.com, linux-audit@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/10] vfs: getname/putname overhaul
Message-ID: <20120908030850.GH16230@one.firstfloor.org>
References: <1347025085-20285-1-git-send-email-jlayton@redhat.com> <m2r4qd4j8f.fsf@firstfloor.org> <20120907205418.244bd797@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907205418.244bd797@corrin.poochiereds.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 08:54:18PM -0400, Jeff Layton wrote:
> On Fri, 07 Sep 2012 14:26:56 -0700
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Jeff Layton <jlayton@redhat.com> writes:
> > 
> > > This patchset is a first pass at overhauling the getname/putname
> > > interface to use a struct. The idea here is to add a new getname_info
> > > struct that allow us to pass around some auxillary info along with
> > > the string that getname() returns.
> > 
> > Couldn't you just use some of the free pointers in struct page?
> > (lru etc.)
> > 
> > -Andi
> > 
> 
> We could do that if these were page allocations. They're not, however.
> __getname() does a PATH_MAX size allocation out of a slabcache. I get

Ok I suppose slab is faster. In this case it's better to track
separately I agree.

-Andi
