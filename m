Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab0CXUa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:30:29 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34775 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756123Ab0CXUa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:30:28 -0400
Date: Wed, 24 Mar 2010 21:30:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC 03/15] PM / Hibernate: separate block_io
Message-ID: <20100324203021.GE5798@elf.ucw.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
 <1269361063-3341-3-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269361063-3341-3-git-send-email-jslaby@suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-03-23 17:17:31, Jiri Slaby wrote:
> Move block I/O operations to a separate file. It is because it will
> be used later not only by the swap writer.

So... what is the plan here?

> +int sws_bio_read_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
> +{
> +	return submit(READ, sws_resume_bdev, page_off * (PAGE_SIZE >> 9),
> +			virt_to_page(addr), bio_chain);
> +}

sws_ is kind of strange prefix. We were trying to get away from
"swsuspend" name for quite some time...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
