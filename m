Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab1DOEW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 00:22:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38391 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1DOEW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 00:22:57 -0400
Date: Fri, 15 Apr 2011 00:22:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Guntsche <mike@it-loops.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: 2.6.39 Block layer regression was [Bug] Boot hangs with
 2.6.39-rc[123]]
Message-ID: <20110415042255.GC27928@infradead.org>
References: <20110415035451@it-loops.com>
 <BANLkTi=50A4f_d0a0oESd3DMMaK1za5BWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=50A4f_d0a0oESd3DMMaK1za5BWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 08:25:33PM -0700, Linus Torvalds wrote:
> What's the thinking there? It looks very confused to me.

It is.  I sent a patch a couple of days ago to fix it.

> Now, clearly RAID seems to be involved in the problem? The main thing
> with that would be that the execution of the requests would tend to
> generate new requests, that go back on the plug queue. Yes? And the
> loop in flush_plug_list() means that they all should get flushed out,
> I assume. But something clearly isn't working, and it does seem to be
> about the RAID kind of setup. So either they didn't get put on the
> plug queue, or the task got a new plug (which _wasn't_ flushed).
> 
> Because we're clearly waiting for some request that hasn't completed.
> Where in the plug queues would it be hiding?

There's a thread where Neil explains what the problem with MD is - it
needs a callback on unplug time to generate e.g. the write intent bitmap
or as large as possible writes for RAID5.  Jens and Neil have been
looking into it.

