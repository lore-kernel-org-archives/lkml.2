Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab2JWCB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:01:56 -0400
Received: from ozlabs.org ([203.10.76.45]:57115 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518Ab2JWCA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:00:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: sjur.brandeland@stericsson.com, Amit Shah <amit.shah@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, sjurbren@gmail.com,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: Re: [PATCHv7 3/4] virtio_console: Merge struct buffer_token into struct port_buffer
In-Reply-To: <1350287856-5284-4-git-send-email-sjur.brandeland@stericsson.com>
References: <1350287856-5284-1-git-send-email-sjur.brandeland@stericsson.com> <1350287856-5284-4-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 23 Oct 2012 10:49:24 +1030
Message-ID: <87fw56hwfn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sjur.brandeland@stericsson.com writes:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Refactoring the splice functionality by unifying the approach for
> sending scatter-lists and regular buffers. This simplifies
> buffer handling and reduces code size. Splice will now allocate
> a port_buffer and send_buf() and free_buf() can always be used
> for any buffer.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

This looks sensible; a couple of extra blank lines inserted though.

Amit?

> @@ -1033,6 +1008,8 @@ static const struct file_operations port_fops = {
>  static int put_chars(u32 vtermno, const char *buf, int count)
>  {
>  	struct port *port;
> +	struct scatterlist sg[1];
> +
>  
>  	if (unlikely(early_put_chars))
>  		return early_put_chars(vtermno, buf, count);
> @@ -1041,7 +1018,9 @@ static int put_chars(u32 vtermno, const char *buf, int count)
>  	if (!port)
>  		return -EPIPE;
>  
> -	return send_buf(port, (void *)buf, count, false);
> +	sg_init_one(sg, buf, count);
> +	return __send_to_port(port, sg, 1, count, (void *)buf, false);
> +
>  }
>  
>  /*

Cheers,
Rusty.
