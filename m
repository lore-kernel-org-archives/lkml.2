Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab2JBWHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:07:53 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43328 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab2JBWHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:07:51 -0400
Date: Tue, 2 Oct 2012 15:07:47 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk,
        "Martin K. Petersen" <martin.petersen@oracle.com>, tj@kernel.org
Subject: Re: [dm-devel] [PATCH v3 01/26] block: Fix a buffer overrun in
 bio_integrity_split()
Message-ID: <20121002220744.GW26488@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-2-git-send-email-koverstreet@google.com>
 <20121001212336.GA17165@redhat.com>
 <20121001214241.GE26488@google.com>
 <20121002140847.GD758@redhat.com>
 <20121002202643.GQ26488@google.com>
 <20121002203253.GA14471@redhat.com>
 <20121002210143.GT26488@google.com>
 <20121002215845.GB14471@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002215845.GB14471@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 05:58:45PM -0400, Vivek Goyal wrote:
> On Tue, Oct 02, 2012 at 02:01:43PM -0700, Kent Overstreet wrote:
> > I'm honestly not sure what your complaint about my bugfix patch was -
> > it's small and complete, it does fix the bug. I don't follow why you
> > think we need to introduce the bip->bio_vec pointer early...
> 
> I think having iv1 and iv2 and then not even accessing these using 
> bp->iv1 and bp->iv2 is a bad idea even for bugfix.
> 
> I have never seen a code which says, hey I have defined two fields in a
> struct but, don't access those fields directly(as there might be padding
> issues). These fields are just there for blocking a chunk of memory but are
> never meant to be accessed directly. I think, that's what my issue is. It
> is bad programming (does not matter whether it is bug fix or not).
> 
> For your series it probably is still fine as you will overide it pretty
> soon but what about stable. Anybody looking at that code might want
> to say, hey why not directly initialize bp->iv1 instead of trying to
> do *bp->bip1.bip_vec. And everybody will say, yes looks fine and boom
> a bug is introduced because we did bad programming.

Ok. It's definitely a bit weird and unusual, and if I wasn't getting rid
of it in the next patch it would definitely merit a comment.

For stable... wtf would they be making that kind of change for, and
without reading the relevant code?

Eh, maybe I will stick in that comment and take it out in the next
patch.
