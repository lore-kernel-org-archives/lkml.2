Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab1KCKm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 06:42:27 -0400
Received: from ozlabs.org ([203.10.76.45]:44794 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab1KCKm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 06:42:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pekka Enberg <penberg@kernel.org>
Cc: mst@redhat.com, Christoph Hellwig <hch@infradead.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4 of 5] virtio: avoid modulus operation
In-Reply-To: <CAOJsxLEt6_y7jw0bRsaita4gfb2k+BAQMeRLs9PcHntGVSFvaQ@mail.gmail.com>
References: <patchbomb.1320306168@localhost6.localdomain6> <05de9ee25e222c5206f3.1320306172@localhost6.localdomain6> <CAOJsxLEt6_y7jw0bRsaita4gfb2k+BAQMeRLs9PcHntGVSFvaQ@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 03 Nov 2011 20:48:17 +1030
Message-ID: <87r51pse52.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Nov 2011 09:51:15 +0200, Pekka Enberg <penberg@kernel.org> wrote:
> On Thu, Nov 3, 2011 at 9:42 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > Since we know vq->vring.num is a power of 2, modulus is lazy (it's asserted
> > in vring_new_virtqueue()).
> >
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > ---
> >  drivers/virtio/virtio_ring.c |   10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
> > --- a/arch/x86/lguest/boot.c
> > +++ b/arch/x86/lguest/boot.c
> > @@ -1420,7 +1420,7 @@ __init void lguest_init(void)
> >        add_preferred_console("hvc", 0, NULL);
> >
> >        /* Register our very early console. */
> > -       virtio_cons_early_init(early_put_chars);
> > +//     virtio_cons_early_init(early_put_chars);
> 
> What's this hunk here?

Ugly workaround for console until hvc_console breakage gets reverted.

Left in by mistake :)

Thanks,
Rusty.
