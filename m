Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab0C3Isq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:48:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:39752 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab0C3Iso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:48:44 -0400
Subject: Re: [PATCH] lockdep fix incorrect percpu usage
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>, stable <stable@kernel.org>
In-Reply-To: <20100330033425.GD7683@Krystal>
References: <20100330033425.GD7683@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 30 Mar 2010 10:47:56 +0200
Message-ID: <1269938876.5109.510.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 23:34 -0400, Mathieu Desnoyers wrote:
> Should use per_cpu_ptr() to obfuscate the per cpu pointers (RELOC_HIDE is needed
> for per cpu pointers).
> 
> git blame points to commit:
> 
> lockdep.c: commit 8e18257d29238311e82085152741f0c3aa18b74d
> 
> But it's really just moving the code around. But it's enough to say that the
> problems appeared before Jul 19 01:48:54 2007, which brings us back to 2.6.23.
> 
> So it should be applied to stable 2.6.23.x to 2.6.33.x (or whichever of these
> stable branches are still maintained) and to mainline 2.6.34-rc2.

well, definately not to mainline, since that code is utterly busted in
mainline due to recent per-cpu changes.
