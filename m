Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab0DVO1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 10:27:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755204Ab0DVO1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 10:27:48 -0400
Date: Thu, 22 Apr 2010 07:25:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
cc: Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] [MTD] Fix JFFS2 sync silent failure
In-Reply-To: <20100422062631.GC27309@logfs.org>
Message-ID: <alpine.LFD.2.00.1004220724170.9086@i5.linux-foundation.org>
References: <20100417184016.GA17345@logfs.org> <20100419073843.GN27497@kernel.dk> <20100419101559.GA4145@logfs.org> <20100419102056.GS27497@kernel.dk> <20100422055448.GA27309@logfs.org> <20100422062631.GC27309@logfs.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 Apr 2010, Jörn Engel wrote:
>
> I think this is bad enough that you should be involved.  32a88aa1 broke
> a number of filesystems in a way that sync() would return 0 without
> doing any work.  Even politicians are better at keeping the promises.
> 
> This is caused by the two-liner in __sync_filesystem:
> 	if (!sb->s_bdi)
> 		return 0;
> s_bdi is set implicitly for all filesystems using set_bdev_super(), so
> most block device based filesystems are safe.  There are, however, a
> number of odd-balls around:

Umm. Why not just remove the two-liner? It was incorrect. The comment says 
"this should be safe", and if it wasn't, then the commit that caused this 
all was total crap to begin with.

Why even discuss any other measures?

		Linus
