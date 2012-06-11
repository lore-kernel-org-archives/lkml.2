Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab2FKW7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 18:59:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab2FKW7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 18:59:21 -0400
Date: Mon, 11 Jun 2012 15:59:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include: Fix compile warning in include/linux/bitops.h
Message-Id: <20120611155919.7decee80.akpm@linux-foundation.org>
In-Reply-To: <1339211730-10398-1-git-send-email-linkinjeon@gmail.com>
References: <1339211730-10398-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Jun 2012 23:15:30 -0400
Namjae Jeon <linkinjeon@gmail.com> wrote:

> The compile warning is caused by __const_hweight8 when using
> hweight_long with -Wsign-compare option.
> The reason is that the default return value of this macro is signed.
> So need type casting to remove warning.

um, what warning?

Please always quote the compiler messages when fixing build warnings or
errors.

> index fa2a50b..3ad0dae 100644
> --- a/include/asm-generic/bitops/const_hweight.h
> +++ b/include/asm-generic/bitops/const_hweight.h
> @@ -4,7 +4,7 @@
>  /*
>   * Compile time versions of __arch_hweightN()
>   */
> -#define __const_hweight8(w)		\
> +#define __const_hweight8(w)	(unsigned long)	\
>        (	(!!((w) & (1ULL << 0))) +	\
>  	(!!((w) & (1ULL << 1))) +	\
>  	(!!((w) & (1ULL << 2))) +	\

