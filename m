Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2ICGfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 02:35:32 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34240 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2ICGfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 02:35:30 -0400
Message-ID: <50444FAF.7030304@redhat.com>
Date: Mon, 03 Sep 2012 08:35:27 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Frank Swiderski <fes@google.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikew@google.com,
        Ying Han <yinghan@google.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
References: <1340742778-11282-1-git-send-email-fes@google.com> <4FEA1E2E.4020806@redhat.com> <CAK+C7kWKtoYC=1fBQ45RTFfNc3p2PwZbLMOefMTtzOfsqe_k8w@mail.gmail.com> <20120626214709.GA15406@redhat.com> <CAK+C7kUN-kYVK9AnEhcof98p+eZN1dkt9qVyYppETOeS2n3CMQ@mail.gmail.com> <87obnzxaxv.fsf@rustcorp.com.au>
In-Reply-To: <87obnzxaxv.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/07/2012 02:29, Rusty Russell ha scritto:
> VIRTIO_BALLOON_F_MUST_TELL_HOST
> implies you should tell the host (eventually).  I don't know if any
> implementations actually care though.

This is indeed broken, because it is a "negative" feature: it tells you
that "implicit deflate" is _not_ supported.

Right now, QEMU refuses migration if the target does not support all the
features that were negotiated.  But then:

- a migration from non-MUST_TELL_HOST to MUST_TELL_HOST will succeed,
which is wrong;

- a migration from MUST_TELL_HOST to non-MUST_TELL_HOST will fail, which
is useless.

> We could add a VIRTIO_BALLOON_F_NEVER_TELL_DEFLATE which would mean the
> deflate vq need not be used at all.

That would work.  At the same time we could deprecate MUST_TELL_HOST.
Certainly the guest implementations don't care, or we would have
experienced problems such as the one above.  The QEMU implementation
also does not care but, for example, a Xen implementation would care.

Paolo
