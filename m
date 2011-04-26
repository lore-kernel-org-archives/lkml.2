Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab1DZTyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:54:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63621 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1DZTyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:54:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pnnkUvi0zwV8vozjnqPON04rHDldDGr0bO/0mV3GSHw2A5xld9jGbLjOybBX5v3Wsi
         kMDtRPu+K6cs7339yL1JeJKR7272yPtJKrYXBEKyLp3n4gPtIuKQxNUVHVCBILRxXrkd
         Z+iDeCZp2OQ6AtmF5ctbmcDmBmuUEdghwUEKI=
MIME-Version: 1.0
In-Reply-To: <e8a554f881a199107afd37795adb0d11e70fdbcc.1303846852.git.tfransosi@gmail.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	<e8a554f881a199107afd37795adb0d11e70fdbcc.1303846852.git.tfransosi@gmail.com>
Date: Tue, 26 Apr 2011 16:54:42 -0300
Message-ID: <BANLkTikO4aJ4Lp5DS-G9tNH7TOpraVVaMg@mail.gmail.com>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thiago Farina <tfransosi@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Copying Andrew and Joe.

On Tue, Apr 26, 2011 at 4:45 PM, Thiago Farina <tfransosi@gmail.com> wrote:
> This macro is arguably more readable than its variants:
> - !strcmp(a, b)
> - strcmp(a, b) == 0
>
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  Changes from v1 (Steven and Alexey review):
>  - Convert from macro to static inline.
>  - Remove the example.
>  - Add the suggested comment by Steven.
>
>  include/linux/string.h |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/string.h b/include/linux/string.h
> index a716ee2..d859bb2 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -134,6 +134,21 @@ extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
>                        const void *from, size_t available);
>
>  /**
> + * streq - Are two strings equal?
> + * @a: first string
> + * @b: second string
> + *
> + * Use: streq(a, b)
> + * Instead of: strcmp(a, b) == 0 or !strcmp(a, b)
> + *
> + * This makes the code more readable and less error prone.
> + */
> +static inline int streq(const char *a, const char *b)
> +{
> +       return strcmp(a, b) == 0;
> +}
> +
> +/**
>  * strstarts - does @str start with @prefix?
>  * @str: string to examine
>  * @prefix: prefix to look for.
> --
> 1.7.5.rc2.5.g60e19
>
>
