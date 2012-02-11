Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab2BKMTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 07:19:32 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62571 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab2BKMTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 07:19:30 -0500
Date: Sat, 11 Feb 2012 15:19:23 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
Message-ID: <20120211121923.GA3341@p183.telecom.by>
References: <4F33BF05.208@gmail.com>
 <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com>
 <4F33C7D7.1060801@kernel.dk>
 <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com>
 <4F33CEAE.60400@gmail.com>
 <CACVxJT-+ycJmCZCOiuKaBbxCcnkgygfRtkeke06nb9DvPrT=kg@mail.gmail.com>
 <CACVxJT9gf0NkAuWWe02Q59HbjRB2WAJLJiRrrrFy5a46+po0eQ@mail.gmail.com>
 <3F3C1079-91B3-4AD4-97ED-EACAD3CB085F@gmail.com>
 <CACVxJT92s+XptSm+aNcbhNi0ovEwT0PSSCTiq=VYsbKDRKQWdw@mail.gmail.com>
 <C55D1711-151F-439C-8412-B9AFE09097DC@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C55D1711-151F-439C-8412-B9AFE09097DC@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 09:09:09AM -0500, Xi Wang wrote:
> On Feb 10, 2012, at 8:58 AM, Alexey Dobriyan wrote:
> > No,
> > 
> > If one dimension is constant, limit should be divided by it, so
> > compiler would have less chance
> > to screw up compile time evaluation.
> 
> I think the BUILD_BUG_ON macro can prevent that misuse.

But there is no misuse.

Both kaalloc(non-const, const) and kaalloc(const, non-const) are OK.
It's just first case happens more often.
