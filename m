Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689Ab2CMHnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:43:17 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65464 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab2CMHnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:43:15 -0400
MIME-Version: 1.0
In-Reply-To: <4F5EF563.5000700@openvz.org>
References: <20120313024818.GA7125@barrios>
	<1331620214-4893-1-git-send-email-wenqing.lz@taobao.com>
	<20120313064832.GA4968@gmail.com>
	<4F5EF563.5000700@openvz.org>
Date: Tue, 13 Mar 2012 13:13:14 +0530
Message-ID: <CAFPAmTTPxGzrZrW+FR4B_MYDB372HyzdnioO0=CRwx0zQueRSQ@mail.gmail.com>
Subject: Re: Fwd: Control page reclaim granularity
From: Kautuk Consul <consul.kautuk@gmail.com>
To: minchan@kernel.org, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        Zheng Liu <wenqing.lz@taobao.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed this discussion and decided to pitch in one small idea from my side.

It would be nice to range lock an inode's pages by storing those
ranges which would be locked.
This could also add some good routines for the kernel in terms of
range locking for a single inode.
However, wouldn't this add some overhead to shrink_page_list() since
that code would need to go through
all these ranges while trying to reclaim a single page ?

One small suggestion from my side is:
Why don't we implement something like : "Complete page-cache reclaim
control from usermode"?
In this, we can set/unset the mapping to AS_UNEVICTABLE (as Konstantin
mentioned) for a file's
inode from usermode by using ioctl or fcntl or maybe even go as far as
implementing an O_NORECL
option to the open system call.

After setting the AS_UNEVICTABLE, the usermode application can choose
to keep and remove pages by
using the fadvise(WILLNEED) and fadvise(DONTNEED).

( I think maybe the presence of any VMA is might not really be
required for this idea. )

Thanks,
Kautuk.
