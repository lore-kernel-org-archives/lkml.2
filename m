Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab2JWCBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:01:01 -0400
Received: from ozlabs.org ([203.10.76.45]:54504 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496Ab2JWCA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:00:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: sjur.brandeland@stericsson.com, Amit Shah <amit.shah@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjurbren@gmail.com,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: Re: [PATCHv7 2/4] virtio_console: Use kmalloc instead of kzalloc
In-Reply-To: <1350287856-5284-3-git-send-email-sjur.brandeland@stericsson.com>
References: <1350287856-5284-1-git-send-email-sjur.brandeland@stericsson.com> <1350287856-5284-3-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 23 Oct 2012 12:06:34 +1030
Message-ID: <87d30ahsv1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sjur.brandeland@stericsson.com writes:

> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Avoid the more cpu expensive kzalloc when allocating buffers.
> Originally kzalloc was intended for isolating the guest from
> the host by not sending random guest data to the host. But device
> isolation is not yet in place so kzalloc is not really needed.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

This looks fine to me.  This is *why* the device gives us the length
which was written; we can trust that, even if we can't trust the
writer of data.

(In theory: noone has implemented such a system, yet).

Applied.
Rusty.

> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index c36b2f6..301d17e 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -349,7 +349,7 @@ static struct port_buffer *alloc_buf(size_t buf_size)
>  	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
>  	if (!buf)
>  		goto fail;
> -	buf->buf = kzalloc(buf_size, GFP_KERNEL);
> +	buf->buf = kmalloc(buf_size, GFP_KERNEL);
>  	if (!buf->buf)
>  		goto free_buf;
>  	buf->len = 0;
> -- 
> 1.7.5.4
