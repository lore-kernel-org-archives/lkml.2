Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab0IXNE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:04:58 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57398 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752164Ab0IXNE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:04:57 -0400
Date: Fri, 24 Sep 2010 15:02:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lnxninja@linux.vnet.ibm.comc, Andrew Morton <akpm@osdl.org>
Subject: Re: [RFC][PATCH] update /proc/sys/vm/drop_caches documentation
Message-ID: <20100924130216.GA1810@ucw.cz>
References: <20100914234714.8AF506EA@kernel.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914234714.8AF506EA@kernel.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> There seems to be an epidemic spreading around.  People get the idea
> in their heads that the kernel caches are evil.  They eat too much
> memory, and there's no way to set a size limit on them!  Stupid
> kernel!

Its worse. IIRC android actually uses it in production. And, IIRC akpm
told me that drop_caches does not include enough locking to be
safe. If that's still the case, it should be documented.

> -As this is a non-destructive operation and dirty objects are not freeable, the
> -user should run `sync' first.
> +This is a non-destructive operation and will not free any dirty objects.
> +To increase the number of objects freed by this operation, the user may run
> +`sync' prior to writing to /proc/sys/vm/drop_caches.  This will minimize the
> +number of dirty objects on the system and create more candidates to be
> +dropped.
> +
> +This file is not a means to control the growth of the various kernel caches
> +(inodes, dentries, pagecache, etc...)  These objects are automatically
> +reclaimed by the kernel when memory is needed elsewhere on the system.
> +
> +Outside of a testing or debugging environment, use of
> +/proc/sys/vm/drop_caches is not recommended.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
