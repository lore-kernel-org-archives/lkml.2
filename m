Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab2HIGFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:05:24 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:56454 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2HIGFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:05:23 -0400
Date: Wed, 8 Aug 2012 23:05:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 05/12] block: Kill bi_destructor
Message-ID: <20120809060517.GB2845@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-6-git-send-email-koverstreet@google.com>
 <20120808222223.GD6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809002154.GE7262@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809002154.GE7262@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 08, 2012 at 05:21:54PM -0700, Kent Overstreet wrote:
> > What's wrong with good ol' NULL?
> 
> If it's NULL, we can't distinguish between bios where that field wasn't
> set (i.e. bios that were statically allocated somewhere) from bios that
> were allocated by bio_kmalloc().
> 
> It's just there to make debugging easier - if bi_cnt goes to 0 on a bio
> where it shouldn't we'll catch it at the BUG_ON() in bio_free() instead
> of kfreeing a bad pointer.

I fail to see how that improves anything.  slab will complain clearly
if it gets passed in a pointer to static area.  The benefit is
imaginery.  If there's no bioset, it's NULL.  Let's please keep things
usual.

Thanks.

-- 
tejun
