Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762796Ab0GUHaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 03:30:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762781Ab0GUHaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 03:30:09 -0400
Date: Wed, 21 Jul 2010 00:29:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>
Subject: Re: linux-next: OOPS at boot time
Message-Id: <20100721002907.639802cd.akpm@linux-foundation.org>
In-Reply-To: <20100721052007.GT32635@dastard>
References: <20100720164145.e06242b3.sfr@canb.auug.org.au>
	<20100720033656.0ce6356f.akpm@linux-foundation.org>
	<20100720224525.GO32635@dastard>
	<20100720174424.12a4bf64.akpm@linux-foundation.org>
	<20100721052007.GT32635@dastard>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jul 2010 15:20:07 +1000 Dave Chinner <david@fromorbit.com> wrote:

> > and they were dirtied within dquot_free_space().
> 
> AFAICT dquot_free_space() is called deep in the guts of
> ext3_truncate() via dquot_free_block(), which is called directly
> before end_writeback(). That should overwrite any state changes made
> inside ext3_truncate. I wonder if iput_final() is racing with
> something else here?
> 

This isn't a race.  I type `make' and the warnings spew out at hundreds
per second - every unlink, I'd say.

Did you try my .config?
