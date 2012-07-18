Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab2GRWKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:10:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab2GRWKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:10:39 -0400
Date: Wed, 18 Jul 2012 15:10:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux390@de.ibm.com, x86@kernel.org
Subject: Re: [PATCH] atomic64_test: Simplify the #ifdef for
 atomic64_dec_if_positive() test
Message-Id: <20120718151037.4692fa85.akpm@linux-foundation.org>
In-Reply-To: <1342545048-30958-1-git-send-email-catalin.marinas@arm.com>
References: <1342545048-30958-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012 18:10:48 +0100
Catalin Marinas <catalin.marinas@arm.com> wrote:

> This patch introduces CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE and uses
> this instead of the multitude of #if defined() checks in atomic64_test.c
> 
> ...
>
> --- a/lib/atomic64_test.c
> +++ b/lib/atomic64_test.c
> @@ -114,8 +114,7 @@ static __init int test_atomic64(void)
>  	r += one;
>  	BUG_ON(v.counter != r);
>  
> -#if defined(CONFIG_X86) || defined(CONFIG_MIPS) || defined(CONFIG_PPC) || \
> -    defined(CONFIG_S390) || defined(_ASM_GENERIC_ATOMIC64_H) || defined(CONFIG_ARM)

ugh, good riddance.

> +#ifdef CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE

The alternative way of doing this is to do

#define atomic64_dec_if_positive atomic64_dec_if_positive

in all the relevant .h files, then use #ifdef atomic64_dec_if_positive.
That's rather nice because it keeps everything in one place.  otoh it
is rather unobvious trickery.

But either way is better than what we have now.
