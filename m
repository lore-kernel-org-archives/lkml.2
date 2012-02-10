Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab2BJN61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:58:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41569 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758722Ab2BJN60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:58:26 -0500
MIME-Version: 1.0
In-Reply-To: <3F3C1079-91B3-4AD4-97ED-EACAD3CB085F@gmail.com>
References: <20120207141155.GA16184@elgon.mountain>
	<4F323388.7040902@kernel.dk>
	<20120208142513.4db2493a.akpm@linux-foundation.org>
	<4F33BF05.208@gmail.com>
	<CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com>
	<4F33C7D7.1060801@kernel.dk>
	<32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com>
	<4F33CEAE.60400@gmail.com>
	<CACVxJT-+ycJmCZCOiuKaBbxCcnkgygfRtkeke06nb9DvPrT=kg@mail.gmail.com>
	<CACVxJT9gf0NkAuWWe02Q59HbjRB2WAJLJiRrrrFy5a46+po0eQ@mail.gmail.com>
	<3F3C1079-91B3-4AD4-97ED-EACAD3CB085F@gmail.com>
Date: Fri, 10 Feb 2012 15:58:25 +0200
Message-ID: <CACVxJT92s+XptSm+aNcbhNi0ovEwT0PSSCTiq=VYsbKDRKQWdw@mail.gmail.com>
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

On Fri, Feb 10, 2012 at 4:55 PM, Xi Wang <xi.wang@gmail.com> wrote:
> On Feb 10, 2012, at 8:11 AM, Alexey Dobriyan wrote:

>> Also, it could be written more "robust" against people who will make
>> sizeof() the first argument with __builtin_constant_p().

No,

If one dimension is constant, limit should be divided by it, so
compiler would have less chance
to screw up compile time evaluation.

Also, gfp_t mask could be made first argument if we ever want to
expand it to >2 dimensional arrays
without adding kaalloc3().

> Do you mean something like this?
>
>  BUILD_BUG_ON(__builtin_constant_p(n));
>
> or
>
>  BUILD_BUG_ON(__builtin_constant_p(n) && !__builtin_constant_p(size));
>
> - xi
