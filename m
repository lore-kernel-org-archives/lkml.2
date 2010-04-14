Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab0DNQqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:46:21 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:59233 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab0DNQqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:46:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AUaS78aS0yOEnFy+ghV/a+DroHEngbX0VlKl+2+8V3142wJjhfKilJCvAX+daYPenv
         C8YEB30OfkJkAJPOTgBPX/2vSFmyXHBsgiCQbVrlYWEpxex5OCbsTp1CwhsNHBA+OcFH
         X1f9tQh7ERuNi7yyPOYwgSWvV5C0KQlncYgho=
Message-ID: <4BC5F1A7.8060208@gmail.com>
Date: Wed, 14 Apr 2010 09:47:35 -0700
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com
Subject: Re: [REGRESSION PATCH V2] vsprintf: Change struct printf_spec.precision
 from s8 to s16
References: <20100414011336.16139.68030.stgit@paris.rdu.redhat.com> <1271262460.1578.53.camel@Joe-Laptop.home>
In-Reply-To: <1271262460.1578.53.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2010 09:27 AM, Joe Perches wrote:
> Commit ef0658f3de484bf9b173639cd47544584e01efa5 changed precision
> from int to s8.
>
> There is existing kernel code that uses a larger precision.
>
> An example from the audit code:
> 	vsnprintf(...,..., " msg='%.1024s'", (char *)data);
> which overflows precision and truncates to nothing.
>
> Extending precision size fixes the audit system issue.
>
> Other changes:
>
> Change the size of the struct printf_spec.type from u16 to u8 so
> sizeof(struct printf_spec) stays as small as possible.
> Reorder the struct members so sizeof(struct printf_spec) remains 64 bits
> without alignment holes.
> Document the struct members a bit more.
>
> Original-patch-by: Eric Paris<eparis@redhat.com>
> Signed-off-by: Joe Perches<joe@perches.com>
> ---
>   lib/vsprintf.c |   10 +++++-----
>   1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 24112e5..7376b7c 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -408,12 +408,12 @@ enum format_type {
>   };
>
>   struct printf_spec {
> -	u16	type;
> -	s16	field_width;	/* width of output field */
> +	u8	type;		/* format_type enum */
>   	u8	flags;		/* flags to number() */
> -	u8	base;
> -	s8	precision;	/* # of digits/chars */
> -	u8	qualifier;
> +	u8	base;		/* number base, 8, 10 or 16 only */
> +	u8	qualifier;	/* number qualifier, one of 'hHlLtzZ' */
> +	s16	field_width;	/* width of output field */
> +	s16	precision;	/* # of digits/chars */
>   };
>
>   static char *number(char *buf, char *end, unsigned long long num,
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

just applied:
the first patch in this thread is good,
as well as this one.

Tested-by: Justin P. Mattock <justinmattock@gmail.com>

Justin P. Mattock
