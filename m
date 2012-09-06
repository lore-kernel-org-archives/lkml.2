Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab2IGADS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 20:03:18 -0400
Received: from ozlabs.org ([203.10.76.45]:38763 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234Ab2IGAC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 20:02:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: fes@google.com, aarcange@redhat.com, riel@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent deflate" feature that works
In-Reply-To: <5048935A.8090308@redhat.com>
References: <1346917610-14568-1-git-send-email-pbonzini@redhat.com> <20120906084736.GF17656@redhat.com> <50486BB2.7070108@redhat.com> <20120906094442.GA22816@redhat.com> <50487382.8030303@redhat.com> <20120906105301.GC32325@redhat.com> <5048935A.8090308@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 07 Sep 2012 09:15:46 +0930
Message-ID: <87wr06hg0l.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:
> Instead, VIRTIO_NET_F_HOST_MUST_SEND_GARP would be a "negative" feature:
> if set, the host _may not_ rely on the guest to send a gARP.  Similarly
> if VIRTIO_BALLOON_F_MUST_TELL_HOST is set, the guest _may not_ use
> ballooned pages directly.
>
> There are _no_ other negative features besides
> VIRTIO_BALLOON_F_MUST_TELL_HOST in the spec, and for a good
> reason---because they're broken.
>
> (Hmm, actually we have one, VIRTIO_BLK_F_RO.  It is also a bit broken,
> but it is not so important because it depends on user input more than
> hypervisor version).

Yes, this is the key observation, and an important lesson for the
future.  Thanks!

Note that these two negative features were in the original spec, where
it's assumed that every device supports them.  That's not explicitly
documented, however.

I like killing the totally unused feature.

Cheers,
Rusty.
