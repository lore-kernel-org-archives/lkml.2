Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2GQL0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 07:26:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab2GQL0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 07:26:19 -0400
Date: Tue, 17 Jul 2012 14:26:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Asias He <asias@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/5] Add vhost-blk support
Message-ID: <20120717112645.GA9363@redhat.com>
References: <1342107302-28116-1-git-send-email-asias@redhat.com>
 <CAJSP0QWgmXns89se+xdGgM6i1_hsfVWPQ8caHua9d-dDA4CTDQ@mail.gmail.com>
 <50052276.2080906@redhat.com>
 <500527BA.9000001@redhat.com>
 <50052E7E.6020100@redhat.com>
 <CAJSP0QW0tPV3WASGOBRE4hL=8zzSFQ6T=bHbEwMAzmHR9wnwJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QW0tPV3WASGOBRE4hL=8zzSFQ6T=bHbEwMAzmHR9wnwJg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 12:11:15PM +0100, Stefan Hajnoczi wrote:
> On Tue, Jul 17, 2012 at 10:21 AM, Asias He <asias@redhat.com> wrote:
> > On 07/17/2012 04:52 PM, Paolo Bonzini wrote:
> >>
> >> Il 17/07/2012 10:29, Asias He ha scritto:
> >>>
> >>> So, vhost-blk at least saves ~6 syscalls for us in each request.
> >>
> >>
> >> Are they really 6?  If I/O is coalesced by a factor of 3, for example
> >> (i.e. each exit processes 3 requests), it's really 2 syscalls per request.
> >
> >
> > Well. I am counting the number of syscalls in one notify and response
> > process. Sure the IO can be coalesced.
> 
> Linux AIO also supports batching in io_submit() and io_getevents().
> Depending on the request pattern in the vring when you process it, you
> should be able to do better than 1 set of syscalls per host I/O
> request.
> 
> Are you taking advantage of that at the moment in your userspace benchmark?
> 
> Stefan

Injecting an interrupt directly from kernel bypasses two context switches.
Yes some worloads can coalesce interrupts efficiently but others can't.
It is not really hard to speculate more.

Personally I don't understand where all this speculation leads us.
Are you guys disputing the measurements posted? If not would not
it be better if discussion focused on the amount of extra code versus
measured gain?

-- 
MST
