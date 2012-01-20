Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2ATLxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 06:53:55 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45024 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2ATLxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 06:53:54 -0500
MIME-Version: 1.0
In-Reply-To: <1326316354.6774.12.camel@joe2Laptop>
References: <1326316354.6774.12.camel@joe2Laptop>
Date: Fri, 20 Jan 2012 11:53:52 +0000
X-Google-Sender-Auth: HUJWzL3SRDB4MXZb3uwWKl9IeNc
Message-ID: <CAAq6er0eXaG7pShVAtbSycs0NiqUbmj99P-Re_N3vWRvym=+5g@mail.gmail.com>
Subject: Re: checkpatch regression: error on #define pr_fmt(fmt)
 KBUILD_MODNAME ": " fmt
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 9:12 PM, Joe Perches <joe@perches.com> wrote:
> Current checkpatch gives:
>
> ERROR: Macros with complex values should be enclosed in parenthesis
> #18: FILE: net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:18:
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
> due to:
>
> commit b3dfb9bc52e9a751e47bbc92d3a3f07e9a0029c5
> Author: Andy Whitcroft <apw@canonical.com>
> Date:   Thu Dec 22 16:04:25 2011 +1100
>
>    checkpatch: correctly track the end of preprocessor commands in context

That one is hard to detect as being a 'string' and therefore ok.

Ok, looks like we can detect the string concatenation occuring here
and handle this better.  Does the below version work better for you:

    http://people.canonical.com/~apw/checkpatch/checkpatch-next.pl

-apw
