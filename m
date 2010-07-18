Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0GRMgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 08:36:53 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34406 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754684Ab0GRMgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 08:36:51 -0400
Date: Sun, 18 Jul 2010 14:36:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, rjw@sisk.pl,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] PM / Hibernate: swap, switch to hibernate_io_handle
Message-ID: <20100718123643.GF30716@elf.ucw.cz>
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
 <20100610135541.GB4514@ucw.cz>
 <4C1F83EB.8060703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1F83EB.8060703@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-06-21 17:23:23, Jiri Slaby wrote:
> On 06/10/2010 03:55 PM, Pavel Machek wrote:
> > It would be good if you carried ack-s from previous rounds, so that I
> > don't have to review good patches again...
> 
> Hi, previously ACKed patches were merged already. These were much
> rewritten and their original versions were rather NACKed. Otherwise I
> transfer ACKs indeed.

Thanks!

> >> +/**
> >> + * hib_io_handle_alloc - allocate io handle with priv_size for private data
> >> + *
> >> + * @priv_size: the sie to allocate behind hibernate_io_handle for private use
> >> + */
> >> +static inline struct hibernate_io_handle *hib_io_handle_alloc(size_t priv_size)
> >> +{
> >> +	struct hibernate_io_handle *ret;
> >> +	ret = kzalloc(sizeof(*ret) + priv_size, GFP_KERNEL);
> >> +	if (ret)
> >> +		ret->priv = ret + 1;
> > 
> > Uhuh, why this? Aha, grabbing the pointer to priv_size-sized area at
> > the end of regular struct?
> 
> Yes, exactly, any more transparent way to do it?

Normally, I believe void data[]; is added at the end of structure, and
then something like ret->priv = &ret->data; is done...?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
