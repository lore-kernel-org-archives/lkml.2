Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab0JMNFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:05:16 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:52129 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752543Ab0JMNFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:05:15 -0400
Date: Wed, 13 Oct 2010 09:10:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [PATCH 13/23] Hibernation: Partial page I/O support.
Message-ID: <20101013071008.GA1610@ucw.cz>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
 <1285566238-10966-14-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285566238-10966-14-git-send-email-nigel@tuxonice.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Add functions that can be used for coalescing and splitting buffers
> that are smaller than PAGE_SIZE. These functions provide no method
> of determining where the boundaries of the smaller buffers are to
> be found - that is the caller's problem.

I don't get it; why do we need that support?


> +int hib_write_buffer(char *buffer, int buffer_size)
> +{
> +	int bytes_left = buffer_size, result = 0;
> +
> +	while (bytes_left) {
> +		char *from = buffer + buffer_size - bytes_left;
> +		char *to = hib_ppio_buffer + hib_ppio_buffer_posn;
> +		int capacity = PAGE_SIZE - hib_ppio_buffer_posn;
> +
> +		if (bytes_left <= capacity) {
> +			memcpy(to, from, bytes_left);
> +			hib_ppio_buffer_posn += bytes_left;
> +			return 0;
> +		}
> +
> +		/* Complete this page and start a new one */
> +		memcpy(to, from, capacity);
> +		bytes_left -= capacity;

If this copy happens too often, it will slow stuff down...
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
