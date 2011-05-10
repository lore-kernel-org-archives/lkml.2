Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab1EJOr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:47:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40847 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab1EJOrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:47:55 -0400
Subject: Re: [PATCH v3 5/6] x86-64: Move vread_tsc into a new file with
 sensible options
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <84f1b1e345955d38309678d578ccdff9de6eca7b.1305035945.git.luto@mit.edu>
References: <cover.1305035945.git.luto@mit.edu>
	 <84f1b1e345955d38309678d578ccdff9de6eca7b.1305035945.git.luto@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 16:36:02 +0200
Message-ID: <1305038162.2914.93.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 10:15 -0400, Andy Lutomirski wrote:
> vread_tsc is short and hot, and it's userspace code so the usual
> reasons to keep frame pointers around, enable -pg, and turn off
> sibling calls don't apply.
> 
I really don't like that, turning off frame pointers here means that if
your profiler interrupt hits while in the vDSO the user-space backtrace
is dead.

Please leave the frame pointer in. Esp on x86_64 the cost of keeping the
framepointer isn't much at all since it isn't nearly as register starved
as i386.

I'm fine with stripping -pg, that is indeed useless for the vDSO.

