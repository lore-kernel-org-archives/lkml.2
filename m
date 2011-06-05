Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133Ab1FEEJr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 00:09:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51357 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1FEEJq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 00:09:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=x3QNhEcYN9IZF0Xwh+TN92UwJ0lmo6SnmJNiKLJEpMZf2qu792GWK9YTCO26yEIHsW
         1GKtMeEl0ImXlbXLbK4T8t3vEfFdG2l/fhOI8AaTW1hxThVoeNNhFU6F02IjFunAiYKu
         paFJCf6ubAgWQU8FZLGwPXVXeVqGvNlxZ74pA=
MIME-Version: 1.0
In-Reply-To: <1306889876-5327-1-git-send-email-asharma@fb.com>
References: <1306889876-5327-1-git-send-email-asharma@fb.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 5 Jun 2011 00:09:25 -0400
Message-ID: <BANLkTinEkfRH-xJRyrtajSLEkEwrau7yRA@mail.gmail.com>
Subject: Re: [PATCH] atomic: generalize atomic_add_unless_return
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 20:57, Arun Sharma wrote:
> commit 686a7e3 added this primitive to get something going
> for the stable branch.
>
> Move the primitive to <linux/atomic.h>

this changelog is confusing.  please replace the pronouns with proper nouns.

> --- a/include/linux/atomic.h
> +++ b/include/linux/atomic.h
>  /**
> + * atomic_add_unless - add unless the number is already a given value
> + * @v: pointer of type atomic_t
> + * @a: the amount to add to v...
> + * @u: ...unless v is equal to u.
> + *
> + * Atomically adds @a to @v, so long as @v was not already @u.
> + * Returns the old value of @v + @a.
> + */
> +static inline int atomic_add_unless_return(atomic_t *v, int a, int u)

the name of the func in the comment does not match the actual name of the func

also, the semantics here appear to deviate from the other atomic
funcs.  the existing xxx_return funcs return the new result, not the
old.
-mike
