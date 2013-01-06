Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab3AFNDF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 08:03:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:36315 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab3AFNDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 08:03:03 -0500
Date: Sun, 6 Jan 2013 11:02:25 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@skynet.be>,
        Archit Taneja <archit@ti.com>, Prabhakar Lad <prabhakar.lad@ti.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] omap_vout: find_vma() needs ->mmap_sem held
Message-ID: <20130106110225.49b03d4e@infradead.org>
In-Reply-To: <20121215203828.GX4939@ZenIV.linux.org.uk>
References: <20121215201237.GW4939@ZenIV.linux.org.uk>
	<20121215203828.GX4939@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viro,

Em Sat, 15 Dec 2012 20:38:29 +0000
Al Viro <viro@ZenIV.linux.org.uk> escreveu:

> On Sat, Dec 15, 2012 at 08:12:37PM +0000, Al Viro wrote:
> > 	Walking rbtree while it's modified is a Bad Idea(tm); besides,
> > the result of find_vma() can be freed just as it's getting returned
> > to caller.  Fortunately, it's easy to fix - just take ->mmap_sem a bit
> > earlier (and don't bother with find_vma() at all if virtp >= PAGE_OFFSET -
> > in that case we don't even look at its result).
> 
> 	While we are at it, what prevents VIDIOC_PREPARE_BUF calling
> v4l_prepare_buf() -> (e.g) vb2_ioctl_prepare_buf() -> vb2_prepare_buf() ->
> __buf_prepare() -> __qbuf_userptr() -> vb2_vmalloc_get_userptr() -> find_vma(),
> AFAICS without having taken ->mmap_sem anywhere in process?  The code flow
> is bloody convoluted and depends on a bunch of things done by initialization,
> so I certainly might've missed something...

This driver is currently missing an active maintainer, as it is for an old
hardware (AFAIK, omap is now at version 4, and this is for the first one),
but I'm c/c a few developers that might help to test and analyze it.

In any case, /me is assuming that your patch is right (as nobody complained),
and I'm applying it right now on my tree. This will hopefully allow some
people to test.

Cheers,
Mauro
