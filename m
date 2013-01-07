Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab3AGOEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:04:43 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:55651 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab3AGOEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:04:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Archit Taneja <archit@ti.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Prabhakar Lad <prabhakar.lad@ti.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] omap_vout: find_vma() needs ->mmap_sem held
Date: Mon, 07 Jan 2013 15:06:18 +0100
Message-ID: <50282838.8ei2CtB7na@avalon>
User-Agent: KMail/4.9.2 (Linux/3.6.11-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20130106110225.49b03d4e@infradead.org>
References: <20121215201237.GW4939@ZenIV.linux.org.uk> <20121215203828.GX4939@ZenIV.linux.org.uk> <20130106110225.49b03d4e@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Sunday 06 January 2013 11:02:25 Mauro Carvalho Chehab wrote:
> Em Sat, 15 Dec 2012 20:38:29 +0000 Al Viro escreveu:
> > On Sat, Dec 15, 2012 at 08:12:37PM +0000, Al Viro wrote:
> > > 	Walking rbtree while it's modified is a Bad Idea(tm); besides,
> > > 
> > > the result of find_vma() can be freed just as it's getting returned
> > > to caller.  Fortunately, it's easy to fix - just take ->mmap_sem a bit
> > > earlier (and don't bother with find_vma() at all if virtp >= PAGE_OFFSET
> > > -
> > > in that case we don't even look at its result).
> > 	
> > 	While we are at it, what prevents VIDIOC_PREPARE_BUF calling
> > 
> > v4l_prepare_buf() -> (e.g) vb2_ioctl_prepare_buf() -> vb2_prepare_buf() ->
> > __buf_prepare() -> __qbuf_userptr() -> vb2_vmalloc_get_userptr() ->
> > find_vma(), AFAICS without having taken ->mmap_sem anywhere in process? 
> > The code flow is bloody convoluted and depends on a bunch of things done
> > by initialization, so I certainly might've missed something...
> 
> This driver is currently missing an active maintainer, as it is for an old
> hardware (AFAIK, omap is now at version 4, and this is for the first one),
> but I'm c/c a few developers that might help to test and analyze it.
> 
> In any case, /me is assuming that your patch is right (as nobody
> complained), and I'm applying it right now on my tree. This will hopefully
> allow some people to test.

Please make sure you apply v2 (posted as "Re: [PATCH] omap_vout: find_vma() 
needs ->mmap_sem held").

-- 
Regards,

Laurent Pinchart

