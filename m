Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0DZOgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:36:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61738 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab0DZOgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:36:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HMDU6/nxLQySLgQgWU0QgVXBhqupqTauFUOGafiCAa08FbkDQk7rzvr1lFIJd46cqs
         iUF521lYeC9rruOX5Xm/EtnSdlFyslmp06BSu2v1ycwOkRk9NISioa6o++3yt+aszSfN
         p2yU1tYK7qPvYRV55KjK9Fqp1xmcXhgD6Wpck=
MIME-Version: 1.0
In-Reply-To: <20100426.025542.193706542.davem@davemloft.net>
References: <20100426.025542.193706542.davem@davemloft.net>
Date: Mon, 26 Apr 2010 10:36:01 -0400
Message-ID: <w2pb4198de61004260736sdc815942z1ea3d650c33e5890@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon: Fix sparc regression in r300_scratch()
From: Matt Turner <mattst88@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: airlied@redhat.com, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 5:55 AM, David Miller <davem@davemloft.net> wrote:
>
> Commit b4fe945405e477cded91772b4fec854705443dd5 ("drm/radeon: Fix
> memory allocation failures in the preKMS command stream checking.")
> added a regression in that it completely tossed the get_unaligned()
> done by r300_scratch() which we added in commit
> 958a6f8ccb1964adc3eec84cf401c5baeb4fbca0 ("drm: radeon: Fix unaligned
> access in r300_scratch().").
>
> Put it back.
>
> Signed-off-by: David S. Miller <davem@davemloft.net>
>
> diff --git a/drivers/gpu/drm/radeon/r300_cmdbuf.c b/drivers/gpu/drm/radeon/r300_cmdbuf.c
> index ea46d55..c5c2742 100644
> --- a/drivers/gpu/drm/radeon/r300_cmdbuf.c
> +++ b/drivers/gpu/drm/radeon/r300_cmdbuf.c
> @@ -921,7 +921,7 @@ static int r300_scratch(drm_radeon_private_t *dev_priv,
>
>        ptr_addr = drm_buffer_read_object(cmdbuf->buffer,
>                        sizeof(stack_ptr_addr), &stack_ptr_addr);
> -       ref_age_base = (u32 *)(unsigned long)*ptr_addr;
> +       ref_age_base = (u32 *)(unsigned long)get_unaligned(ptr_addr);
>
>        for (i=0; i < header.scratch.n_bufs; i++) {
>                buf_idx = drm_buffer_pointer_to_dword(cmdbuf->buffer, 0);
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>

Should help Alpha as well.

Acked-by: Matt Turner <mattst88@gmail.com>
