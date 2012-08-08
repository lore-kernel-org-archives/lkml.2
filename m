Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2HHDGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 23:06:36 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43971 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab2HHDGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 23:06:35 -0400
MIME-Version: 1.0
In-Reply-To: <201208081005308597351@gmail.com>
References: <201208081005308597351@gmail.com>
Date: Wed, 8 Aug 2012 11:06:34 +0800
X-Google-Sender-Auth: Ck7W-60zWHTR3HaLhTYP7OkXfsg
Message-ID: <CANejiEXdHaqtXuR47QRimRNcvjxtUn8__7MK5XwW2t658hz=3g@mail.gmail.com>
Subject: Re: [RFC PATCH] block:Fix some problems about handling plug in blk_queue_bio().
From: Shaohua Li <shli@kernel.org>
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/8 Jianpeng Ma <majianpeng@gmail.com>:
> I think there are three problems about handling plug in blk_queue_bio():
> 1:if request_count >= BLK_MAX_REQUEST_COUNT, avoid unnecessary plug->should_sort judge.
this makes sense, though not a big deal, nice to fix it.

> 2:Only two device can trace plug.
I didn't get the point, can you have more details?

> 3:When exec blk_flush_plug_list,it use list_sort which has
> O(nlog(n)) complexity. When insert and sort, it only O(n) complexity.
but now you do the list iterator for every request, so it's O(n*n)?
The plug list is unlikely too long, so I didn't worry about the time
spending on list sort.
