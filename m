Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab2BJNLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:11:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53199 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758703Ab2BJNL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:11:29 -0500
MIME-Version: 1.0
In-Reply-To: <CACVxJT-+ycJmCZCOiuKaBbxCcnkgygfRtkeke06nb9DvPrT=kg@mail.gmail.com>
References: <20120207141155.GA16184@elgon.mountain>
	<4F323388.7040902@kernel.dk>
	<20120208142513.4db2493a.akpm@linux-foundation.org>
	<4F33BF05.208@gmail.com>
	<CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com>
	<4F33C7D7.1060801@kernel.dk>
	<32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com>
	<4F33CEAE.60400@gmail.com>
	<CACVxJT-+ycJmCZCOiuKaBbxCcnkgygfRtkeke06nb9DvPrT=kg@mail.gmail.com>
Date: Fri, 10 Feb 2012 15:11:28 +0200
Message-ID: <CACVxJT9gf0NkAuWWe02Q59HbjRB2WAJLJiRrrrFy5a46+po0eQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 4:09 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Thu, Feb 9, 2012 at 4:48 PM, Xi Wang <xi.wang@gmail.com> wrote:
>> -static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
>> +static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
>>  {
>>        if (size != 0 && n > ULONG_MAX / size)
>>                return NULL;
>> -       return __kmalloc(n * size, flags | __GFP_ZERO);
>> +       return __kmalloc(n * size, flags);
>> +}
>
> It should be named kaalloc(), I think.
> Why it is ULONG_MAX, when size_t is used?

Also, it could be written more "robust" against people who will make
sizeof() the first argument with __builtin_constant_p().
