Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab2GYIRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:17:22 -0400
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:52802 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932732Ab2GYIRR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:17:17 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [PATCH] add blockconsole version 1.1
Date: Wed, 25 Jul 2012 09:17:09 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-90.fc15.x86_64; KDE/4.6.5; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
References: <20120424205946.GH20610@logfs.org> <201207240901.16151.tvrtko.ursulin@onelan.co.uk> <20120724143822.GA24954@logfs.org>
In-Reply-To: <20120724143822.GA24954@logfs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207250917.09516.tvrtko.ursulin@onelan.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 Jul 2012 15:38:22 Jörn Engel wrote:
> On Tue, 24 July 2012 09:01:16 +0100, Tvrtko Ursulin wrote:
> > On Monday 23 Jul 2012 21:02:30 Jörn Engel wrote:
> > > On Mon, 23 July 2012 15:33:16 +0100, Tvrtko Ursulin wrote:
> > > > On Thursday 12 Jul 2012 18:46:34 Jörn Engel wrote:
> > At the very least block console does not work from interrupt context
> > while netconsole does, right? Also netconsole does things to try and
> > work around low memory situations. Things like that I think would be
> > useful additions to documentation.
> 
> Blockconsole does work from interrupt context.  It has buffers for 1MB
> worth of data.  Until those fill up, it only does a memcpy and
> schedules a workqueue for writeback.  If you panic, it will do the
> writeback immediately.  While I wouldn't believe this to always work,
> I have yet to see a confirmed failure case.

As far as I know there is nothing like netpoll in the block layer so it has to 
be a lot less reliable than netconsole. Especially with delaying write out to 
a workqueue. Anyway, I am not arguing, just saying in my opinion those caveats 
are worth documenting.
 
> Blockconsole itself has no allocations in the write path, so it should
> be unaffected by low memory situation.  The underlying driver and
> block layer code may well be.

Same thing.
 
> > > > Also, and I haven't checked what the swap format is, if it could
> > > > somehow be integrated together that could be useful.
> > > 
> > > That appears to be slightly less likely than crossbreeding a rabbit
> > > with a chicken.  Is there something obvious I have missed?
> > 
> > I was thinking how swap space is always there and is potentially much
> > faster to write to than a random USB stick - which could translate to
> > more reliable. Then it's a question of which storage subsystem (libata
> > vs. usb-storage) would work better in different oops/panic situations.
> > Again I tend to have less hope in USB based solutions - maybe it's my
> > bias from working in that area many years ago. So the idea of swap space
> > was that _if_ swap format could be extended to allocate a number of
> > blocks to use other than swap, then that area could be used by
> > blockconsole. Seemed like a convenient and potentially more reliable
> > solution to me, but as I said the latter may depend.
> 
> In my systems swap is often absent.  Plus, taking a few blocks a swap
> aside is in the end just partitioning in a new dress.  So the argumen
> appears to boil down to using partitions again.  The equivalent of
> swap files might be interesting, but can also be somewhat scary.  So I
> would leave it to others to actually write the code - if they care.

I knew you'll pick me up on a new partitioning scheme. :) I just see it as 
convenience. Whereas it is often not possible (or at least to much effort) to 
create new partitions, swap if often around and potentially more reliable than 
a random USB stick (considering the whole data path).
 
> Libata is fine, blockconsole can work on any block device.

My point was that it's reliability will differ depending on the block device 
in use, which is unlike netconsole. Again I am not arguing against the 
feature, but if you don't see things like these are worth documenting I give 
up.

Tvrtko
