Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab0KRGAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 01:00:48 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:59336 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab0KRGAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 01:00:45 -0500
Date: Thu, 18 Nov 2010 15:00:08 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Dan Carpenter <error27@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 1/2] fbcmap: cleanup white space in fb_alloc_cmap()
Message-ID: <20101118060007.GC12227@linux-sh.org>
References: <20101027093716.GD6062@bicker> <20101105134018.2c11f283.akpm@linux-foundation.org> <20101113100718.GB1795@bicker> <20101115044820.GA8489@linux-sh.org> <20101116090119.GA31724@bicker> <20101027093716.GD6062@bicker> <20101105134018.2c11f283.akpm@linux-foundation.org> <20101113100638.GA1795@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116090119.GA31724@bicker> <20101113100638.GA1795@bicker>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 01:06:38PM +0300, Dan Carpenter wrote:
> checkpatch.pl and Andrew Morton both complained about the indenting in
> fb_alloc_cmap()

On Tue, Nov 16, 2010 at 12:11:02PM +0300, Dan Carpenter wrote:
> There is an integer overflow in fb_set_user_cmap() because cmap->len * 2
> can wrap.  It's basically harmless.  Your terminal will be messed up
> until you type reset.
> 
> This patch does three things to fix the bug.
> 
> First, it checks the return value of fb_copy_cmap() in fb_alloc_cmap().
> That is enough to fix address the overflow.
> 
> Second it checks for the integer overflow in fb_set_user_cmap().
> 
> Lastly I wanted to cap "cmap->len" in fb_set_user_cmap() much lower
> because it gets used to determine the size of allocation.  Unfortunately
> no one knows what the limit should be.  Instead what this patch does
> is makes the allocation happen with GFP_KERNEL instead of GFP_ATOMIC
> and lets the kmalloc() decide what values of cmap->len are reasonable.
> To do this, the patch introduces a function called fb_alloc_cmap_gfp()
> which is like fb_alloc_cmap() except that it takes a GFP flag.

Both applied, thanks.
