Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab0HaLZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 07:25:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:47210 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756973Ab0HaLZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 07:25:00 -0400
Date: Tue, 31 Aug 2010 21:24:50 +1000
From: Neil Brown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: vaurora@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
Message-ID: <20100831212450.6729ddd7@notabene>
In-Reply-To: <E1OqOa5-000677-BN@pomaz-ex.szeredi.hu>
References: <20100826183340.027591901@szeredi.hu>
	<20100827170551.19616048@notabene>
	<E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu>
	<20100827213502.31af4a4c@notabene>
	<20100830183843.GB2444@shell>
	<20100831091211.403e0d06@notabene>
	<E1OqOa5-000677-BN@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Aug 2010 13:00:45 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Tue, 31 Aug 2010, Neil Brown wrote:
> > So: is this a problem?  It may seem a bit confusing to someone who doesn't
> > understand what is happening, but we define that as not being a problem (to
> > avoid confusion: don't change U or L).
> > The important questions are:  Can it cause corruption, and can it cause a
> > deadlock?
> 
> No, I don't think this design will do that.  So it might be enough
> just to document that online modification of upper or lower
> filesystems results in undefined behavior.
> 
> But to prevent accidental damage, it's prudent (at least by default)
> to enforce the no-modification policy.
> 
> Why do you think this feature of allowing modification is important?
> Lets take some typical use cases:
> 
>  - live cd: lower layer is hard r/o, upper layer makes no sense to
>    modify online
> 
>  - thin client: lower layer is static except upgrades, which need
>    special tools to support and is done offline, upper layer makes no
>    sense to modify online
> 
> Do you have some cases in mind where it makes at least a little sense
> to allow online modification of the underlying filesystems?

No, I don't have a particular use case in mind that would take advantage of
the layers being directly modifiable.  But I know that sys-admins can be very
ingenious and may well come up with something clever.

My point is more that I don't think that is it *possible* to prevent changes
to the underlying filesystem (NFS being the prime example) so if there are
easy steps we can take to make the behaviour of overlayfs more predictable in
those cases, we should.

Further I think that insisting that the underlying filesystems remain
unchangeable is overly restrictive.  If I were not allowed to perform an
overlay mount on a read/write lower filesystem, that would make it
significantly harder to explore the possibilities of overlayfs and experiment
with it.

I certainly don't think we should put a lot of work or a lot of code into
making it work "perfectly" in any sense at all.  But if there are *easy*
things to do that allow us to avoid some weird behaviours, then I think it is
worth that effort to do it.

NeilBrown
