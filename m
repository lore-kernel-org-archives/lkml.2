Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab2IJGpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 02:45:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab2IJGpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 02:45:41 -0400
Date: Mon, 10 Sep 2012 09:47:05 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: fes@google.com, aarcange@redhat.com, riel@redhat.com, yvugenfi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mikew@google.com,
        yinghan@google.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
Message-ID: <20120910064705.GB17949@redhat.com>
References: <20120907121712.GA17397@redhat.com>
 <5049E717.8080307@redhat.com>
 <20120907124432.GB17397@redhat.com>
 <5049FEDD.40303@redhat.com>
 <20120907142545.GC17397@redhat.com>
 <504A0858.4080508@redhat.com>
 <20120908222221.GA20588@redhat.com>
 <504D7F95.9070700@redhat.com>
 <20120910060359.GB16819@redhat.com>
 <504D8AD1.6050006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504D8AD1.6050006@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 08:38:09AM +0200, Paolo Bonzini wrote:
> Il 10/09/2012 08:03, Michael S. Tsirkin ha scritto:
> > On Mon, Sep 10, 2012 at 07:50:13AM +0200, Paolo Bonzini wrote:
> >> Il 09/09/2012 00:22, Michael S. Tsirkin ha scritto:
> >>>> Almost.  One is "the guest, if really needed, can tell the host of
> >>>> pages".  If not negotiated, and the host does not support it, the host
> >>>> must break the guest (e.g. fail to offer any virtqueues).
> >>>
> >>> There is no way in spec to break the guest.
> >>> You can not fail to offer virtqueues.
> >>
> >> You can always return 0 for the first queue.
> > 
> > I don't think guest drivers recover gracefully from this.
> > Do they?
> 
> No, that's the point ("break the guest" is really "break the driver").

You can just stop VM then. No need for a side channel.

...

> >>>> The other is "the guest, though, would prefer not to do so".  It is
> >>>> different because the guest can proceed in a fallback mode even if the
> >>>> host doesn't offer it.
> >>>
> >>> I think I get what your proposed SILENT means what I do not get
> >>> is the motivation. It looks like a premature optimization to me.
> >>
> >> The motivation is to let the driver choose between two behaviors: the
> >> current one where ballooning is only done on request, and a more
> >> aggressive one.
> > 
> > Yes but why is being silent any good? Optimization?
> > Any data to show that it will help some workload?
> 
> Idle guests can move cache pages to the balloon.  You can overcommit
> more aggressively, because the host can madvise away a lot more memory.

IMHO this feature needs more thought. E.g. how will this work with assignment?
If we build something let's build it in a way that plays nicely
with other features.

> >>> OK so TELL says *when* to notify host, SILENT if set allows guest
> >>> to skip leak notifications? In this case TELL should just be ignored
> >>> when SILENT is set.
> >>
> >> Yeah, that was my first idea.  However, there are existing drivers that
> >> ignore SILENT, so that would not be 100% exact.
> > 
> > Not sure I follow the logic.
> > They don't ack SILENT so that would be 100% exact.
> 
> Hmm, then I'm not sure I follow yours.  We agreed that delaying
> notifications or skipping them is really the same thing, right?
> 
> I think we're just stuck in a linguistic problem, with "must not" being
> wrong and "does not have to" being too verbose.  Calling it
> VIRTIO_BALLOON_F_SILENT_DEFLATE was a workaround for this, but perhaps
> it adds more confusion.
> 
> Paolo

Looks like it does :)
