Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab0IGPjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:39:03 -0400
Received: from www.tglx.de ([62.245.132.106]:58477 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757500Ab0IGPi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:38:57 -0400
Date: Tue, 7 Sep 2010 17:38:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 00/30] semaphore cleanup
In-Reply-To: <201009071727.55023.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1009071736100.2477@localhost6.localdomain6>
References: <20100907124636.880953480@linutronix.de> <201009071727.55023.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Sep 2010, Arnd Bergmann wrote:

> On Tuesday 07 September 2010, Thomas Gleixner wrote:
> > init_MUTEX[_LOCKED] and DECLARE_MUTEX are deprecated for quite some
> > time. Cleanup the remaining users and remove the cruft.
> 
> How many of these really need to be semaphores and can't be converted
> to mutex or completion? I thought that we wanted to send the classic
> semaphore the same way as the BKL eventually.

Some of those can be converted to completions, but most of them have
utterly borked semantics. I'm not sure if its worth the trouble to
actually change all this as most of that stuff is ancient. Real
semaphores are not going away (at least not the counting type ones).

Thanks,

	tglx
