Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab1D0Rtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:49:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48576 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932883Ab1D0Rtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:49:40 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=i38SgkEfDKkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=gu6fZOg2AAAA:8 a=pGLkceISAAAA:8 a=6Rb6yGDm6vFOShMGLJgA:9 a=h9KaHbzulg167PH0roUA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Steven Rostedt <rostedt@goodmis.org>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Christoph Hellwig <hch@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <e8a554f881a199107afd37795adb0d11e70fdbcc.1303846852.git.tfransosi@gmail.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	 <e8a554f881a199107afd37795adb0d11e70fdbcc.1303846852.git.tfransosi@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Apr 2011 13:49:36 -0400
Message-ID: <1303926576.18763.75.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 16:45 -0300, Thiago Farina wrote:
> This macro is arguably more readable than its variants:
> - !strcmp(a, b)
> - strcmp(a, b) == 0

Actually, this was proposed way back in 2002 my Rusty and I did not see
anyone arguing against it. I wonder why it never was incorporated back
then?

http://marc.info/?l=linux-kernel&m=103284339813100&w=2

[ added Cc's of some of those that replied to this thread ]

-- Steve


> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  Changes from v1 (Steven and Alexey review):
>  - Convert from macro to static inline.
>  - Remove the example.
>  - Add the suggested comment by Steven.
> 
>  include/linux/string.h |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/string.h b/include/linux/string.h
> index a716ee2..d859bb2 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -134,6 +134,21 @@ extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
>  			const void *from, size_t available);
>  
>  /**
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
> +	return strcmp(a, b) == 0;
> +}
> +
> +/**
>   * strstarts - does @str start with @prefix?
>   * @str: string to examine
>   * @prefix: prefix to look for.


