Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab2IHFQX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 01:16:23 -0400
Received: from ozlabs.org ([203.10.76.45]:43345 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab2IHFQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 01:16:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, fes@google.com, aarcange@redhat.com,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org, yvugenfi@redhat.com,
        vrozenfe@redhat.com
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent deflate" feature that works
In-Reply-To: <20120907104306.GA17211@redhat.com>
References: <1346917610-14568-1-git-send-email-pbonzini@redhat.com> <20120906084736.GF17656@redhat.com> <50486BB2.7070108@redhat.com> <20120906094442.GA22816@redhat.com> <50487382.8030303@redhat.com> <20120906105301.GC32325@redhat.com> <5048935A.8090308@redhat.com> <87wr06hg0l.fsf@rustcorp.com.au> <20120907054202.GA3452@redhat.com> <87vcfqfia1.fsf@rustcorp.com.au> <20120907104306.GA17211@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sat, 08 Sep 2012 14:36:00 +0930
Message-ID: <87sjatf6iv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Fri, Sep 07, 2012 at 04:09:50PM +0930, Rusty Russell wrote:
>> > So it looks like a bug: we should teach driver to tell host first on leak?
>> > Yan, Vadim, can you comment please?
>> >
>> > Also if true, looks like this bit will be useful to detect a fixed driver on
>> > the hypervisor side - to avoid unmapping such pages? Rusty what do you
>> > think?
>> 
>> So, feature is unimplemented in qemu, and broken in drivers.  I starting
>> to share Paolo's dislike of it.
>
> What is broken in drivers?

Because supporting the feature is *not* optional for a driver.

If the device said MUST_TELL_HOST, it meant that the driver *had* to
tell the host before it touched the page, otherwise Bad Things might
happen.  It was in the original spec precisely to allow devices to
actually *remove* pages.

Noone ever noticed the windows driver didn't support it, because qemu
never requires MUST_TELL_HOST.

So in practice, it's now an optional feature.  Since no device used it
anyway, we're better off discarding it than trying to fix it.

If someone wants an *optional* "tell me first" feature later, that's
easy to add, but I don't see why they'd want to.

> Do we really know there are no hypervisors implementing it?

As much as can be known.  Qemu doesn't, lkvm doesn't.

> As I said above drivers do have support.

Not the windows drivers.  So it's optional, thus removing it will likely
harm noone.

Cheers,
Rusty.
