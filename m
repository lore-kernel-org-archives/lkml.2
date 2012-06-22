Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab2FVJ7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 05:59:32 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:49270 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761953Ab2FVJ7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 05:59:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120622094702.GD14083@ZenIV.linux.org.uk>
References: <CAFub=KRdM2Mc1RXa_HfYO8gSxpyCpsP9Z1YHRULCLwNDnXQyEg@mail.gmail.com>
	<20120622094702.GD14083@ZenIV.linux.org.uk>
Date: Fri, 22 Jun 2012 12:59:29 +0300
Message-ID: <CAFub=KSth0q6VJ+adQmvXVjcVT0-XuyRzfN00+U9DWEHPi-aVw@mail.gmail.com>
Subject: Re: get_unused_fd and get_unused_fd_flags
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Details of that "have to", please.  Note that existing modular uses of
> get_unused_fd() tend to be rather fishy; if anything, I'd expect
> get_unused_fd() eventually becoming internal-only, if we manage to
> pull that off.

I've got it. I'm backporting the dma-buf (drivers/base/dma-buf.c)
feature to kernels < 3.3. It is actually pretty straightforward except
a single call to get_unused_fd_flags() from dma_buf_fd(). Then
get_unused_fd_flags() macro resolves to alloc_fd() which is not
exported.

Maybe I should backport alloc_fd and rename it to sth like
compat_alloc_fd and use that instead of alloc_fd in compat. What I was
trying to understand was the reason behind exporting/not-exporting
those similar wrappers. I don't try to justify that it should be
exported for me :)

Thanks!



-- 
Ozan Çağlayan
