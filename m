Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab0JRTUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:20:15 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:33263 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831Ab0JRTUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:20:11 -0400
Date: Mon, 18 Oct 2010 20:19:36 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Shinya Kuribayashi <skuribay@pobox.com>
Cc: Kevin Cernekee <cernekee@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 5/9] MIPS: sync after cacheflush
Message-ID: <20101018191936.GH27377@linux-mips.org>
References: <17ebecce124618ddf83ec6fe8e526f93@localhost>
 <17d8d27a2356640a4359f1a7dcbb3b42@localhost>
 <4CBC4F4E.5010305@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBC4F4E.5010305@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 10:44:46PM +0900, Shinya Kuribayashi wrote:

> I suspect that SYNC insn alone is still not enough, insn't it?  In
> such systems with that 'deep' write buffer and data incoherency is
> visibly observed, there sill may be data write transactions floating
> in the internal bus system.

A SYNC in theory should ensure global visibilty of preceding writes and
completion of earlier reads.  That usually works between CPUs but not
all I/O systems fully participate in that "consistency domain" so more
or less arbitary shaking of the I/O system may still be required to to
achieve consistency.

> To make sure that all data (data inside processor's write buffer and
> data floating in the internal bus system), we need the following
> three steps:
> 
> 1. Flush data cache
> 2. Uncached, dummy load operation from _DRAM_ (not somewhere else)
> 3. then SYNC instruction
> 
> With these steps, data in write buffer will be pushed out of the
> processor's write buffer, wait for uncached load operation to be
> completed, and then finally the pipeline gets cleared.  Thoughts?

I'm trying to get a statement from the MIPS architecture guys if the
necessity to do anything beyond a cache flush is an architecture violation.

Don't worry, I'm not going to refuse patches for something just because
it's not complying to a piece of paper as long as the silicon is in the
wild.

  Ralf
