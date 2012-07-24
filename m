Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab2GXIB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 04:01:29 -0400
Received: from claranet-outbound-smtp04.uk.clara.net ([195.8.89.37]:40917 "EHLO
	claranet-outbound-smtp04.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755084Ab2GXIB0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 04:01:26 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [PATCH] add blockconsole version 1.1
Date: Tue, 24 Jul 2012 09:01:16 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-90.fc15.x86_64; KDE/4.6.5; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
References: <20120424205946.GH20610@logfs.org> <201207231533.16350.tvrtko.ursulin@onelan.co.uk> <20120723200230.GC17767@logfs.org>
In-Reply-To: <20120723200230.GC17767@logfs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207240901.16151.tvrtko.ursulin@onelan.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 Jul 2012 21:02:30 Jörn Engel wrote:
> On Mon, 23 July 2012 15:33:16 +0100, Tvrtko Ursulin wrote:
> > On Thursday 12 Jul 2012 18:46:34 Jörn Engel wrote:
> > > Console driver similar to netconsole, except it writes to a block
> > > device.  Can be useful in a setup where netconsole, for whatever
> > > reasons, is impractical.
> > 
> > Perhaps you need to add a word or two about limitations compared to
> > netconsole in documentation because it is quite significant difference
> > in reliability? I mean so it is not assumed it is analogous to
> > netconsole but just a different underlying media. I don't know if
> > someone would expect it, but better said than not.
> 
> Given that I don't even know the limitations, that's a bit tough.  As
> a general rule, I would always prefer netconsole.  It appears to be
> more reliable than blockconsole and beats serial console by half a
> lightyear.  But as a fallback when netconsole is not realistic,
> blockconsole has proven useful.

At the very least block console does not work from interrupt context while 
netconsole does, right? Also netconsole does things to try and work around low 
memory situations. Things like that I think would be useful additions to 
documentation.
 
> > I second the notion that logging to partitions would be useful.
> 
> Below is a compile-tested patch to do that.  Feel free to give it a
> spin and fix any bugs.

I can't promise to do that in the very near future, but in principle idea 
could be interesting to me, at least to evaluate how reliable mechanism is 
with different storage interfaces and controllers.

> > Also, and I haven't checked what the swap format is, if it could somehow
> > be integrated together that could be useful.
> 
> That appears to be slightly less likely than crossbreeding a rabbit
> with a chicken.  Is there something obvious I have missed?

I was thinking how swap space is always there and is potentially much faster 
to write to than a random USB stick - which could translate to more reliable. 
Then it's a question of which storage subsystem (libata vs. usb-storage) would 
work better in different oops/panic situations. Again I tend to have less hope 
in USB based solutions - maybe it's my bias from working in that area many 
years ago. So the idea of swap space was that _if_ swap format could be 
extended to allocate a number of blocks to use other than swap, then that area 
could be used by blockconsole. Seemed like a convenient and potentially more 
reliable solution to me, but as I said the latter may depend.

Tvrtko
