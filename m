Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab1KCHvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:51:19 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61772 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab1KCHvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:51:16 -0400
MIME-Version: 1.0
In-Reply-To: <05de9ee25e222c5206f3.1320306172@localhost6.localdomain6>
References: <patchbomb.1320306168@localhost6.localdomain6>
	<05de9ee25e222c5206f3.1320306172@localhost6.localdomain6>
Date: Thu, 3 Nov 2011 09:51:15 +0200
X-Google-Sender-Auth: S9Ei4zk3b2VQTK9pGrIwjGG7xqI
Message-ID: <CAOJsxLEt6_y7jw0bRsaita4gfb2k+BAQMeRLs9PcHntGVSFvaQ@mail.gmail.com>
Subject: Re: [PATCH 4 of 5] virtio: avoid modulus operation
From: Pekka Enberg <penberg@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: MichaelS.Tsirkist@redhat.com, Christoph Hellwig <hch@infradead.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 3, 2011 at 9:42 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Since we know vq->vring.num is a power of 2, modulus is lazy (it's asserted
> in vring_new_virtqueue()).
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/virtio/virtio_ring.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
> --- a/arch/x86/lguest/boot.c
> +++ b/arch/x86/lguest/boot.c
> @@ -1420,7 +1420,7 @@ __init void lguest_init(void)
>        add_preferred_console("hvc", 0, NULL);
>
>        /* Register our very early console. */
> -       virtio_cons_early_init(early_put_chars);
> +//     virtio_cons_early_init(early_put_chars);

What's this hunk here?
