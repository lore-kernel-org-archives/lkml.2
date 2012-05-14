Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2ENVTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:19:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38041 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757683Ab2ENVTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:19:18 -0400
Date: Mon, 14 May 2012 14:19:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] floppy: remove floppy-specific O_EXCL handling
Message-ID: <20120514211913.GL2366@google.com>
References: <alpine.LNX.2.00.1205131059410.15448@pobox.suse.cz>
 <20120514162521.GA2366@google.com>
 <alpine.LNX.2.00.1205142237590.15448@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1205142237590.15448@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 14, 2012 at 10:42:58PM +0200, Jiri Kosina wrote:
> Because since
> 
> 	commit e525fd89d380c4a94c0d63913a1dd1a593ed25e7
> 	Author: Tejun Heo <tj@kernel.org>
> 	Date:   Sat Nov 13 11:55:17 2010 +0100
> 
> 	    block: make blkdev_get/put() handle exclusive access
> 
> mount of /dev/fd0 actually causes the fd0 block device be claimed with 
> _EXCL. Before this commit, you are able to mount /dev/fd0 and then open() 
> it afterward. After this commit you can't any more, because mounting 
> /dev/fd0 already passes O_EXCL to floppy_open(), and thus noone else can 
> open(/dev/fd0) any more.
> 
> My commit brings things back into shape, i.e. you can, equally to other 
> block devices, both mount it and open() it afterwards.

Ah, that makes sense.  Maybe it's a good idea to note why the change
is necessary in the commit message too?

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
