Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab0KXPcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 10:32:42 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35760 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab0KXPcl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 10:32:41 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimo1BR=mSJ6wPQwrL4FDNv=_TfanPPTT7uWx7hQ@mail.gmail.com>
References: <AANLkTikg-sR97tkG=ST9kjZcHe6puYSvMGh-eA3cnH7X@mail.gmail.com>
	<20101122161158.02699d10.akpm@linux-foundation.org>
	<1290501502.2390.7029.camel@nimitz>
	<AANLkTik2Fn-ynUap2fPcRxRdKA=5ZRYG0LJTmqf80y+q@mail.gmail.com>
	<1290529171.2390.7994.camel@nimitz>
	<AANLkTikCn-YvORocXSJ1Z+ovYNMhKF7TaX=BHWKwrQup@mail.gmail.com>
	<AANLkTi=mgTHPEYFsryDYnxPa78f-Nr+H7i4+0KPZbxh3@mail.gmail.com>
	<AANLkTimo1BR=mSJ6wPQwrL4FDNv=_TfanPPTT7uWx7hQ@mail.gmail.com>
Date: Wed, 24 Nov 2010 16:32:39 +0100
Message-ID: <AANLkTi=yV02oY5AmNAYr+ZF0RUgVv8gkeP+D9_CcOfLi@mail.gmail.com>
Subject: Re: Sudden and massive page cache eviction
From: =?UTF-8?Q?Peter_Sch=C3=BCller?= <scode@spotify.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mattias de Zalenski <zalenski@spotify.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I forgot to address the second part of this question: How would I best
>> inspect whether the kernel is doing that?
>
> You can, for example, record
>
>  cat /proc/meminfo | grep Huge
>
> for large page allocations.

Those show zero a per my other post. However I got the impression Dave
was asking about regular but larger-than-one-page allocations internal
to the kernel, while the Huge* lines in /proc/meminfo refers to
allocations specifically done by userland applications doing huge page
allocation on a system with huge pages enabled - or am I confused?

> The "pagesperslab" column of /proc/slabinfo tells you how many pages
> slab allocates from the page allocator.

Seems to be what vmstat -m reports.

-- 
/ Peter Schuller aka scode
