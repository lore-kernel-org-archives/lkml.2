Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278Ab2BJNzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:55:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33927 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab2BJNzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:55:05 -0500
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <CACVxJT9gf0NkAuWWe02Q59HbjRB2WAJLJiRrrrFy5a46+po0eQ@mail.gmail.com>
Date: Fri, 10 Feb 2012 08:55:02 -0500
Cc: Jens Axboe <axboe@kernel.dk>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Content-Transfer-Encoding: 7bit
Message-Id: <3F3C1079-91B3-4AD4-97ED-EACAD3CB085F@gmail.com>
References: <20120207141155.GA16184@elgon.mountain> <4F323388.7040902@kernel.dk> <20120208142513.4db2493a.akpm@linux-foundation.org> <4F33BF05.208@gmail.com> <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk> <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com> <CACVxJT-+ycJmCZCOiuKaBbxCcnkgygfRtkeke06nb9DvPrT=kg@mail.gmail.com> <CACVxJT9gf0NkAuWWe02Q59HbjRB2WAJLJiRrrrFy5a46+po0eQ@mail.gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2012, at 8:11 AM, Alexey Dobriyan wrote:
>> It should be named kaalloc(), I think.

I like this shorter name.  Let's see what others think. ;-)

>> Why it is ULONG_MAX, when size_t is used?

Is there a SIZE_MAX or something similar?

> Also, it could be written more "robust" against people who will make
> sizeof() the first argument with __builtin_constant_p().

Do you mean something like this?

  BUILD_BUG_ON(__builtin_constant_p(n));

or

  BUILD_BUG_ON(__builtin_constant_p(n) && !__builtin_constant_p(size));

- xi
