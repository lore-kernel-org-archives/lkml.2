Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307Ab2IGKlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 06:41:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab2IGKlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 06:41:50 -0400
Date: Fri, 7 Sep 2012 13:43:06 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, fes@google.com, aarcange@redhat.com,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org, yvugenfi@redhat.com,
        vrozenfe@redhat.com
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent
 deflate" feature that works
Message-ID: <20120907104306.GA17211@redhat.com>
References: <1346917610-14568-1-git-send-email-pbonzini@redhat.com>
 <20120906084736.GF17656@redhat.com>
 <50486BB2.7070108@redhat.com>
 <20120906094442.GA22816@redhat.com>
 <50487382.8030303@redhat.com>
 <20120906105301.GC32325@redhat.com>
 <5048935A.8090308@redhat.com>
 <87wr06hg0l.fsf@rustcorp.com.au>
 <20120907054202.GA3452@redhat.com>
 <87vcfqfia1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vcfqfia1.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 04:09:50PM +0930, Rusty Russell wrote:
> > So it looks like a bug: we should teach driver to tell host first on leak?
> > Yan, Vadim, can you comment please?
> >
> > Also if true, looks like this bit will be useful to detect a fixed driver on
> > the hypervisor side - to avoid unmapping such pages? Rusty what do you
> > think?
> 
> So, feature is unimplemented in qemu, and broken in drivers.  I starting
> to share Paolo's dislike of it.

What is broken in drivers?

To me it looks like it works exactly as advertized: linux and bsd ack
TELL_HOST and tells host first. windows does not do either.  Do windows
drivers currently are not broken: they just do not support the feature.

The claim that drivers and hyprevisors do not support it is false:
qemu does not support it but drivers do and in non trivial way.

> Don't understand why we'd care about fixed drivers though, if we remove
> the feature bit....
> 
> Cheers,
> Rusty.

Do we really know there are no hypervisors implementing it?
As I said above drivers do have support.

-- 
MST
