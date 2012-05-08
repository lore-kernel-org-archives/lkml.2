Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2EHUQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 16:16:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40704 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051Ab2EHUQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 16:16:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120507193202.GA11518@sgi.com>
References: <20120507193202.GA11518@sgi.com>
Date: Tue, 8 May 2012 13:16:08 -0700
X-Google-Sender-Auth: dqV9D40hbRiGbUuMLrEjTb5XdJU
Message-ID: <CAE9FiQXuaJqq9HH-_mOqJHM4Veyz-Yw85we7=26b=dkfgW73dQ@mail.gmail.com>
Subject: Re: [patch] mm: nobootmem: fix sign extend problem in __free_pages_memory()
From: Yinghai Lu <yinghai@kernel.org>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 12:32 PM, Russ Anderson <rja@sgi.com> wrote:
> Systems with 8 TBytes of memory or greater can hit a problem
> where only the the first 8 TB of memory shows up.  This is
> due to "int i" being smaller than "unsigned long start_aligned",
> causing the high bits to be dropped.

when you have 8T installed, you should get [0,2g), [4g, 8T+2g)

if you have more than that. [2g, 4g) could be added as ram together
with MMIO....

>
> The fix is to change i to unsigned long to match start_aligned
> and end_aligned.
>
> Thanks to Jack Steiner (steiner@sgi.com) for assistance tracking
> this down.
>
> Signed-off-by: Russ Anderson <rja@sgi.com>
>
> ---
>  mm/nobootmem.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> Index: linux/mm/nobootmem.c
> ===================================================================
> --- linux.orig/mm/nobootmem.c   2012-05-05 08:39:39.470845187 -0500
> +++ linux/mm/nobootmem.c        2012-05-05 08:39:42.714784530 -0500
> @@ -82,8 +82,7 @@ void __init free_bootmem_late(unsigned l
>
>  static void __init __free_pages_memory(unsigned long start, unsigned long end)
>  {
> -       int i;
> -       unsigned long start_aligned, end_aligned;
> +       unsigned long i, start_aligned, end_aligned;
>        int order = ilog2(BITS_PER_LONG);
>
>        start_aligned = (start + (BITS_PER_LONG - 1)) & ~(BITS_PER_LONG - 1);

Acked-by: Yinghai Lu <yinghai@kernel.org>
