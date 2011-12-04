Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1LDMOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 07:14:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49316 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab1LDMOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 07:14:17 -0500
Message-ID: <1323000831.4205.4.camel@lappy>
Subject: Re: [PATCH] virtio-ring: Use threshold for switching to indirect
 descriptors
From: Sasha Levin <levinsasha928@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        markmc@redhat.com
Date: Sun, 04 Dec 2011 14:13:51 +0200
In-Reply-To: <4EDB5EF0.2010909@redhat.com>
References: <20111129125622.GB19157@redhat.com>
	  <1322573688.4395.11.camel@lappy> <20111129135406.GB30966@redhat.com>
	  <1322576464.7003.6.camel@lappy> <20111129145451.GD30966@redhat.com>
	  <4ED4F30F.8000603@redhat.com> <1322669511.3985.8.camel@lappy>
	  <87wrahrp0u.fsf@rustcorp.com.au> <20111201075847.GA5479@redhat.com>
	  <1322726977.3259.3.camel@lappy> <20111201102640.GB8822@redhat.com>
	  <87zkfbre9x.fsf@rustcorp.com.au> <1322913028.3782.4.camel@lappy>
	 <4EDB5EF0.2010909@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-04 at 13:52 +0200, Avi Kivity wrote:
> On 12/03/2011 01:50 PM, Sasha Levin wrote:
> > On Fri, 2011-12-02 at 11:16 +1030, Rusty Russell wrote:
> > > On Thu, 1 Dec 2011 12:26:42 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > On Thu, Dec 01, 2011 at 10:09:37AM +0200, Sasha Levin wrote:
> > > > > On Thu, 2011-12-01 at 09:58 +0200, Michael S. Tsirkin wrote:
> > > > > > We'll presumably need some logic to increment is back,
> > > > > > to account for random workload changes.
> > > > > > Something like slow start?
> > > > > 
> > > > > We can increment it each time the queue was less than 10% full, it
> > > > > should act like slow start, no?
> > > > 
> > > > No, we really shouldn't get an empty ring as long as things behave
> > > > well. What I meant is something like:
> > > 
> > > I was thinking of the network output case, but you're right.  We need to
> > > distinguish between usually full (eg. virtio-net input) and usually
> > > empty (eg. virtio-net output).
> > > 
> > > The signal for "we to pack more into the ring" is different.  We could
> > > use some hacky heuristic like "out == 0" but I'd rather make it explicit
> > > when we set up the virtqueue.
> > > 
> > > Our other alternative, moving the logic to the driver, is worse.
> > > 
> > > As to fading the effect over time, that's harder.  We have to deplete
> > > the ring quite a few times before it turns into always-indirect.  We
> > > could back off every time the ring is totally idle, but that may hurt
> > > bursty traffic.  Let's try simple first?
> >
> > I tried to take a different approach, and tried putting the indirect
> > descriptors in a kmem_cache as Michael suggested. The benchmarks showed
> > that this way virtio-net actually worked faster with indirect on even in
> > a single stream.
> 
> How much better?

host->guest was same with both indirect on and off, and guest->host went
up by 5% with indirect on.

This was just a simple 1 TCP stream test.

> 
> I think that if indirects benefit networking, then we're doing something
> wrong.  What's going on?  Does the ring get filled too early?  If so we
> should expand it.
> 

-- 

Sasha.

