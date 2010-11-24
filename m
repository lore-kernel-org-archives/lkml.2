Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab0KXOOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:14:48 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54644 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab0KXOOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:14:47 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikCn-YvORocXSJ1Z+ovYNMhKF7TaX=BHWKwrQup@mail.gmail.com>
References: <AANLkTikg-sR97tkG=ST9kjZcHe6puYSvMGh-eA3cnH7X@mail.gmail.com>
	<20101122161158.02699d10.akpm@linux-foundation.org>
	<1290501502.2390.7029.camel@nimitz>
	<AANLkTik2Fn-ynUap2fPcRxRdKA=5ZRYG0LJTmqf80y+q@mail.gmail.com>
	<1290529171.2390.7994.camel@nimitz>
	<AANLkTikCn-YvORocXSJ1Z+ovYNMhKF7TaX=BHWKwrQup@mail.gmail.com>
Date: Wed, 24 Nov 2010 15:14:46 +0100
Message-ID: <AANLkTi=mgTHPEYFsryDYnxPa78f-Nr+H7i4+0KPZbxh3@mail.gmail.com>
Subject: Re: Sudden and massive page cache eviction
From: =?UTF-8?Q?Peter_Sch=C3=BCller?= <scode@spotify.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Mattias de Zalenski <zalenski@spotify.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Do you have any large page (hugetlbfs) or other multi-order (> 1 page)
>> allocations happening in the kernel?

I forgot to address the second part of this question: How would I best
inspect whether the kernel is doing that?

Looking at the kmalloc() sizes from vmstat -m I have the following on
one of the machines (so very few larger than 4096). But I suspect you
are asking for something different?

kmalloc-8192                 52     56   8192      4
kmalloc-4096              33927  62040   4096      8
kmalloc-2048                338    416   2048     16
kmalloc-1024              76211 246976   1024     32
kmalloc-512                1134   1216    512     32
kmalloc-256              109523 324928    256     32
kmalloc-128                3902   4288    128     32
kmalloc-64               105296 105536     64     64
kmalloc-32                 2120   2176     32    128
kmalloc-16                 4607   4608     16    256
kmalloc-8                  6655   6656      8    512
kmalloc-192                6546   9030    192     21
kmalloc-96                29694  32298     96     42

-- 
/ Peter Schuller aka scode
