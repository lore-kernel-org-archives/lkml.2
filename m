Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463Ab2IFDDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:03:19 -0400
Received: from ozlabs.org ([203.10.76.45]:40604 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286Ab2IFDAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:00:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Frank Swiderski <fes@google.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikew@google.com,
        Ying Han <yinghan@google.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
In-Reply-To: <50444FAF.7030304@redhat.com>
References: <1340742778-11282-1-git-send-email-fes@google.com> <4FEA1E2E.4020806@redhat.com> <CAK+C7kWKtoYC=1fBQ45RTFfNc3p2PwZbLMOefMTtzOfsqe_k8w@mail.gmail.com> <20120626214709.GA15406@redhat.com> <CAK+C7kUN-kYVK9AnEhcof98p+eZN1dkt9qVyYppETOeS2n3CMQ@mail.gmail.com> <87obnzxaxv.fsf@rustcorp.com.au> <50444FAF.7030304@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 06 Sep 2012 11:05:12 +0930
Message-ID: <87sjawhr1r.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:
> Il 02/07/2012 02:29, Rusty Russell ha scritto:
>> VIRTIO_BALLOON_F_MUST_TELL_HOST
>> implies you should tell the host (eventually).  I don't know if any
>> implementations actually care though.
>
> This is indeed broken, because it is a "negative" feature: it tells you
> that "implicit deflate" is _not_ supported.
>
> Right now, QEMU refuses migration if the target does not support all the
> features that were negotiated.  But then:
>
> - a migration from non-MUST_TELL_HOST to MUST_TELL_HOST will succeed,
> which is wrong;
>
> - a migration from MUST_TELL_HOST to non-MUST_TELL_HOST will fail, which
> is useless.
>
>> We could add a VIRTIO_BALLOON_F_NEVER_TELL_DEFLATE which would mean the
>> deflate vq need not be used at all.
>
> That would work.  At the same time we could deprecate MUST_TELL_HOST.
> Certainly the guest implementations don't care, or we would have
> experienced problems such as the one above.  The QEMU implementation
> also does not care but, for example, a Xen implementation would care.

OK; I'm not sure we need to deprecate MUST_TELL_HOST, though since it's
never actually been used there's a good argument.

VIRTIO_BALLOON_F_SILENT_DEFLATE (or whatever it's called) would
obviously mean you couldn't ack VIRTIO_BALLOON_F_MUST_TELL_HOST.

Patches welcome!

Cheers,
Rusty.
