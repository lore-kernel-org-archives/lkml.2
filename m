Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab0D3RNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:13:40 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:45002 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932800Ab0D3RMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:12:44 -0400
Date: Wed, 28 Apr 2010 07:52:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [PATCH 3/5] PM / Hibernate: separate block_io
Message-ID: <20100428055244.GA3501@ucw.cz>
References: <1272356118-10012-1-git-send-email-jslaby@suse.cz>
 <1272356118-10012-3-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272356118-10012-3-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Move block I/O operations to a separate file. It is because it will
> be used later not only by the swap writer.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Nigel Cunningham <ncunningham@crca.org.au>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>

> +++ b/kernel/power/block_io.c
> @@ -0,0 +1,103 @@
> +/*
> + * This file provides functions for block I/O operations on swap/file.
> + *
> + * Copyright (C) 1998,2001-2005 Pavel Machek <pavel@suse.cz>

That address no longer works, but keeps popping up....

> diff --git a/kernel/power/power.h b/kernel/power/power.h
> index b1e207d..006270f 100644
> --- a/kernel/power/power.h
> +++ b/kernel/power/power.h
> @@ -142,6 +142,15 @@ extern int swsusp_read(unsigned int *flags_p);
>  extern int swsusp_write(unsigned int flags);
>  extern void swsusp_close(fmode_t);
>  
> +/* kernel/power/block_io.c */
> +extern struct block_device *hib_resume_bdev;

It is slightly sad that this is now not only static, but also
cross-module...


> +extern int hib_bio_read_page(pgoff_t page_off, void *addr,
> +		struct bio **bio_chain);
> +extern int hib_bio_write_page(pgoff_t page_off, void *addr,
> +		struct bio **bio_chain);
> +extern int hib_wait_on_bio_chain(struct bio **bio_chain);
> +

Does the documentation usually go to the header in these cases?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
