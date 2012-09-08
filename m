Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788Ab2IHAyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 20:54:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758638Ab2IHAye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 20:54:34 -0400
Date: Fri, 7 Sep 2012 20:54:18 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, linux-audit@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/10] vfs: getname/putname overhaul
Message-ID: <20120907205418.244bd797@corrin.poochiereds.net>
In-Reply-To: <m2r4qd4j8f.fsf@firstfloor.org>
References: <1347025085-20285-1-git-send-email-jlayton@redhat.com>
	<m2r4qd4j8f.fsf@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Sep 2012 14:26:56 -0700
Andi Kleen <andi@firstfloor.org> wrote:

> Jeff Layton <jlayton@redhat.com> writes:
> 
> > This patchset is a first pass at overhauling the getname/putname
> > interface to use a struct. The idea here is to add a new getname_info
> > struct that allow us to pass around some auxillary info along with
> > the string that getname() returns.
> 
> Couldn't you just use some of the free pointers in struct page?
> (lru etc.)
> 
> -Andi
> 

We could do that if these were page allocations. They're not, however.
__getname() does a PATH_MAX size allocation out of a slabcache. I get
the impression that at one point, this was done with page allocations.
I assume that this was changed over to a slabcache since not all arches
have a 4k PAGE_SIZE.

That's not a bad idea though. We could switch __getname over to doing a
page allocation instead, but it would mean quite a bit of wasted space
on arches with >4k pages. That said, these allocations are generally
quite short-lived so maybe that's not such a big deal.
-- 
Jeff Layton <jlayton@redhat.com>
