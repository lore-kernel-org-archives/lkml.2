Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab0HBAyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:54:18 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:39434 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab0HBAyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:54:17 -0400
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
From: Bojan Smojver <bojan@rexursive.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nigel Cunningham <nigel@tuxonice.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100802091752.3c9f180d.kamezawa.hiroyu@jp.fujitsu.com>
References: <1280465201.2600.10.camel@shrek.rexursive.com>
	 <1280486667.2608.1.camel@shrek.rexursive.com>
	 <4C534C9D.8000600@tuxonice.net>
	 <1280532174.2583.1.camel@shrek.rexursive.com>
	 <4C5362E7.3000706@tuxonice.net>
	 <1280538184.2583.11.camel@shrek.rexursive.com>
	 <4C537A01.5040808@tuxonice.net>
	 <1280540035.2658.5.camel@shrek.rexursive.com>
	 <1280551286.3097.6.camel@shrek.rexursive.com>
	 <20100802091752.3c9f180d.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 10:54:13 +1000
Message-ID: <1280710453.2727.8.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-02 at 09:17 +0900, KAMEZAWA Hiroyuki wrote:
> Now, vmallc() is used here. Then, following will happen.
> 
> 1. vmalloc()
>    -> vmalloc adds vmap objects and set page table entries.
> 
> 2. saving image
>    -> At taking snapshot of memory to the disk, above vmalloc() area
> is
>       saved to disk as it is.
> ...
> 3. At restore
>    Because you dont't remember which vmalloc() area was used for
> creating
>    snapshot, you can't free it at swsusp_free().
> 
> memory leak ? 

To be honest, I'm not sure.

However, I thought that by the time save_image() is called, snapshot has
already been taken, no?
------------------
        error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
        if (error)
                goto Thaw;

        if (in_suspend) {
                unsigned int flags = 0;

                if (hibernation_mode == HIBERNATION_PLATFORM)
                        flags |= SF_PLATFORM_MODE;
                pr_debug("PM: writing image.\n");
                error = swsusp_write(flags);  <--- this calls save_image()
------------------

So, me thinks that these allocations will not be in the snapshot image.

PS. Take everything I take with a grain (or two) of salt. I'm just a
regular Linux user trying to make my Fedora hibernate/thaw process suck
less.

-- 
Bojan

