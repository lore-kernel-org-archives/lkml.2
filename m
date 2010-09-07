Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab0IGUX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 16:23:28 -0400
Received: from www.tglx.de ([62.245.132.106]:40887 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829Ab0IGUX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 16:23:26 -0400
Date: Tue, 7 Sep 2010 22:23:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 00/30] semaphore cleanup
In-Reply-To: <201009071938.17681.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1009072219400.2477@localhost6.localdomain6>
References: <20100907124636.880953480@linutronix.de> <201009071727.55023.arnd@arndb.de> <alpine.LFD.2.00.1009071736100.2477@localhost6.localdomain6> <201009071938.17681.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Tue, 7 Sep 2010, Arnd Bergmann wrote:

> On Tuesday 07 September 2010 17:38:33 Thomas Gleixner wrote:
> > Some of those can be converted to completions, but most of them have
> > utterly borked semantics. I'm not sure if its worth the trouble to
> > actually change all this as most of that stuff is ancient. Real
> > semaphores are not going away (at least not the counting type ones).
> 
> Ok. I thought I had seen a series from Ingo some time ago that actually
> converted all of them to something else, but maybe I was mistaken.
> 
> Not sure if there is anything to be gained (other than more work) from
> merging semaphore and rw_semaphore into a single implementation that
> is both counting and read-write.
> 
> One problem I see (not with your series, just with semaphores in
> general) is that they keep creeping in through drivers/staging: About
> half the users we currently have are in staging. Obviously they get
> removed from there in order for drivers to graduate from staging, but
> not exposing the interface to device drivers would reduce the number
> of bad choices for authors to make.

sure, but most of them are really the init_MUTEX[_LOCKED] type which
has been copied over and over again for almost a decade.

That's going away, so people are actually forced to look into the
alternative solutions. And I do not worry too much about staging/*

Thanks,

	tglx
