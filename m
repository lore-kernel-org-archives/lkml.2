Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab0F2Rl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 13:41:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:58947 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367Ab0F2Rl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 13:41:27 -0400
Date: Wed, 30 Jun 2010 03:41:22 +1000
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch 02/52] fs: fix superblock iteration race
Message-ID: <20100629174122.GN28364@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030725.885831564@suse.de>
 <20100629130214.GA21410@infradead.org>
 <20100629145617.GG28364@laptop>
 <AANLkTinCVQdekiLlU4_tRkkcSGYWV6NG7nlvTirl5xZF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinCVQdekiLlU4_tRkkcSGYWV6NG7nlvTirl5xZF@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 10:35:47AM -0700, Linus Torvalds wrote:
> On Tue, Jun 29, 2010 at 7:56 AM, Nick Piggin <npiggin@suse.de> wrote:
> > On Tue, Jun 29, 2010 at 09:02:14AM -0400, Christoph Hellwig wrote:
> >> This should actually be on it's way to Linus for .35, shouldn't it?
> >
> > Yeah, I was waiting for Al to reappear, but I think this is
> > probably the nicest way to solve the problem. Linus?
> 
> I'll apply it. We have a couple of oopses listed for the superblock
> iterator, and I haven't heard from Al. And the patch looks obviously
> fine, whether it's actually the cause of some of the bugs or not.

OK. I only have managed to get it into an infininte loop but I think
it would be surely possible to oops it because the next pointer can
be uninitialised memory at that point.

