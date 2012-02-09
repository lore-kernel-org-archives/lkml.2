Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509Ab2BIXI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 18:08:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758450Ab2BIXI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 18:08:57 -0500
Date: Thu, 9 Feb 2012 15:08:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Xi Wang <xi.wang@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
Message-Id: <20120209150856.7f97d28e.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1202091442070.7219@chino.kir.corp.google.com>
References: <20120207141155.GA16184@elgon.mountain>
	<4F323388.7040902@kernel.dk>
	<20120208142513.4db2493a.akpm@linux-foundation.org>
	<4F33BF05.208@gmail.com>
	<CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com>
	<4F33C7D7.1060801@kernel.dk>
	<32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com>
	<4F33CEAE.60400@gmail.com>
	<alpine.DEB.2.00.1202091442070.7219@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Feb 2012 14:42:49 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Thu, 9 Feb 2012, Xi Wang wrote:
> 
> > This patch introduces a kmalloc_array() wrapper that performs integer
> > overflow checking without zeroing the memory.
> > 
> > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > Suggested-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Xi Wang <xi.wang@gmail.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
> assuming there's at least one new user or one existing user that can be 
> modified to use the new interface and this won't just sit around not being 
> used.

The need is there - I've whined about the absence of kmalloc_array()
maybe 3 times in the past year.

Often kcalloc() is suitable - quite a lot of arrays which are sized
based on a userspace-provided dimension are also zeroed out.  For some
reason.

