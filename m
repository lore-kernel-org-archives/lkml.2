Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab2EYW55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:57:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56401 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2EYW54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:57:56 -0400
MIME-Version: 1.0
In-Reply-To: <1336745414-5530-1-git-send-email-akinobu.mita@gmail.com>
References: <1336745414-5530-1-git-send-email-akinobu.mita@gmail.com>
Date: Sat, 26 May 2012 07:57:55 +0900
Message-ID: <CAC5umyiisLM3MA-MdG4UBJW8hb-4+ZyhuBtcakuZgZuavJDfOg@mail.gmail.com>
Subject: Re: [PATCH] Optimize bitmap_weight
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/11 Akinobu Mita <akinobu.mita@gmail.com>:
> The current implementation of bitmap_weight simply evaluates the
> population count for each long word of the array, and adds.
>
> The subsection "Counting 1-bits in an Array" in the revisions of
> the book 'Hacker's Delight' explains more superior methods than
> the naive method.
>
> http://www.hackersdelight.org/revisions.pdf
> http://www.hackersdelight.org/HDcode/newCode/pop_arrayHS.c.txt
>
> My benchmark results on Intel Core i3 CPU with 32-bit kernel
> showed 50% faster for 8192 bits bitmap.  However, it is not faster
> for small bitmap (< BITS_PER_LONG * 8) than the naive method.
> So if the bitmap size is known to be small at compile time,
> use the naive method.

My benchmark was bogus.  I used __sw_hweight32 for hweight_long.
It is much slower on x86 with X86_FEATURE_POPCNT.

This patch slows bitmap_weight().  So please drop this patch
(bitmap_weight-optimize-for-large-bitmaps.patch) from -mm tree.
