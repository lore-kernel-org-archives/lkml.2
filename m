Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab2KEDYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 22:24:22 -0500
Received: from ozlabs.org ([203.10.76.45]:48565 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab2KEDYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 22:24:19 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 6/9] virtio_mmio: Cast &resources[1].start to
 =?utf-8?Q?=E2=80=98unsigned?= int =?utf-8?Q?*=E2=80=99?= to rid compiler
 warning
In-Reply-To: <1351980150-24145-7-git-send-email-lee.jones@linaro.org>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org> <1351980150-24145-7-git-send-email-lee.jones@linaro.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 05 Nov 2012 13:08:57 +1030
Message-ID: <87k3u0ydry.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Jones <lee.jones@linaro.org> writes:
> drivers/virtio/virtio_mmio.c: In function ‘vm_cmdline_set’:
> drivers/virtio/virtio_mmio.c:535:4: warning: format ‘%u’ expects argument of type ‘unsigned int *’, but argument 4 has type ‘resource_size_t *’ [-Wformat]
>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: virtualization@lists.linux-foundation.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/virtio/virtio_mmio.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index 6b1b7e1..077e9ca 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -531,7 +531,7 @@ static int vm_cmdline_set(const char *device,
>  	resources[0].end = memparse(device, &str) - 1;
>  
>  	processed = sscanf(str, "@%lli:%u%n:%d%n",
> -			&base, &resources[1].start, &consumed,
> +			&base, (unsigned int *)&resources[1].start, &consumed,
>  			&vm_cmdline_id, &consumed);

This suppresses a valid warning, leaving our code no less wrong than
before.  But now it's silently wrong!

Do you want to try again?

Cheers,
Rusty.
