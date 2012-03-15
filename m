Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032045Ab2CORnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:43:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46409 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032053Ab2CORnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:43:07 -0400
Date: Thu, 15 Mar 2012 17:43:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch 0/5] seqlock consolidation
Message-ID: <20120315174305.GD8943@ZenIV.linux.org.uk>
References: <20120314170736.617746873@linutronix.de>
 <20120315122112.GB8943@ZenIV.linux.org.uk>
 <alpine.LFD.2.02.1203151322020.2466@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1203151322020.2466@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 01:28:03PM +0100, Thomas Gleixner wrote:

> The only way out is to lock d->d_lock which is contended, so the
> reader side boosts the writer and waits for the lock to be
> released. Though with the open coded seqlock we have no idea which
> lock we need to take.
> 
> Any better ideas ?

So basically you want RT stuff to know that several areas in fs/dcache.c
(from write_seqcount_begin() to write_seqcount_end()) are protected by
(already held by that point) ->d_lock of corresponding dentries?

If that's it, I suggest to look for a solution that would express just that...
Or do you want something on the reader side as well?
