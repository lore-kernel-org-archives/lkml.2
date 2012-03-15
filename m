Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761772Ab2COMVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 08:21:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41546 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758774Ab2COMVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 08:21:17 -0400
Date: Thu, 15 Mar 2012 12:21:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch 0/5] seqlock consolidation
Message-ID: <20120315122112.GB8943@ZenIV.linux.org.uk>
References: <20120314170736.617746873@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314170736.617746873@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 11:44:22AM -0000, Thomas Gleixner wrote:

> Aside of that replacing open coded constructs with proper functions is
> a worthwhile cleanup by itself.

Provided that those are proper primitives to start with...  I don't like
it - most of ->d_lock uses are _not_ related to ->d_seq, to start with
and then we get an interesting mix of functions that do and do not assume
the lock already taken, etc.

Could you describe RT patch problems in more details?  I really don't like
this solution - interface is overcomplicated and doesn't fit well...
