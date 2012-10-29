Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673Ab2J2Ujw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:39:52 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58321 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758414Ab2J2Ujt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:39:49 -0400
Date: Mon, 29 Oct 2012 16:39:37 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 1/9] random32: introduce random32_get_bytes() and
 prandom32_get_bytes()
Message-ID: <20121029203937.GC7098@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Artem Bityutskiy <dedekind1@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-mtd@lists.infradead.org
References: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351408746-8623-1-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 04:18:58PM +0900, Akinobu Mita wrote:
>  /**
> + *	prandom32_get_bytes - get the requested number of pseudo-random bytes
> + *	@state: pointer to state structure holding seeded state.
> + *	@buf: where to copy the pseudo-random bytes to
> + *	@bytes: the requested number of bytes
> + *
> + *	This is used for pseudo-randomness with no outside seeding.
> + *	For more random results, use random32_get_bytes().
> + */
> +
> +/**
> + *	random32_get_bytes - get the requested number of pseudo-random bytes
> + *	@buf: where to copy the pseudo-random bytes to
> + *	@bytes: the requested number of bytes
> + */

This naming scheme is going to be very confusing.  If the function is
going to return a pseudo-random number, it *must* have a "prandom"
suffix.  Otherwise some kernel developer, somewhere, will get confused
between get_random_bytes() and random32_get_bytes(), and the result
may be a very embarassing security exposure.

How about prandom32_get_bytes_state() and prandom32_get_bytes() instead?

						- Ted
