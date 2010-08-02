Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab0HBRnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:43:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45431 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0HBRnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:43:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=chvbmCpq7ALk6tahWJS5Kcvk5HfdtS7CIgUBnfJU/NZP5uxPAaQeShPGq4soH1FZ93
         NzuM9t5GbPT/+4sPeGHQtWwwUgCOpDNgfGJVoHy6UoV8B71Ytn34Vgz5DpzZHUu18d4F
         QQeZqQrJ8Uu1s9Qqtsn5wob5ZBLaMBBRVIkBw=
Date: Mon, 2 Aug 2010 21:43:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 1/2] x86, setup: reorgize the early_console_setup
Message-ID: <20100802174334.GC5544@lenovo>
References: <4C56701B.1030000@kernel.org> <4C5670DA.2080703@zytor.com> <4C5680D2.4020302@kernel.org> <4C568D2B.205@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C568D2B.205@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 02:17:31AM -0700, Yinghai Lu wrote:
...
> Index: linux-2.6/arch/x86/boot/printf.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/boot/printf.c
> +++ linux-2.6/arch/x86/boot/printf.c
> @@ -34,7 +34,7 @@ static int skip_atoi(const char **s)
>  #define SMALL	32		/* Must be 32 == 0x20 */
>  #define SPECIAL	64		/* 0x */
>  
> -#define do_div(n,base) ({ \
> +#define __do_div(n, base) ({ \
>  int __res; \
>  __res = ((unsigned long) n) % (unsigned) base; \
>  n = ((unsigned long) n) / (unsigned) base; \
> @@ -83,7 +83,7 @@ static char *number(char *str, long num,
>  		tmp[i++] = '0';
>  	else
>  		while (num != 0)
> -			tmp[i++] = (digits[do_div(num, base)] | locase);
> +			tmp[i++] = (digits[__do_div(num, base)] | locase);

Yinghai, what was wrong with the origin do_div? After inclusion it as "printf.c"
in another *.c do_div gets clashed?

	-- Cyrill
