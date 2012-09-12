Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab2ILFis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 01:38:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40187 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab2ILFiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 01:38:46 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1209121333031.4482@tundra.namei.org>
References: <alpine.LRH.2.02.1209121333031.4482@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Sep 2012 13:38:24 +0800
X-Google-Sender-Auth: do2fHcE8O3ZITY612sxHvZ7wiH4
Message-ID: <CA+55aFzUCu36-3EjzA2RTMTPHOWnekXyHkxWiza=BEvdvhd=hA@mail.gmail.com>
Subject: Re: [GIT] Digital signature library bugfix
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 11:34 AM, James Morris <jmorris@namei.org> wrote:
>
> -       if (!err && len == hlen)
> -               err = memcmp(out2, h, hlen);
> +       if (err || len != hlen) {
> +               err = -EINVAL;
> +               goto err;
> +       }
> +
> +       err = memcmp(out2, h, hlen);
>
>  err:

Hmm. I'll pull, but this seems to drop the error return from
pkcs_1_v1_5_decode_emsa() and always replace it with -EINVAL.

Now, I didn't look, and maybe that's the only error that the decode
thing can return, but still, it looks bad.

Wouldn't it have been better to do instead

   if (err)
      goto err;
   err = -EINVAL;
   if (len != hlen)
      goto err;

and not overwrite the 'err' return with EINVAL?

             Linus
