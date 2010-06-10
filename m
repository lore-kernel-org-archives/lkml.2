Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057Ab0FJNzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 09:55:54 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36586 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753421Ab0FJNzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 09:55:52 -0400
Date: Thu, 10 Jun 2010 15:55:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 1/9] PM / Hibernate: swap, switch to hibernate_io_handle
Message-ID: <20100610135541.GB4514@ucw.cz>
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I addressed the comments I got on the previous RFC. I left the handles
> in place, the functions in hibernate_io_ops now works on them. Further
> I got rid of the memory barriers and minimized global variables as much
> as possible. Comments welcome.

It would be good if you carried ack-s from previous rounds, so that I
don't have to review good patches again...

> Some code, which will be moved out of swap.c, will know nothing about
> swap. There will be also other than swap writers later, so that it
> won't make sense at all.
> 
> So introduce a new structure called hibernate_io_handle which
> currently contains only a pointer to private data, but is independent
> on I/O reader/writer actually used. Private data are swap_map_handle
> for now.
> 
> This structure is allocated in _start and freed in _finish. This will
> correspond to the later introduction of hibernate_io_ops where users
> will do handle=start->repeat{read/write(handle)}->finish(handle).
> I.e. they will operate on handle instead of global variables.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>

 ack.

> +/**
> + * hib_io_handle_alloc - allocate io handle with priv_size for private data
> + *
> + * @priv_size: the sie to allocate behind hibernate_io_handle for private use
> + */
> +static inline struct hibernate_io_handle *hib_io_handle_alloc(size_t priv_size)
> +{
> +	struct hibernate_io_handle *ret;
> +	ret = kzalloc(sizeof(*ret) + priv_size, GFP_KERNEL);
> +	if (ret)
> +		ret->priv = ret + 1;

Uhuh, why this? Aha, grabbing the pointer to priv_size-sized area at
the end of regular struct?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
