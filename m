Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1BTWnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 17:43:20 -0500
Received: from kroah.org ([198.145.64.141]:33935 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab1BTWnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 17:43:19 -0500
Date: Sun, 20 Feb 2011 14:29:16 -0800
From: Greg KH <greg@kroah.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Charles Manning <manningc2@actrix.gen.nz>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Message-ID: <20110220222916.GA27324@kroah.com>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com>
 <4D5DC368.2080003@bluewatersys.com>
 <20110218005852.GA14546@kroah.com>
 <201102210625.08616.manningc2@actrix.gen.nz>
 <20110220200755.GA26243@kroah.com>
 <4D617EF0.7020308@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D617EF0.7020308@bluewatersys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 09:52:00AM +1300, Ryan Mallon wrote:
> On 02/21/2011 09:07 AM, Greg KH wrote:
> > On Mon, Feb 21, 2011 at 06:25:08AM +1300, Charles Manning wrote:
> >> On Friday 18 February 2011 13:58:52 Greg KH wrote:
> >> I still intend to keep the tracing printk-based tracing:
> >>
> >> #define yaffs_trace(msk, fmt, ...) do { \
> >> 	if (yaffs_trace_mask & (msk)) \
> >> 		printk(KERN_DEBUG "yaffs: " fmt "\n", ##__VA_ARGS__); \
> >> } while (0)
> > 
> > No, please don't invent your own stuff like this, again, use the
> > in-kernel functionality provided for this.
> 
> Do you mean using pr_debug? Other filesystems (see for example
> fs/ubifs/debug.h:dbg_do_msg) and drivers have similar approaches to this
> to allow printk debugging with multiple message levels.

Yes, other ones do have this, and it's a pain, and not consistant across
the kernel, and usually just not worth it at all.

Please use the standardized functions for this, you do not need to roll
your own at all.

Especially for trace stuff.

thanks,

greg k-h
